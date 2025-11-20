import '../../../../shared/utils/constants.dart';
import '../state/log_in_validation.dart';

class PasswordValidator {
  PasswordValidation validate(String password) {
    if (password.isEmpty) {
      return EmptyPasswordValidation();
    } else if (password.length < passwordMinLength) {
      return WeakPasswordValidation();
    } else {
      return ValidPasswordValidation();
    }
  }
}