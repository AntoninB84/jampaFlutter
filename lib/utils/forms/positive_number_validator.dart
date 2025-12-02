import 'package:formz/formz.dart';

enum PositiveNumberValidationError {
  invalidValue
}

extension PositiveNumberValidationErrorX on PositiveNumberValidationError {
  bool get isInvalidValue => this == .invalidValue;
}

/// A FormzInput class for validating positive numbers (greater than or equal to 0).
class PositiveValueValidator extends FormzInput<int?, PositiveNumberValidationError> {
  const PositiveValueValidator.pure() : super.pure(1);
  const PositiveValueValidator.dirty([super.value = 1]) : super.dirty();

  @override
  PositiveNumberValidationError? validator(int? value) {
    if (value == null || value < 0) {
      return .invalidValue;
    }
    return null;
  }
}