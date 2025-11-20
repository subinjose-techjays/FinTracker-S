import 'package:fin_tracker/features/login/presentation/state/log_in_validation.dart';

import '../remote/repositories/login_repository.dart';

/// It depends on a [LoginRepository] to abstract the data source.
class LoginDataUseCase {
  /// The repository responsible for fetching login data.
  final LoginRepository repository;

  /// Creates an instance of [LoginDataUseCase].
  ///
  /// Requires a [LoginRepository] to be provided.
  LoginDataUseCase(this.repository);

  /// Executes the use case to fetch login data.
  ///
  /// Returns a [Future] that completes with a [String] representing
  /// the fetched data.
  LoginPair<EmailValidation, PasswordValidation> validateCredentials(
    String email,
    password,
  ) {
    return repository.validateEmailPassword(email, password);
  }
}
