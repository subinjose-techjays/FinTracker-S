import '../repository/chat_repository.dart';

class ChatUseCase {
  final ChatRepository _repository;

  ChatUseCase(this._repository);

  Future<bool> checkModelStatus() {
    return _repository.isModelDownloaded();
  }

  Future<void> initializeModel() {
    return _repository.initialize();
  }

  Future<void> downloadModel({
    required Function(int received, int total) onProgress,
  }) {
    return _repository.downloadModel(onProgress: onProgress);
  }

  Future<void> loadModelFromFile(String path) {
    return _repository.loadModelFromFile(path);
  }

  Stream<String> sendMessage(String prompt) {
    return _repository.generateResponse(prompt);
  }
}
