import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tar/tar.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import '../../domain/repository/chat_repository.dart';
import '../../../../core/constants/app_constants.dart';

/// Chat Repository Implementation with Gemma AI Model
///
/// Uses flutter_gemma (wrapping MediaPipe) for intelligent financial conversations.
/// Requires Flutter Master channel and physical iOS device for optimal performance.

class ChatRepositoryImpl implements ChatRepository {
  InferenceChat? _chat;
  final Dio _dio;

  ChatRepositoryImpl({required Dio dio}) : _dio = dio;
  final String _modelUrl =
      'https://drive.usercontent.google.com/download?id=1wIbr-IymtH75mt0LK4Z0EHp8ix1OuxSy&export=download&authuser=1&confirm=t&uuid=97ab1524-0786-4e41-b4d7-10facb0ddddb&at=ALWLOp5YTtCYbCb2bk8mgoIaZkAE:1763702562459';
  final String _modelFileName = 'gemma-3n-E2B-it-int4.task';

  @override
  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    final modelPath = '${dir.path}/$_modelFileName';

    if (await File(modelPath).exists()) {
      try {
        // Clear XNNPACK cache to prevent "Cannot reserve space" crash on Android
        if (Platform.isAndroid) {
          // Check in Documents directory (just in case)
          final docCacheFile = File('$modelPath.xnnpack_cache');
          if (await docCacheFile.exists()) {
            await docCacheFile.delete();
          }

          // Check in Cache directory (where logs indicate it is)
          final tempDir = await getTemporaryDirectory();
          final tempCacheFile = File(
            '${tempDir.path}/$_modelFileName.xnnpack_cache',
          );
          if (await tempCacheFile.exists()) {
            await tempCacheFile.delete();
          }
        }

        // Initialize FlutterGemma with the local model file
        await FlutterGemma.installModel(
          modelType: ModelType.gemmaIt,
        ).fromFile(modelPath).install();

        final model = await FlutterGemma.getActiveModel(
          maxTokens: AppConstants.gemmaMaxTokens,
        );
        _chat = await model.createChat();

        print('Gemma model initialized successfully at $modelPath');
      } catch (e) {
        print('Failed to initialize Gemma engine: $e');
        throw Exception('Failed to initialize AI engine. Error: $e');
      }
    } else {
      throw Exception('Gemma model not found. Please download it first.');
    }
  }

  @override
  Future<bool> isModelDownloaded() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_modelFileName');
    return file.exists();
  }

  @override
  Future<void> downloadModel({
    required Function(int received, int total) onProgress,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final archivePath = '${dir.path}/model_archive.tar.gz';

    // 1. Download the Gemma model archive
    await _dio.download(
      _modelUrl,
      archivePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          onProgress(received, total);
        }
      },
    );

    // 2. Extract the archive using streaming (tar package)
    final file = File(archivePath);
    // Open the file as a stream of bytes
    final fileStream = file.openRead();
    // Decompress using GZip
    final decompressedStream = fileStream.transform(gzip.decoder);
    // Read tar entries
    final reader = TarReader(decompressedStream);

    bool found = false;
    try {
      while (await reader.moveNext()) {
        final entry = reader.current;
        if (entry.type == TypeFlag.reg && entry.name.endsWith('.task')) {
          final taskFile = File('${dir.path}/$_modelFileName');
          // Pipe the entry content stream directly to the file
          await entry.contents.pipe(taskFile.openWrite());
          found = true;
          break; // Stop after finding the model
        }
      }
    } finally {
      await reader.cancel();
    }

    // 3. Cleanup
    await file.delete();

    if (!found) {
      throw Exception('No .task file found in the downloaded Gemma archive.');
    }

    // 4. Initialize after download
    await initialize();
  }

  @override
  Future<void> loadModelFromFile(String path) async {
    final dir = await getApplicationDocumentsDirectory();
    final targetFile = File('${dir.path}/$_modelFileName');
    final sourceFile = File(path);

    if (await sourceFile.exists()) {
      await sourceFile.copy(targetFile.path);
      await initialize();
    } else {
      throw Exception('Selected file does not exist.');
    }
  }

  @override
  Stream<String> generateResponse(String prompt) async* {
    if (_chat == null) {
      // Try to initialize if not already done (e.g. if app restarted)
      try {
        await initialize();
      } catch (e) {
        throw Exception('Engine not initialized and Gemma model not found.');
      }
    }

    if (_chat == null) throw Exception('Failed to initialize Gemma engine.');

    // Generate response using FlutterGemma
    // 1. Add the user's message to the chat history
    await _chat!.addQueryChunk(Message.text(text: prompt, isUser: true));

    // 2. Generate the response stream
    final stream = _chat!
        .generateChatResponseAsync()
        .where((response) => response is TextResponse)
        .map((response) => (response as TextResponse).token);

    yield* stream;
  }
}
