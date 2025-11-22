import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../viewmodel/chat_viewmodel.dart';
import '../state/chat_state.dart';
import '../state/chat_effect.dart';
import '../event/chat_event.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message.substring(0, 200)),
                backgroundColor: Colors.red,
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
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(AppStrings.modelNotFound),
              const SizedBox(height: AppDimens.spacing16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(chatViewModelProvider.notifier)
                      .onEvent(const ChatEvent.downloadModel());
                },
                child: const Text(AppStrings.downloadModel),
              ),
              const SizedBox(height: AppDimens.spacing16),
              OutlinedButton(
                onPressed: () {
                  ref
                      .read(chatViewModelProvider.notifier)
                      .onEvent(const ChatEvent.pickModelFile());
                },
                child: const Text(AppStrings.pickModel),
              ),
              const SizedBox(height: AppDimens.spacing16),
              const Text(
                AppStrings.downloadRequirement,
                style: TextStyle(
                  fontSize: AppDimens.fontSize12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case ChatStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ChatStatus.downloading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(AppStrings.downloadingModel),
              const SizedBox(height: AppDimens.spacing16),
              LinearProgressIndicator(value: state.downloadProgress),
              const SizedBox(height: AppDimens.spacing8),
              Text('${(state.downloadProgress * 100).toStringAsFixed(1)}%'),
              const SizedBox(height: AppDimens.spacing8),
              const Text(
                AppStrings.downloadTimeWarning,
                style: TextStyle(
                  fontSize: AppDimens.fontSize12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      case ChatStatus.error:
        // If we have messages, show chat with error snackbar (handled by listener)
        // If no messages and error status, show error center widget
        if (state.messages.isNotEmpty) {
          return _buildChat(state.messages);
        }
        return Center(
          child: Text('${AppStrings.errorPrefix}${state.errorMessage}'),
        );
      case ChatStatus.ready:
        return _buildChat(state.messages);
    }
  }

  Widget _buildChat(List<dynamic> messages) {
    // dynamic to avoid import issue if ChatMessage not imported, but it is.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            padding: const EdgeInsets.all(AppDimens.spacing16),
            itemBuilder: (context, index) {
              final message = messages[index];
              return Align(
                alignment: message.isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: AppDimens.spacing4,
                  ),
                  padding: const EdgeInsets.all(AppDimens.spacing12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(AppDimens.radius12),
                  ),
                  constraints: BoxConstraints(
                    maxWidth:
                        MediaQuery.of(context).size.width *
                        AppDimens.maxWidthRatio,
                  ),
                  child: message.isUser
                      ? Text(
                          message.text,
                          style: const TextStyle(color: Colors.white),
                        )
                      : MarkdownBody(data: message.text),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDimens.spacing8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: AppStrings.typeMessageHint,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      ref
                          .read(chatViewModelProvider.notifier)
                          .onEvent(ChatEvent.sendMessage(value));
                      _controller.clear();
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    ref
                        .read(chatViewModelProvider.notifier)
                        .onEvent(ChatEvent.sendMessage(_controller.text));
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
