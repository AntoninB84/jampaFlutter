import 'package:formz/formz.dart';

enum EmailValidationError {
  empty,
  invalidFormat,
}

extension EmailValidationErrorX on EmailValidationError {
  bool get isEmpty => this == EmailValidationError.empty;
  bool get isInvalidFormat => this == EmailValidationError.invalidFormat;
}

class EmailValidator extends FormzInput<String, EmailValidationError> {
  const EmailValidator.pure() : super.pure('');
  const EmailValidator.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    // Check if the email matches the regex pattern
    if (!_emailRegex.hasMatch(value)) {
      return EmailValidationError.invalidFormat;
    }
    return null; // No error
  }
}