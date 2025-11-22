import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_dimens.dart';

class ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final VoidCallback onStop;
  final bool isGenerating;

  const ChatInputArea({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onStop,
    required this.isGenerating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spacing8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: AppStrings.typeMessageHint,
                border: OutlineInputBorder(),
              ),
              enabled: !isGenerating,
              onSubmitted: (value) {
                if (value.isNotEmpty && !isGenerating) {
                  onSend(value);
                }
              },
            ),
          ),
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isGenerating ? Icons.stop : Icons.send,
                key: ValueKey<bool>(isGenerating),
                color: isGenerating ? Colors.red : null,
              ),
            ),
            onPressed: () {
              if (isGenerating) {
                onStop();
              } else if (controller.text.isNotEmpty) {
                onSend(controller.text);
              }
            },
          ),
        ],
      ),
    );
  }
}
