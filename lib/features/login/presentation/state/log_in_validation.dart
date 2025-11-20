/// Represents the different validation states for a password.
///
/// This sealed class is used to define specific states that a password
/// input can be in during validation.
sealed class PasswordValidation {}

/// Represents the state where the password input is empty.
class EmptyPasswordValidation extends PasswordValidation {}

/// Represents the state where the password does not meet the minimum character requirement.
class CharsMinimumValidation extends PasswordValidation {}

/// Represents the state where the password is considered weak.
class WeakPasswordValidation extends PasswordValidation {}

/// Represents the state where the password input is considered valid.
class ValidPasswordValidation extends PasswordValidation {}



/// Represents the different validation states for an email address.
///
/// This sealed class is used to define specific states that an email
/// input can be in during validation, such as empty, invalid format, or valid.
sealed class EmailValidation {}

/// Represents the state where the email input is empty.
class EmptyEmailValidation extends EmailValidation {}

/// Represents the state where the email input does not match the
/// required regular expression for a valid email format.
class EmailRegexInvalidValidation extends EmailValidation {}

/// Represents the state where the email input is considered valid.
class ValidEmailValidation extends EmailValidation {}


// Represents a pair of validation states for email and password.
///
/// This class is used to hold the current validation status for both
/// the email and password fields, typically in a login or registration form.
///
/// The generic types `EmailValidation` and `PasswordValidation` allow for
/// specific validation state types to be used, providing flexibility in
/// how validation is handled.
class LoginPair<EmailValidation, PasswordValidation> {
  final EmailValidation emailValidation;
  final PasswordValidation passwordValidation;

  const LoginPair(this.emailValidation, this.passwordValidation);
}
