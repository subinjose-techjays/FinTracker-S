

import 'package:fin_tracker/features/login/presentation/state/log_in_validation.dart';

/// Represents the contract for login-related data operations.
///
/// This abstract class defines the methods that any login repository
/// implementation must provide. It allows for a separation of concerns,
/// enabling different data sources (e.g., remote API, local database)
/// to be used interchangeably.
abstract class LoginRepository {
  LoginPair<EmailValidation, PasswordValidation> validateEmailPassword(
    String email,
    String password,
  );
}
