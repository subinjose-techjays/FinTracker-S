sealed class ChatEffect {}

class ShowErrorEffect extends ChatEffect {
  final String message;
  ShowErrorEffect(this.message);
}
