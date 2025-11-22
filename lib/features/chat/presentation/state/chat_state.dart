import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/chat_message.dart';
import 'chat_effect.dart';

part 'chat_state.freezed.dart';

enum ChatStatus { initial, loading, downloading, ready, error }

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default(ChatStatus.initial) ChatStatus status,
    @Default([]) List<ChatMessage> messages,
    @Default(0.0) double downloadProgress,
    String? errorMessage,
    ChatEffect? oneShotEvent,
  }) = _ChatState;

  const ChatState._();
}
