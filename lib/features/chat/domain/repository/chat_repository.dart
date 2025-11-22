

abstract class ChatRepository {
  Future<void> initialize();
  Future<bool> isModelDownloaded();
  Future<void> downloadModel({
    required Function(int received, int total) onProgress,
  });
  Future<void> loadModelFromFile(String path);
  Stream<String> generateResponse(String prompt);
}
