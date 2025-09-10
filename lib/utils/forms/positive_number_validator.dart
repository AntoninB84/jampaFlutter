import 'package:formz/formz.dart';

enum PositiveNumberValidationError {
  invalidValue
}

extension PositiveNumberValidationErrorX on PositiveNumberValidationError {
  bool get isInvalidValue => this == PositiveNumberValidationError.invalidValue;
}

class PositiveValueValidator extends FormzInput<int?, PositiveNumberValidationError> {
  const PositiveValueValidator.pure() : super.pure(1);
  const PositiveValueValidator.dirty([super.value = 1]) : super.dirty();

  @override
  PositiveNumberValidationError? validator(int? value) {
    if (value == null || value < 0) {
      return PositiveNumberValidationError.invalidValue;
    }
    return null;
  }
}