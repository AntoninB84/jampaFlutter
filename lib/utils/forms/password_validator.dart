import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  tooShort,
  noUppercase,
  noLowercase,
  noNumber,
  noSpecialCharacter,
}

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