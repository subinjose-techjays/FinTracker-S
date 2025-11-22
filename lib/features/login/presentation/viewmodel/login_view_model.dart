import 'dart:async';

import 'package:fin_tracker/features/login/domain/usecases/auth_usecases.dart';
import 'package:fin_tracker/features/login/presentation/event/login_events.dart';
import 'package:riverpod/riverpod.dart';
import '../state/login_state/login_effect.dart';
import '../state/login_state/login_state.dart';
import '../../../../core/constants/app_strings.dart';

/// Manages the state and business logic for the login feature.
///
/// This ViewModel is responsible for handling Google Sign In authentication
/// using the provided use case. It exposes a [Stream] of [LoginEffect]
/// to notify the UI about side effects like navigation or showing messages.
/// It also holds the current [LoginState] which represents the UI state
/// (initial, loading, error, etc.).
class LoginViewModel extends StateNotifier<LoginState> {
  /// Use case for handling Google Sign In authentication.
  final GoogleSignInUseCase googleSignInUseCase;

  /// Stream controller for emitting side effects to the UI.
  final _effectController = StreamController<LoginEffect>.broadcast();

  /// Exposes the stream of side effects.
  Stream<LoginEffect> get effectStream => _effectController.stream;

  /// Creates an instance of [LoginViewModel].
  ///
  /// Requires a [GoogleSignInUseCase] to be provided for dependency injection.
  /// Initializes the state to [LoginState.initial].
  LoginViewModel(this.googleSignInUseCase) : super(const LoginState.initial());

  /// Handles incoming [LoginEvent]s from the UI.
  ///
  /// This method Pattern matches on the [event] type to determine the appropriate action.
  void onEvent(LoginEvent event) {
    switch (event) {
      /// When a [ShowBottomSheet] event is received, it emits a [ShowBottomSheetEffect]
      /// to the UI.
      case ShowBottomSheet():
        _effectController.add(ShowBottomSheetEffect());
        break;

      /// When a [GoogleSignInEvent] event is received, it triggers the
      /// [_signInWithGoogle] method.
      case GoogleSignInEvent():
        _signInWithGoogle();
    }
  }

  /// Signs in the user with Google using the provided use case.
  ///
  /// Sets the state to [LoginState.loading] before initiating the sign in process.
  /// If sign in is successful, it emits a [NavigateToDashBoard] effect.
  /// If sign in fails, it sets the state to [LoginState.miscError] with an error message.
  void _signInWithGoogle() async {
    state = const LoginState.loading();
    try {
      // Execute the Google Sign In use case
      await googleSignInUseCase.execute();

      // If successful, navigate to dashboard
      _effectController.add(NavigateToDashBoard());
    } catch (e) {
      state = LoginState.miscError(
        '${AppStrings.googleSignInFailed}${e.toString()}',
      );
    }
  }

  /// Cleans up resources when the ViewModel is disposed.
  ///
  /// Closes the [_effectController] to prevent memory leaks.
  @override
  void dispose() {
    _effectController.close();
    super.dispose();
  }
}
