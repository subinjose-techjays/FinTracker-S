/// Represents the different events that can occur on the login screen.
sealed class LoginEvent {}

/// Event triggered to initiate Google Sign In authentication.
class GoogleSignInEvent extends LoginEvent {}

/// Event triggered to show a bottom sheet.
class ShowBottomSheet extends LoginEvent {}
