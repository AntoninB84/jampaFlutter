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
  bool get isEmpty => this == .empty;
  bool get isTooShort => this == .tooShort;
  bool get hasNoUppercase => this == .noUppercase;
  bool get hasNoLowercase => this == .noLowercase;
  bool get hasNoNumber => this == .noNumber;
  bool get hasNoSpecialCharacter => this == .noSpecialCharacter;
}

/// A FormzInput class for validating passwords.
/// The password must be at least 8 characters long and include
/// uppercase letters, lowercase letters, numbers, and special characters.
class PasswordValidator extends FormzInput<String, PasswordValidationError> {
  const PasswordValidator.pure() : super.pure('');
  const PasswordValidator.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return .empty;
    } else if (value.length < 8) {
      return .tooShort;
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return .noUppercase;
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return .noLowercase;
    } else if (!RegExp(r'\d').hasMatch(value)) {
      return .noNumber;
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return .noSpecialCharacter;
    }
    return null; // No error
  }
}