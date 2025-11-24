import 'package:formz/formz.dart';

enum NameValidationError {
  empty,
  invalidLength
}

extension NameValidationErrorX on NameValidationError {
  bool get isEmpty => this == NameValidationError.empty;
  bool get isInvalidLength => this == NameValidationError.invalidLength;
}

/// A FormzInput class for validating names.
/// The name must be between 3 and 120 characters long.
class NameValidator extends FormzInput<String, NameValidationError> {
  const NameValidator.pure() : super.pure('');
  const NameValidator.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return NameValidationError.empty;
    } else if (value.length < 3 || value.length > 120) {
      return NameValidationError.invalidLength;
    }
    return null;
  }
}