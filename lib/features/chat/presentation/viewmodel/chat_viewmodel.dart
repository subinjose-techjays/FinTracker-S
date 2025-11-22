import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/usecase/chat_usecase.dart';
import '../../di/chat_provider.dart';
import '../state/chat_state.dart';
import '../state/chat_effect.dart';
import '../event/chat_event.dart';
import '../../domain/entity/chat_message.dart';
import '../../../../core/constants/app_strings.dart';

final chatViewModelProvider = StateNotifierProvider<ChatViewModel, ChatState>((
  ref,
) {
  return ChatViewModel(ref.read(chatUseCaseProvider));
});

class ChatViewModel extends StateNotifier<ChatState> {
  final ChatUseCase _chatUseCase;

  ChatViewModel(this._chatUseCase) : super(const ChatState()) {
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
      final isDownloaded = await _chatUseCase.checkModelStatus();
      if (isDownloaded) {
        await _chatUseCase.initializeModel();
        state = state.copyWith(status: ChatStatus.ready);
      } else {
        state = state.copyWith(status: ChatStatus.initial);
      }
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
        oneShotEvent: ChatEffect.showError(e.toString()),
      );
    }
  }

  Future<void> _downloadModel() async {
    state = state.copyWith(status: ChatStatus.downloading, downloadProgress: 0);
    try {
      await _chatUseCase.downloadModel(
        onProgress: (received, total) {
          if (total != -1) {
            state = state.copyWith(downloadProgress: received / total);
          }
        },
      );
      await _chatUseCase.initializeModel();
      state = state.copyWith(status: ChatStatus.ready);
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: "${AppStrings.downloadFailed}${e.toString()}",
        oneShotEvent: ChatEffect.showError(
          "${AppStrings.downloadFailed}${e.toString()}",
        ),
      );
    }
  }

  Future<void> _pickModelFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null && result.files.single.path != null) {
        state = state.copyWith(
          status: ChatStatus.downloading,
          downloadProgress: 0,
        );
        await _chatUseCase.loadModelFromFile(result.files.single.path!);
        state = state.copyWith(status: ChatStatus.ready);
      }
    } catch (e) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: "${AppStrings.loadModelFailed}${e.toString()}",
        oneShotEvent: ChatEffect.showError(
          "${AppStrings.loadModelFailed}${e.toString()}",
        ),
      );
    }
  }

  Future<void> _sendMessage(String text) async {
    if (state.status != ChatStatus.ready) return;

    final currentMessages = List<ChatMessage>.from(state.messages);
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(messages: [...currentMessages, userMessage]);

    try {
      final responseStream = _chatUseCase.sendMessage(text);
      String fullResponse = "";

      // Add placeholder bot message
      state = state.copyWith(
        messages: [
          ...currentMessages,
          userMessage,
          ChatMessage(
            text: AppStrings.botPlaceholder,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ],
      );

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
        state = state.copyWith(messages: updatedMessages);
      }
    } catch (e) {
      // Don't change status to error to preserve chat history
      state = state.copyWith(oneShotEvent: ChatEffect.showError(e.toString()));
    }
  }
}
