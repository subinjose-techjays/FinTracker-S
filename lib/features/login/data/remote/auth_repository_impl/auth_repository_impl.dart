import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/remote/repositories/auth_repository.dart';

/// Implementation of the [AuthRepository] interface using Firebase Auth.
///
/// This class handles the actual authentication logic using Firebase Authentication.
/// It follows the Single Responsibility Principle by only handling authentication operations.
class AuthRepositoryImpl implements AuthRepository {
  /// Firebase Auth instance for authentication operations.
  final FirebaseAuth _firebaseAuth;

  /// Creates an instance of [AuthRepositoryImpl].
  ///
  /// Requires a [FirebaseAuth] instance to be provided for testability.
  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Create Google Auth Provider
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Add required scopes for basic profile information
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      // Sign in with Firebase Auth using Google Provider
      final userCredential = await _firebaseAuth.signInWithProvider(
        googleProvider,
      );

      return userCredential;
    } catch (e) {
      throw Exception('Google Sign In failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }
}
