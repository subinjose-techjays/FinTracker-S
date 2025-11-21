import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    onEvent(CheckModelStatusEvent());
  }

  void onEvent(ChatEvent event) {
    switch (event) {
      case CheckModelStatusEvent():
        _checkModelStatus();
        break;
      case DownloadModelEvent():
        _downloadModel();
        break;
      case SendMessageEvent(message: final msg):
        _sendMessage(msg);
        break;
    }
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
      _effectController.add(ShowErrorEffect(e.toString()));
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
        ShowErrorEffect("Download failed: ${e.toString()}"),
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
      _effectController.add(ShowErrorEffect(e.toString()));
    }
  }

  @override
  void dispose() {
    _effectController.close();
    super.dispose();
  }
}
