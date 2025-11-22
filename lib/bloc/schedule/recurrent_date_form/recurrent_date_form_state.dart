part of 'recurrent_date_form_bloc.dart';

class RecurrentDateFormState extends Equatable {

  /// Indicates whether the form is in editing mode or creating a new recurrent date.
  final bool isEditing;

  /// Holds the current values of the recurrent date form elements.
  final RecurrenceFormElements newRecurrentDateFormElements;

  /// Validator for the interval days input field.
  final PositiveValueValidator intervalDaysValidator;
  /// Validator for the interval years input field.
  final PositiveValueValidator intervalYearsValidator;
  /// Validator for the month day input field.
  final MonthDayValidator monthDateValidator;

  /// Validation flags for start date
  final bool isValidStartDate;
  /// Validation flags for end date
  final bool isValidEndDate;
  /// Validation flags for end recurrence date
  final bool isValidEndRecurrenceDate;

  const RecurrentDateFormState({
    this.isEditing = false,
    required this.newRecurrentDateFormElements,
    this.intervalDaysValidator = const PositiveValueValidator.pure(),
    this.intervalYearsValidator = const PositiveValueValidator.pure(),
    this.monthDateValidator = const MonthDayValidator.pure(),
    this.isValidStartDate = true,
    this.isValidEndDate = true,
    this.isValidEndRecurrenceDate = true,
});

  @override
  List<Object?> get props => [
    isEditing,
    newRecurrentDateFormElements,
    intervalDaysValidator,
    intervalYearsValidator,
    monthDateValidator,
    isValidStartDate,
    isValidEndDate,
    isValidEndRecurrenceDate,
  ];

  RecurrentDateFormState copyWith({
    bool? isEditing,
    RecurrenceFormElements? newRecurrentDateFormElements,
    PositiveValueValidator? intervalDaysValidator,
    PositiveValueValidator? intervalYearsValidator,
    MonthDayValidator? monthDateValidator,
    bool? isValidStartDate,
    bool? isValidEndDate,
    bool? isValidEndRecurrenceDate,
  }) {
    return RecurrentDateFormState(
      isEditing: isEditing ?? this.isEditing,
      newRecurrentDateFormElements: newRecurrentDateFormElements ?? this.newRecurrentDateFormElements,
      intervalDaysValidator: intervalDaysValidator ?? this.intervalDaysValidator,
      intervalYearsValidator: intervalYearsValidator ?? this.intervalYearsValidator,
      monthDateValidator: monthDateValidator ?? this.monthDateValidator,
      isValidStartDate: isValidStartDate ?? this.isValidStartDate,
      isValidEndDate: isValidEndDate ?? this.isValidEndDate,
      isValidEndRecurrenceDate: isValidEndRecurrenceDate ?? this.isValidEndRecurrenceDate,
    );
  }

  bool get checkRecurrenceEndDate {
    if(newRecurrentDateFormElements.selectedRecurrenceEndDate == null) {
      return true;
    }
    if(newRecurrentDateFormElements.selectedRecurrenceEndDate != null) {
      DateTime? start = newRecurrentDateFormElements.selectedStartDateTime;
      DateTime? end = newRecurrentDateFormElements.selectedEndDateTime;
      DateTime recurrenceEnd = newRecurrentDateFormElements.selectedRecurrenceEndDate!;
      if(start != null){
        if(start.isAfter(recurrenceEnd)) {
          return false;
        }
      }
      if(end != null){
        if(end.isAfter(recurrenceEnd)) {
          return false;
        }
      }
    }
    return true;
  }

  bool get checkValidEndDate {
    DateTime? start = newRecurrentDateFormElements.selectedStartDateTime;
    DateTime? end = newRecurrentDateFormElements.selectedEndDateTime;
    if(start != null && end != null) {
      return !end.isBefore(start);
    }
    return true;
  }

  bool get isValidRecurrenceType {
    return newRecurrentDateFormElements.selectedRecurrenceType != null;
  }

  bool get isRecurrenceValueValid {
    if(newRecurrentDateFormElements.selectedRecurrenceType == RecurrenceType.intervalDays) {
      return intervalDaysValidator.isValid;
    }
    if(newRecurrentDateFormElements.selectedRecurrenceType == RecurrenceType.intervalYears) {
      return intervalYearsValidator.isValid;
    }
    if(newRecurrentDateFormElements.selectedRecurrenceType == RecurrenceType.dayBasedMonthly) {
      return monthDateValidator.isValid;
    }
    if(newRecurrentDateFormElements.selectedRecurrenceType == RecurrenceType.dayBasedWeekly) {
      if(newRecurrentDateFormElements.selectedRecurrenceWeekdays == null
          || newRecurrentDateFormElements.selectedRecurrenceWeekdays!.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool get isValidFormValues {
    return isValidStartDate && isValidEndDate && isValidEndRecurrenceDate
        && isRecurrenceValueValid && isValidRecurrenceType;
  }
}
