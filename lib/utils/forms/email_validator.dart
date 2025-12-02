import 'package:formz/formz.dart';

enum EmailValidationError {
  empty,
  invalidFormat,
}

extension EmailValidationErrorX on EmailValidationError {
  bool get isEmpty => this == .empty;
  bool get isInvalidFormat => this == .invalidFormat;
}

/// A FormzInput class for validating email addresses.
class EmailValidator extends FormzInput<String, EmailValidationError> {
  const EmailValidator.pure() : super.pure('');
  const EmailValidator.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return .empty;
    }
    // Check if the email matches the regex pattern
    if (!_emailRegex.hasMatch(value)) {
      return .invalidFormat;
    }
    return null; // No error
  }
}