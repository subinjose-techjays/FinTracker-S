import 'package:firebase_auth/firebase_auth.dart';

import '../remote/repositories/auth_repository.dart';

/// Use case for handling Google Sign In authentication.
///
/// This use case encapsulates the business logic for Google Sign In authentication.
/// It follows the Single Responsibility Principle by only handling Google authentication.
/// It depends on an [AuthRepository] to abstract the authentication implementation.
class GoogleSignInUseCase {
  /// The repository responsible for authentication operations.
  final AuthRepository authRepository;

  /// Creates an instance of [GoogleSignInUseCase].
  ///
  /// Requires an [AuthRepository] to be provided for dependency injection.
  GoogleSignInUseCase(this.authRepository);

  /// Executes the Google Sign In authentication.
  ///
  /// Returns a [Future<UserCredential>] representing the authenticated user.
  /// Throws an exception if authentication fails.
  Future<UserCredential> execute() async {
    return await authRepository.signInWithGoogle();
  }
}

/// Use case for handling user sign out.
///
/// This use case encapsulates the business logic for signing out users.
/// It follows the Single Responsibility Principle by only handling sign out operations.
class SignOutUseCase {
  /// The repository responsible for authentication operations.
  final AuthRepository authRepository;

  /// Creates an instance of [SignOutUseCase].
  ///
  /// Requires an [AuthRepository] to be provided for dependency injection.
  SignOutUseCase(this.authRepository);

  /// Executes the sign out operation.
  ///
  /// Returns a [Future<void>] that completes when sign out is successful.
  Future<void> execute() async {
    return await authRepository.signOut();
  }
}
