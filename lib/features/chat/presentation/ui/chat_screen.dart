import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../viewmodel/chat_viewmodel.dart';
import '../state/chat_state.dart';
import '../state/chat_effect.dart';
import '../event/chat_event.dart';

import '../widgets/chat_input_area.dart';
import '../widgets/chat_message_item.dart';
import '../widgets/chat_model_views.dart';
import '../widgets/typing_indicator.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: AppDimens.duration300ms),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatViewModelProvider);

    // Listen for one-shot events
    ref.listen(chatViewModelProvider.select((s) => s.oneShotEvent), (
      _,
      effect,
    ) {
      if (effect != null) {
        effect.when(
          showError: (message) {
            final displayText = message.length > 200
                ? message.substring(0, 200)
                : message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(displayText),
                backgroundColor: Colors.yellow,
              ),
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.chatTitle)),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(ChatState state) {
    switch (state.status) {
      case ChatStatus.initial:
        return ChatModelInitialView(
          onDownload: () {
            ref
                .read(chatViewModelProvider.notifier)
                .onEvent(const ChatEvent.downloadModel());
          },
          onPickFile: () {
            ref
                .read(chatViewModelProvider.notifier)
                .onEvent(const ChatEvent.pickModelFile());
          },
        );
      case ChatStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ChatStatus.downloading:
        return ChatModelDownloadView(progress: state.downloadProgress);
      case ChatStatus.error:
        if (state.messages.isNotEmpty) {
          return _buildChat(state);
        }
        return Center(
          child: Text('${AppStrings.errorPrefix}${state.errorMessage}'),
        );
      case ChatStatus.ready:
        return _buildChat(state);
    }
  }

  Widget _buildChat(ChatState state) {
    // Only scroll if new messages added (simple check, can be improved)
    if (state.messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.messages.length + (state.isGenerating ? 1 : 0),
            padding: const EdgeInsets.all(AppDimens.spacing16),
            itemBuilder: (context, index) {
              if (index == state.messages.length) {
                return const Align(
                  alignment: Alignment.centerLeft,
                  child: TypingIndicator(),
                );
              }
              return ChatMessageItem(message: state.messages[index]);
            },
          ),
        ),
        ChatInputArea(
          controller: _controller,
          isGenerating: state.isGenerating,
          onSend: (text) {
            ref
                .read(chatViewModelProvider.notifier)
                .onEvent(ChatEvent.sendMessage(text));
            _controller.clear();
          },
          onStop: () {
            ref
                .read(chatViewModelProvider.notifier)
                .onEvent(const ChatEvent.stopGeneration());
          },
        ),
      ],
    );
  }
}
