import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/repository/chat_repository.dart';
import '../../data/repository/chat_repository_impl.dart';
import '../state/chat_state.dart';
import '../state/chat_effect.dart';
import '../event/chat_event.dart';
import '../../domain/entity/chat_message.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepositoryImpl(),
);

final chatViewModelProvider = StateNotifierProvider<ChatViewModel, ChatState>((
  ref,
) {
  return ChatViewModel(ref.read(chatRepositoryProvider));
});

class ChatViewModel extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  final _effectController = StreamController<ChatEffect>.broadcast();

  Stream<ChatEffect> get effectStream => _effectController.stream;

  ChatViewModel(this._repository) : super(const ChatState.initial()) {
    onEvent(const ChatEvent.checkModelStatus());
  }

  void onEvent(ChatEvent event) {
    event.map(
      checkModelStatus: (_) => _checkModelStatus(),
      downloadModel: (_) => _downloadModel(),
      pickModelFile: (_) => _pickModelFile(),
      sendMessage: (e) => _sendMessage(e.message),
    );
  }

  Future<void> _checkModelStatus() async {
    try {
      final isDownloaded = await _repository.isModelDownloaded();
      if (isDownloaded) {
        await _repository.initialize();
        state = const ChatState.ready([]);
      } else {
        state = const ChatState.initial();
      }
    } catch (e) {
      state = ChatState.error(e.toString());
      _effectController.add(ChatEffect.showError(e.toString()));
    }
  }

  Future<void> _downloadModel() async {
    state = const ChatState.downloading(0);
    try {
      await _repository.downloadModel(
        onProgress: (received, total) {
          if (total != -1) {
            state = ChatState.downloading(received / total);
          }
        },
      );
      await _repository.initialize();
      state = const ChatState.ready([]);
    } catch (e) {
      state = ChatState.error("Download failed: ${e.toString()}");
      _effectController.add(
        ChatEffect.showError("Download failed: ${e.toString()}"),
      );
    }
  }

  Future<void> _pickModelFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null && result.files.single.path != null) {
        state = const ChatState.downloading(0); // Show loading state
        await _repository.loadModelFromFile(result.files.single.path!);
        state = const ChatState.ready([]);
      }
    } catch (e) {
      state = ChatState.error("Failed to load model: ${e.toString()}");
      _effectController.add(
        ChatEffect.showError("Failed to load model: ${e.toString()}"),
      );
    }
  }

  Future<void> _sendMessage(String text) async {
    final currentState = state;
    if (currentState is! ChatStateReady) return;

    final currentMessages = List<ChatMessage>.from(currentState.messages);
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = ChatState.ready([...currentMessages, userMessage]);

    try {
      final responseStream = _repository.generateResponse(text);
      String fullResponse = "";

      // Add placeholder bot message
      state = ChatState.ready([
        ...currentMessages,
        userMessage,
        ChatMessage(text: "...", isUser: false, timestamp: DateTime.now()),
      ]);

      await for (final chunk in responseStream) {
        fullResponse += chunk;
        // Update the last message with new content
        final updatedMessages = List<ChatMessage>.from(currentMessages)
          ..add(userMessage)
          ..add(
            ChatMessage(
              text: fullResponse,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        state = ChatState.ready(updatedMessages);
      }
    } catch (e) {
      state = ChatState.error(e.toString());
      _effectController.add(ChatEffect.showError(e.toString()));
    }
  }

  @override
  void dispose() {
    _effectController.close();
    super.dispose();
  }
}
