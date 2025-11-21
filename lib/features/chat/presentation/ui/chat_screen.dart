import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
              SnackBar(content: Text(message), backgroundColor: Colors.red),
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat with Gemma AI')),
      body: state.when(
        initial: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Gemma AI Model not found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(chatViewModelProvider.notifier)
                      .onEvent(const ChatEvent.downloadModel());
                },
                child: const Text('Download Gemma 2B Model'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  ref
                      .read(chatViewModelProvider.notifier)
                      .onEvent(const ChatEvent.pickModelFile());
                },
                child: const Text('Pick Model from Files'),
              ),
              const SizedBox(height: 16),
              const Text(
                '~500MB download required\n⚠️ Requires physical iOS device\n(Not compatible with simulators)',
                style: TextStyle(fontSize: 12, color: Colors.grey),
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
              const Text('Downloading Gemma 2B AI Model...'),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 8),
              Text('${(progress * 100).toStringAsFixed(1)}%'),
              const SizedBox(height: 8),
              const Text(
                'This may take several minutes',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        error: (message) => Center(child: Text('Error: $message')),
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
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
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
