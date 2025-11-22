import 'dart:async';
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
  late final StreamSubscription<ChatEffect> _effectSubscription;

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(chatViewModelProvider.notifier);
    _effectSubscription = notifier.effectStream.listen((effect) {
      if (mounted) {
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
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _effectSubscription.cancel();
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

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.chatTitle)),
      body: state.when(
        initial: () => Center(
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
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        downloading: (progress) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(AppStrings.downloadingModel),
              const SizedBox(height: AppDimens.spacing16),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: AppDimens.spacing8),
              Text('${(progress * 100).toStringAsFixed(1)}%'),
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
        ),
        error: (message) =>
            Center(child: Text('${AppStrings.errorPrefix}$message')),
        ready: (messages) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );
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
                          borderRadius: BorderRadius.circular(
                            AppDimens.radius12,
                          ),
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
        },
      ),
    );
  }
}
