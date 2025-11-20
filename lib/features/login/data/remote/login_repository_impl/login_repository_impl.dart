import 'package:fin_tracker/features/login/presentation/state/log_in_validation.dart';
import '../../../domain/remote/repositories/login_repository.dart';
import '../../../presentation/utils/email_validation.dart';
import '../../../presentation/utils/password_validation.dart';

/// Implementation of the [LoginRepository] interface.
///
/// This class handles the actual data fetching logic for login-related operations.

class LoginRepositoryImpl implements LoginRepository {
  final EmailValidator _emailValidator = EmailValidator();
  final PasswordValidator _passwordValidator = PasswordValidator();


  @override
  LoginPair<EmailValidation, PasswordValidation> validateEmailPassword(
      String email,
      String password,) {
    final emailResult = _emailValidator.validate(email);
    final passwordResult = _passwordValidator.validate(password);

    return LoginPair(emailResult, passwordResult);
  }
}
