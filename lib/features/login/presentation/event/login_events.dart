/// Represents the different events that can occur on the login screen.
sealed class LoginEvent {}

/// Event triggered to validate the entered email and password.
/// This event carries the [email] and [password] values entered by the user.
class ValidateValues extends LoginEvent {
  final String email;
  final String password;

  ValidateValues({required this.email, required this.password});
}

/// Event triggered to show a bottom sheet.
class ShowBottomSheet extends LoginEvent {}