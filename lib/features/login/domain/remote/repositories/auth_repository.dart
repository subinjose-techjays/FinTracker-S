

import 'package:firebase_auth/firebase_auth.dart';

/// Represents the contract for authentication-related data operations.
///
/// This abstract class defines the methods that any authentication repository
/// implementation must provide. It allows for a separation of concerns,
/// enabling different authentication providers (e.g., Firebase, custom API)
/// to be used interchangeably while following the Dependency Inversion Principle.
abstract class AuthRepository {
  /// Signs in the user with Google authentication.
  ///
  /// Returns a [Future<UserCredential>] representing the authenticated user.
  /// Throws an exception if authentication fails.
  Future<UserCredential> signInWithGoogle();

  /// Signs out the current user from all authentication providers.
  ///
  /// Returns a [Future<void>] that completes when sign out is successful.
  Future<void> signOut();
}
