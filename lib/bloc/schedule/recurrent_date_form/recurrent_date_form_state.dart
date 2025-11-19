part of 'recurrent_date_form_bloc.dart';

class RecurrentDateFormState extends Equatable {
  /// To determine how to handle calls to [SaveNoteBloc]
  final bool isSavingPersistentData;

  final RecurrenceFormElements newRecurrentDateFormElements;

  final PositiveValueValidator intervalDaysValidator;
  final PositiveValueValidator intervalYearsValidator;
  final MonthDayValidator monthDateValidator;

  final bool isValidStartDate;
  final bool isValidEndDate;
  final bool isValidEndRecurrenceDate;

  const RecurrentDateFormState({
    this.isSavingPersistentData = false,
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
    isSavingPersistentData,
    newRecurrentDateFormElements,
    intervalDaysValidator,
    intervalYearsValidator,
    monthDateValidator,
    isValidStartDate,
    isValidEndDate,
    isValidEndRecurrenceDate,
  ];

  RecurrentDateFormState copyWith({
    bool? isSavingPersistentData,
    RecurrenceFormElements? newRecurrentDateFormElements,
    PositiveValueValidator? intervalDaysValidator,
    PositiveValueValidator? intervalYearsValidator,
    MonthDayValidator? monthDateValidator,
    bool? isValidStartDate,
    bool? isValidEndDate,
    bool? isValidEndRecurrenceDate,
  }) {
    return RecurrentDateFormState(
      isSavingPersistentData: isSavingPersistentData ?? this.isSavingPersistentData,
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
