part of 'recurrent_date_form_bloc.dart';

sealed class RecurrentDateFormEvent extends Equatable {
  const RecurrentDateFormEvent();
}

final class InitializeRecurrentDateFormEvent extends RecurrentDateFormEvent {
  final String noteId;
  final String? scheduleId;
  final bool isSavingPersistentData;

  const InitializeRecurrentDateFormEvent({
    required this.noteId,
    required this.scheduleId,
    this.isSavingPersistentData = false,
  });

  @override
  List<Object?> get props => [noteId, scheduleId, isSavingPersistentData];
}

final class SelectRecurrenceTypeEvent extends RecurrentDateFormEvent {
  const SelectRecurrenceTypeEvent({required this.recurrenceType});

  final RecurrenceType? recurrenceType;

  @override
  List<Object?> get props => [recurrenceType];
}

final class ChangeRecurrenceDayIntervalEvent extends RecurrentDateFormEvent {
  const ChangeRecurrenceDayIntervalEvent({required this.interval});

  final String interval;

  @override
  List<Object?> get props => [interval];
}


final class ChangeRecurrenceYearIntervalEvent extends RecurrentDateFormEvent {
  const ChangeRecurrenceYearIntervalEvent({required this.interval});

  final String interval;

  @override
  List<Object?> get props => [interval];
}

final class ChangeRecurrenceMonthDateEvent extends RecurrentDateFormEvent {
  const ChangeRecurrenceMonthDateEvent({required this.day});

  final String day;

  @override
  List<Object?> get props => [day];
}

final class ChangeRecurrenceWeekDaysEvent extends RecurrentDateFormEvent {
  const ChangeRecurrenceWeekDaysEvent({required this.weekDays});

  final List<WeekdaysEnum> weekDays;

  @override
  List<Object?> get props => [weekDays];
}

final class SelectStartDateTimeEvent extends RecurrentDateFormEvent {
  const SelectStartDateTimeEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class SelectEndDateTimeEvent extends RecurrentDateFormEvent {
  const SelectEndDateTimeEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class SelectRecurrenceEndDateTimeEvent extends RecurrentDateFormEvent {
  const SelectRecurrenceEndDateTimeEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class ValidateDatesEvent extends RecurrentDateFormEvent {
  @override
  List<Object?> get props => [];
}

final class OnSubmitRecurrentDateEvent extends RecurrentDateFormEvent {
  @override
  List<Object?> get props => [];
}