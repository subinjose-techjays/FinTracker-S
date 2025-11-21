sealed class ChatEvent {}

class DownloadModelEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;
  SendMessageEvent(this.message);
}

class CheckModelStatusEvent extends ChatEvent {}
