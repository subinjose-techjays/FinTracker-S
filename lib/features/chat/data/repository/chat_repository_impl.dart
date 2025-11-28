import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import '../../domain/repository/chat_repository.dart';
import '../../../../core/constants/app_constants.dart';
import '../extensions/file_extensions.dart';

/// Chat Repository Implementation with Gemma AI Model
///
/// Uses flutter_gemma (wrapping MediaPipe) for intelligent financial conversations.
/// Requires Flutter Master channel and physical iOS device for optimal performance.

class ChatRepositoryImpl implements ChatRepository {
  InferenceChat? _chat;
  final Dio _dio;
  bool _isFirstMessage = true;

  ChatRepositoryImpl({required Dio dio}) : _dio = dio;
  final String _modelUrl = AppConstants.gemmaModelUrl;
  final String _modelFileName = AppConstants.gemmaModelFileName;

  @override
  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    final modelPath = '${dir.path}/$_modelFileName';

    if (await File(modelPath).exists()) {
      try {
        // Clear model cache to prevent "Cannot reserve space" crash on Android
        await File(modelPath).clearModelCache(_modelFileName);

        // Initialize FlutterGemma with the local model file
        await FlutterGemma.installModel(
          modelType: ModelType.gemmaIt,
        ).fromFile(modelPath).install();

        final model = await FlutterGemma.getActiveModel(
          maxTokens: AppConstants.gemmaMaxTokens,
          preferredBackend: PreferredBackend.gpu,
        );
        _chat = await model.createChat();
        _isFirstMessage = true;

        print('Gemma model initialized successfully at $modelPath');
      } catch (e) {
        print('Failed to initialize Gemma engine: $e');
        // If it was a native crash (which we can't catch in Dart, but if we get here), rethrow
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
    final found = await file.extractGemmaModel(dir.path, _modelFileName);

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
  void resetSession() {
    _chat = null;
    _isFirstMessage = true;
    // Since createChat() is async and requires the model, we can just set _chat to null.
    // The next generateResponse will call initialize() which creates a new chat.
  }

  @override
  Stream<String> generateResponse(String prompt, {String? context}) async* {
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

    final buffer = StringBuffer();

    if (_isFirstMessage) {
      buffer.write("${AppConstants.systemInstruction}\n\n");
      _isFirstMessage = false;
    }

    if (context != null) {
      buffer.write("Context: $context\n\n");
    }

    buffer.write(prompt);

    await _chat!.addQueryChunk(
      Message.text(text: buffer.toString(), isUser: true),
    );

    // 2. Generate the response stream
    final stream = _chat!
        .generateChatResponseAsync()
        .where((response) => response is TextResponse)
        .map((response) => (response as TextResponse).token);

    yield* stream;
  }
}
