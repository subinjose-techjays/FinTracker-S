import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import '../data/remote/auth_repository_impl/auth_repository_impl.dart';
import '../domain/remote/repositories/auth_repository.dart';
import '../domain/usecases/auth_usecases.dart';
import '../presentation/state/login_state/login_effect.dart';
import '../presentation/state/login_state/login_state.dart';
import '../presentation/viewmodel/login_view_model.dart';

/// Provides the Firebase Auth instance.
///
/// This provider creates a singleton instance of FirebaseAuth for dependency injection.
/// This allows for better testability and follows the Dependency Inversion Principle.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provides the concrete implementation of [AuthRepository].
///
/// This provider is responsible for creating an instance of [AuthRepositoryImpl],
/// which handles the actual authentication logic using Firebase Auth.
/// Other parts of the application can use this provider to access the
/// authentication repository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthRepositoryImpl(firebaseAuth);
});

/// Provides the [GoogleSignInUseCase].
///
/// This provider creates an instance of [GoogleSignInUseCase], which encapsulates
/// the business logic for Google Sign In authentication. It depends on the
/// [authRepositoryProvider] to get an instance of [AuthRepository].
final googleSignInUseCaseProvider = Provider<GoogleSignInUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoogleSignInUseCase(authRepository);
});

/// Provides the [SignOutUseCase].
///
/// This provider creates an instance of [SignOutUseCase], which encapsulates
/// the business logic for user sign out. It depends on the
/// [authRepositoryProvider] to get an instance of [AuthRepository].
final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(authRepository);
});

/// Provides the [LoginViewModel].
///
/// This provider creates an instance of [LoginViewModel], which is responsible
/// for managing the state of the login screen and handling user interactions.
/// It depends on the [googleSignInUseCaseProvider] to get an instance of
/// [GoogleSignInUseCase] for authentication.
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      final googleSignInUseCase = ref.watch(googleSignInUseCaseProvider);
      return LoginViewModel(googleSignInUseCase);
    });

final loginEffectProvider = StreamProvider<LoginEffect?>((ref) {
  return ref.watch(loginViewModelProvider.notifier).effectStream;
});
