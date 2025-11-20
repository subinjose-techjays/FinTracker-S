import 'package:fin_tracker/shared/utils/extensions.dart';

import '../state/log_in_validation.dart';

class EmailValidator {
  EmailValidation validate(String email) {
    if (email.isEmpty) {
      return EmptyEmailValidation();
    } else if (!email.isValidEmail) { // Assuming isValidEmail is an extension method
      return EmailRegexInvalidValidation();
    } else {
      return ValidEmailValidation();
    }
  }
}