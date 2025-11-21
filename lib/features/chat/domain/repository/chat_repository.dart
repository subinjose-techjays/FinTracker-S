import '../entity/chat_message.dart';

abstract class ChatRepository {
  Future<void> initialize();
  Future<bool> isModelDownloaded();
  Future<void> downloadModel({
    required Function(int received, int total) onProgress,
  });
  Stream<String> generateResponse(String prompt);
}
