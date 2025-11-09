part of 'save_recurrent_date_bloc.dart';

class SaveRecurrentDateEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

final class InitializeWithData extends SaveRecurrentDateEvent {
  InitializeWithData({
    required this.recurrentDateFormElements,
    this.initialElementIndex,
    this.isSavingPersistentDate = false,
    this.scheduleId,
    this.noteId
  });

  final RecurrenceFormElements? recurrentDateFormElements;
  final int? initialElementIndex;
  final bool isSavingPersistentDate;
  final int? scheduleId;
  final int? noteId;

  @override
  List<Object?> get props => [
    recurrentDateFormElements,
    initialElementIndex,
    isSavingPersistentDate,
    scheduleId,
    noteId
  ];
}

final class SelectRecurrenceType extends SaveRecurrentDateEvent {
  SelectRecurrenceType({required this.recurrenceType});

  final RecurrenceType? recurrenceType;

  @override
  List<Object?> get props => [recurrenceType];
}

final class ChangeRecurrenceDayInterval extends SaveRecurrentDateEvent {
  ChangeRecurrenceDayInterval({required this.interval});

  final String interval;

  @override
  List<Object?> get props => [interval];
}

final class ChangeRecurrenceYearInterval extends SaveRecurrentDateEvent {
  ChangeRecurrenceYearInterval({required this.interval});

  final String interval;

  @override
  List<Object?> get props => [interval];
}

final class ChangeRecurrenceMonthDate extends SaveRecurrentDateEvent {
  ChangeRecurrenceMonthDate({required this.day});

  final String day;

  @override
  List<Object?> get props => [day];
}

final class ChangeRecurrenceWeekDays extends SaveRecurrentDateEvent {
  ChangeRecurrenceWeekDays({required this.weekDays});

  final List<WeekdaysEnum> weekDays;

  @override
  List<Object?> get props => [weekDays];
}

final class SelectStartDateTime extends SaveRecurrentDateEvent {
  SelectStartDateTime({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class SelectEndDateTime extends SaveRecurrentDateEvent {
  SelectEndDateTime({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class SelectRecurrenceEndDateTime extends SaveRecurrentDateEvent {
  SelectRecurrenceEndDateTime({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class ValidateDates extends SaveRecurrentDateEvent {}

final class AddAlarmForRecurrence extends SaveRecurrentDateEvent {
  AddAlarmForRecurrence({required this.alarm});

  final AlarmFormElements alarm;

  @override
  List<Object?> get props => [alarm];
}

final class RemoveAlarmForRecurrence extends SaveRecurrentDateEvent {
  RemoveAlarmForRecurrence({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

final class UpdateAlarmForRecurrence extends SaveRecurrentDateEvent {
  UpdateAlarmForRecurrence({required this.index, required this.updatedAlarm});

  final int index;
  final AlarmFormElements updatedAlarm;

  @override
  List<Object?> get props => [index, updatedAlarm];
}

final class OnSubmit extends SaveRecurrentDateEvent {}

final class ResetState extends SaveRecurrentDateEvent {}