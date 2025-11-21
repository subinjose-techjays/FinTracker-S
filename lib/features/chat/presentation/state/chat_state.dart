import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/chat_message.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = ChatStateInitial;
  const factory ChatState.loading() = ChatStateLoading;
  const factory ChatState.downloading(double progress) = ChatStateDownloading;
  const factory ChatState.ready(List<ChatMessage> messages) = ChatStateReady;
  const factory ChatState.error(String message) = ChatStateError;
}
