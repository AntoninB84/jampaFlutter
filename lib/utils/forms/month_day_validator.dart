import 'package:formz/formz.dart';

enum MonthDayValidationError {
  invalidValue
}

extension MonthDayValidationErrorX on MonthDayValidationError {
  bool get isInvalidValue => this == MonthDayValidationError.invalidValue;
}

class MonthDayValidator extends FormzInput<int?, MonthDayValidationError> {
  const MonthDayValidator.pure() : super.pure(1);
  const MonthDayValidator.dirty([super.value = 1]) : super.dirty();

  @override
  MonthDayValidationError? validator(int? value) {
    if (value == null || value <= 0 || value > 31) {
      return MonthDayValidationError.invalidValue;
    }
    return null;
  }
}