import 'dart:async';

import 'package:fin_tracker/features/login/presentation/event/login_events.dart';
import 'package:fin_tracker/features/login/presentation/state/log_in_validation.dart';
import 'package:fin_tracker/shared/utils/validation_messages.dart';
import 'package:riverpod/riverpod.dart';
import '../../domain/usecases/login_data_usecase.dart';
import '../state/login_credentials/login_credentials.dart';
import '../state/login_state/login_effect.dart';
import '../state/login_state/login_state.dart';

/// Manages the state and business logic for the login feature.
///
/// This ViewModel is responsible for handling user interactions,
/// validating input, and communicating with the [LoginDataUseCase]
/// to perform login operations. It exposes a [Stream] of [LoginEffect]
/// to notify the UI about side effects like navigation or showing messages.
/// It also holds the current [LoginState] which represents the UI state
/// (initial, loading, error, etc.).
class LoginViewModel extends StateNotifier<LoginState> {
  /// Use case for handling login data operations.
  final LoginDataUseCase loginDataUseCase;

  /// Stream controller for emitting side effects to the UI.
  final _effectController = StreamController<LoginEffect>.broadcast();

  /// Exposes the stream of side effects.
  Stream<LoginEffect> get effectStream => _effectController.stream;

  /// Holds the current login credentials entered by the user.
  LoginCredentials loginCredentials = LoginCredentials();

  /// Creates an instance of [LoginViewModel].
  ///
  /// Takes a [LoginDataUseCase] to interact with the domain layer.
  /// Initializes the state to [LoginState.initial].
  LoginViewModel(this.loginDataUseCase) : super(const LoginState.initial());

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

      /// When a [ValidateValues] event is received, it triggers the
      /// [_validateCredentials] method.
      case ValidateValues():
        _validateCredentials(event.email, event.password);
    }
  }

  /// Validates the provided [email] and [password].
  ///
  /// Sets the state to [LoginState.loading] before making the validation call.
  /// If validation is successful (both email and password are valid),
  /// it emits a [NavigateToDashBoard] effect.
  /// If validation fails, it updates the state to [LoginState.error] with
  /// the specific validation errors.
  /// If any other exception occurs, it sets the state to [LoginState.miscError].
  void _validateCredentials(String email, String password) async {
    state = const LoginState.loading();
    try {
      final result = loginDataUseCase.validateCredentials(email, password);

      if (result.passwordValidation is ValidPasswordValidation &&
          result.emailValidation is ValidEmailValidation) {
        _effectController.add(NavigateToDashBoard());
      } else {
        state = LoginState.error(validationErrors: result);
      }
    } catch (e) {
      state = LoginState.miscError(ValidationMessages.somethingWentWrong);
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
