import 'dart:io';
import 'package:tar/tar.dart';
import 'package:path_provider/path_provider.dart';

extension FileExtensions on File {
  /// Clears the XNNPACK cache and other TFLite artifacts associated with this file on Android.
  /// This helps prevent "Cannot reserve space" crashes and "File not found" errors for cache files.
  Future<void> clearXnnpackCache(String modelFileName) async {
    if (!Platform.isAndroid) return;

    try {
      // Check in Documents directory (just in case)
      final docCacheFile = File('$path.xnnpack_cache');
      if (await docCacheFile.exists()) {
        await docCacheFile.delete();
      }

      // Check in Cache directory (where logs indicate it is)
      final tempDir = await getTemporaryDirectory();

      // Clear .xnnpack_cache
      final tempCacheFile = File(
        '${tempDir.path}/$modelFileName.xnnpack_cache',
      );
      if (await tempCacheFile.exists()) {
        await tempCacheFile.delete();
      }

      // Clear .bin cache files (e.g. gemma-3n-E4B-it-int4.task_15218672120674176464.bin)
      // These appear to be TFLite/MediaPipe cache files that can cause issues if missing/corrupt
      final tempDirList = tempDir.listSync();
      for (var entity in tempDirList) {
        if (entity is File &&
            entity.path.contains(modelFileName) &&
            entity.path.endsWith('.bin')) {
          await entity.delete();
          print('Deleted TFLite cache file: ${entity.path}');
        }
      }
    } catch (e) {
      print('Error clearing TFLite/XNNPACK cache: $e');
    }
  }

  /// Extracts the Gemma model from a tar.gz archive.
  /// Returns true if the model file was found and extracted.
  Future<bool> extractGemmaModel(String targetDir, String modelFileName) async {
    // Open the file as a stream of bytes
    final fileStream = openRead();
    // Decompress using GZip
    final decompressedStream = fileStream.transform(gzip.decoder);
    // Read tar entries
    final reader = TarReader(decompressedStream);

    bool found = false;
    try {
      while (await reader.moveNext()) {
        final entry = reader.current;
        if (entry.type == TypeFlag.reg && entry.name.endsWith('.task')) {
          final taskFile = File('$targetDir/$modelFileName');
          // Pipe the entry content stream directly to the file
          await entry.contents.pipe(taskFile.openWrite());
          found = true;
          break; // Stop after finding the model
        }
      }
    } finally {
      await reader.cancel();
    }
    return found;
  }
}
