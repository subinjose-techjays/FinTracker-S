import 'package:fin_tracker/features/login/presentation/state/log_in_validation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;

  const factory LoginState.loading() = _Loading;

  const factory LoginState.error({
    required LoginPair<EmailValidation, PasswordValidation> validationErrors,
  }) = _Error;


  const factory LoginState.miscError(String errorMessage) = _MiscError;
}
