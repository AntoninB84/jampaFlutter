part of 'recurrent_date_form_bloc.dart';

sealed class RecurrentDateFormEvent extends Equatable {
  const RecurrentDateFormEvent();
}

/// Event to initialize the recurrent date form
final class InitializeRecurrentDateFormEvent extends RecurrentDateFormEvent {
  final String noteId;
  final String? scheduleId;

  const InitializeRecurrentDateFormEvent({
    required this.noteId,
    required this.scheduleId,
  });

  @override
  List<Object?> get props => [noteId, scheduleId];
}

/// Event to select the recurrence type
final class SelectRecurrenceTypeEvent extends RecurrentDateFormEvent {
  const SelectRecurrenceTypeEvent({required this.recurrenceType});

  final RecurrenceType? recurrenceType;

  @override
  List<Object?> get props => [recurrenceType];
}

/// Event to change the recurrence day interval
final class ChangeRecurrenceDayIntervalEvent extends RecurrentDateFormEvent {
  const ChangeRecurrenceDayIntervalEvent({required this.interval});

  final String interval;

  @override
  List<Object?> get props => [interval];
}

/// Event to change the recurrence year interval
final class ChangeRecurrenceYearIntervalEvent extends RecurrentDateFormEvent {
  const ChangeRecurrenceYearIntervalEvent({required this.interval});

  final String interval;

  @override
  List<Object?> get props => [interval];
}

/// Event to change the recurrence month date
final class ChangeRecurrenceMonthDateEvent extends RecurrentDateFormEvent {
  const ChangeRecurrenceMonthDateEvent({required this.day});

  final String day;

  @override
  List<Object?> get props => [day];
}

/// Event to change the recurrence week days
final class ChangeRecurrenceWeekDaysEvent extends RecurrentDateFormEvent {
  const ChangeRecurrenceWeekDaysEvent({required this.weekDays});

  final List<WeekdaysEnum> weekDays;

  @override
  List<Object?> get props => [weekDays];
}

/// Event to select the start date time
final class SelectStartDateTimeEvent extends RecurrentDateFormEvent {
  const SelectStartDateTimeEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

/// Event to select the end date time
final class SelectEndDateTimeEvent extends RecurrentDateFormEvent {
  const SelectEndDateTimeEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

/// Event to select the recurrence end date time
final class SelectRecurrenceEndDateTimeEvent extends RecurrentDateFormEvent {
  const SelectRecurrenceEndDateTimeEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

/// Event to validate all the dates
final class ValidateDatesEvent extends RecurrentDateFormEvent {
  @override
  List<Object?> get props => [];
}

/// Event to submit the recurrent date form
final class OnSubmitRecurrentDateEvent extends RecurrentDateFormEvent {
  @override
  List<Object?> get props => [];
}