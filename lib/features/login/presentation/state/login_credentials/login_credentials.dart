import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_credentials.freezed.dart';

/// Represents the data structure for login credentials.
///
/// This class uses the `freezed` package to generate immutable
/// value objects and includes support for JSON serialization.
///
/// Parameters:
///   [email] - The email address for login. Defaults to an empty string.
///   [password] - The password for login. Defaults to an empty string.
@freezed
class LoginCredentials with _$LoginCredentials {
  const factory LoginCredentials({
    @Default('') String email,
    @Default('') String password
  }) = _LoginCredentials;
}
