import '../../../../core/constants/app_constants.dart';
import '../state/log_in_validation.dart';

class PasswordValidator {
  PasswordValidation validate(String password) {
    if (password.isEmpty) {
      return EmptyPasswordValidation();
    } else if (password.length < AppConstants.passwordMinLength) {
      return WeakPasswordValidation();
    } else {
      return ValidPasswordValidation();
    }
  }
}
