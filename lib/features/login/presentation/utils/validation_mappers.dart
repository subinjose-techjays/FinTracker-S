import 'package:fin_tracker/features/login/presentation/state/log_in_validation.dart';
import 'package:fin_tracker/shared/utils/validation_messages.dart';

extension EmailValidator on EmailValidation {
  String get emailValidationMessages {
    switch (this) {
      case EmptyEmailValidation():
        return ValidationMessages.emptyEmailAddress;
      case EmailRegexInvalidValidation():
        return ValidationMessages.emailRegexMessage;
      default:
        return ValidationMessages.emptyMessage;
    }
  }
}

extension PasswordValidator on PasswordValidation {
  String get passwordValidationMessages {
    switch (this) {
      case EmptyPasswordValidation():
        return ValidationMessages.emptyPasswordMessage;
      case CharsMinimumValidation():
        return ValidationMessages.minLengthPasswordMessage;
      case WeakPasswordValidation():
        return ValidationMessages.weakPasswordMessage;
      default:
        return ValidationMessages.emptyMessage;
    }
  }
}
