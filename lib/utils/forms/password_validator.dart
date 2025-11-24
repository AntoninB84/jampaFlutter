import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  tooShort,
  noUppercase,
  noLowercase,
  noNumber,
  noSpecialCharacter,
}

extension PasswordValidationErrorX on PasswordValidationError {
  bool get isEmpty => this == PasswordValidationError.empty;
  bool get isTooShort => this == PasswordValidationError.tooShort;
  bool get hasNoUppercase => this == PasswordValidationError.noUppercase;
  bool get hasNoLowercase => this == PasswordValidationError.noLowercase;
  bool get hasNoNumber => this == PasswordValidationError.noNumber;
  bool get hasNoSpecialCharacter => this == PasswordValidationError.noSpecialCharacter;
}

/// A FormzInput class for validating passwords.
/// The password must be at least 8 characters long and include
/// uppercase letters, lowercase letters, numbers, and special characters.
class PasswordValidator extends FormzInput<String, PasswordValidationError> {
  const PasswordValidator.pure() : super.pure('');
  const PasswordValidator.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidationError.tooShort;
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return PasswordValidationError.noUppercase;
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return PasswordValidationError.noLowercase;
    } else if (!RegExp(r'\d').hasMatch(value)) {
      return PasswordValidationError.noNumber;
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return PasswordValidationError.noSpecialCharacter;
    }
    return null; // No error
  }
}