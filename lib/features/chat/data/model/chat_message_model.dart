import '../../domain/entity/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.text,
    required super.isUser,
    required super.timestamp,
  });

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      text: entity.text,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
    );
  }
}
