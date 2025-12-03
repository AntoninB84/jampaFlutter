import 'package:formz/formz.dart';
import 'package:jampa_flutter/utils/constants/constants.dart';

enum NameValidationError {
  empty,
  invalidLength
}

extension NameValidationErrorX on NameValidationError {
  bool get isEmpty => this == .empty;
  bool get isInvalidLength => this == .invalidLength;
}

/// A FormzInput class for validating names.
/// The name must be between [kEntityNameMinLength] and [kEntityNameMaxLength] characters long.
class NameValidator extends FormzInput<String, NameValidationError> {
  const NameValidator.pure() : super.pure('');
  const NameValidator.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return .empty;
    } else if (value.length < kEntityNameMinLength || value.length > kEntityNameMaxLength) {
      return .invalidLength;
    }
    return null;
  }
}