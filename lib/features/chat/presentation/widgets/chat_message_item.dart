import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../domain/entity/chat_message.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppDimens.spacing4),
        padding: const EdgeInsets.all(AppDimens.spacing12),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(AppDimens.radius12),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * AppDimens.maxWidthRatio,
        ),
        child: message.isUser
            ? Text(message.text, style: const TextStyle(color: Colors.white))
            : MarkdownBody(data: message.text),
      ),
    );
  }
}
