/// Validates an email string.
///
/// This extension provides a getter `isValidEmail` that can be used
/// on any string to check if it conforms to a common email format.
extension EmailValidator on String {
  bool get isValidEmail {
    final regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return regex.hasMatch(this);
  }
}
