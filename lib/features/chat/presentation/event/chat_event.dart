import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_event.freezed.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.downloadModel() = DownloadModelEvent;
  const factory ChatEvent.sendMessage(String message) = SendMessageEvent;
  const factory ChatEvent.checkModelStatus() = CheckModelStatusEvent;
  const factory ChatEvent.pickModelFile() = PickModelFileEvent;
  const factory ChatEvent.stopGeneration() = StopGenerationEvent;
  const factory ChatEvent.resetChat() = ResetChatEvent;
}
