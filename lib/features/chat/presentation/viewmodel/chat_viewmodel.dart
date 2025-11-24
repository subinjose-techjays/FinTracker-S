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
  StreamSubscription? _responseSubscription;

  ChatViewModel(this._chatUseCase) : super(const ChatState()) {
    onEvent(const ChatEvent.checkModelStatus());
  }

  void onEvent(ChatEvent event) {
    event.map(
      checkModelStatus: (_) => _checkModelStatus(),
      downloadModel: (_) => _downloadModel(),
      pickModelFile: (_) => _pickModelFile(),
      sendMessage: (e) => _sendMessage(e.message),
      stopGeneration: (_) => _stopGeneration(),
      resetChat: (_) => _resetChat(),
    );
  }

  void _resetChat() {
    _chatUseCase.resetSession();
    state = state.copyWith(
      messages: [],
      status: ChatStatus.ready,
      isGenerating: false,
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

  @override
  void dispose() {
    _responseSubscription?.cancel();
    super.dispose();
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

  Future<void> _sendMessage(String text, {String? context}) async {
    if (state.status != ChatStatus.ready) return;

    final currentMessages = List<ChatMessage>.from(state.messages);
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...currentMessages, userMessage],
      isGenerating: true,
    );

    try {
      final responseStream = _chatUseCase.sendMessage(text, context: context);
      String fullResponse = "";

      // Add placeholder bot message
      // state = state.copyWith(
      //   messages: [
      //     ...currentMessages,
      //     userMessage,
      //     ChatMessage(
      //       text: AppStrings.botPlaceholder,
      //       isUser: false,
      //       timestamp: DateTime.now(),
      //     ),
      //   ],
      _responseSubscription?.cancel();
      _responseSubscription = responseStream.listen(
        (chunk) {
          fullResponse += chunk;
          // Update the last message with new content
          // If it's the first chunk, add a new message. Otherwise update the last one.
          // Since we removed the placeholder, we need to handle the first chunk differently.

          List<ChatMessage> updatedMessages;
          if (fullResponse.length == chunk.length) {
            updatedMessages = List<ChatMessage>.from(currentMessages)
              ..add(userMessage)
              ..add(
                ChatMessage(
                  text: fullResponse,
                  isUser: false,
                  timestamp: DateTime.now(),
                ),
              );
          } else {
            updatedMessages = List<ChatMessage>.from(currentMessages)
              ..add(userMessage)
              ..add(
                ChatMessage(
                  text: fullResponse,
                  isUser: false,
                  timestamp: DateTime.now(),
                ),
              );
            // Actually, since we are rebuilding the list from currentMessages + userMessage + botMessage every time,
            // the logic is the same. We just need to make sure we don't duplicate the bot message if we were appending.
            // But here we are reconstructing the whole list ending with the bot message.
            // So the previous logic works fine, it just replaces the "placeholder" (which we didn't add to state) with the real message.
          }

          state = state.copyWith(messages: updatedMessages);
        },
        onDone: () {
          state = state.copyWith(isGenerating: false);
        },
        onError: (e) {
          state = state.copyWith(
            isGenerating: false,
            oneShotEvent: ChatEffect.showError(e.toString()),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        oneShotEvent: ChatEffect.showError(e.toString()),
      );
    }
  }

  void _stopGeneration() {
    _responseSubscription?.cancel();
    _responseSubscription = null;
    state = state.copyWith(
      isGenerating: false,
      oneShotEvent: const ChatEffect.showError(AppStrings.generationStopped),
    );
  }
}
