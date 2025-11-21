import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_effect.freezed.dart';

@freezed
abstract class ChatEffect with _$ChatEffect {
  const factory ChatEffect.showError(String message) = ShowErrorEffect;
}
