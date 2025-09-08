part of 'save_single_date_bloc.dart';

class SaveSingleDateEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

final class InitializeWithData extends SaveSingleDateEvent {
  InitializeWithData({
    required this.singleDateFormElements,
    this.initialElementIndex,
    this.isSavingPersistentDate = false,
    this.noteId
  });

  final SingleDateFormElements? singleDateFormElements;
  final int? initialElementIndex;
  final bool isSavingPersistentDate;
  final int? noteId;

  @override
  List<Object?> get props => [
    singleDateFormElements,
    initialElementIndex,
    isSavingPersistentDate,
    noteId
  ];
}

final class SelectStartDateTime extends SaveSingleDateEvent {
  SelectStartDateTime({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class SelectEndDateTime extends SaveSingleDateEvent {
  SelectEndDateTime({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class AddAlarm extends SaveSingleDateEvent {
  AddAlarm({required this.alarm});

  final AlarmFormElements alarm;

  @override
  List<Object?> get props => [alarm];
}

final class RemoveAlarm extends SaveSingleDateEvent {
  RemoveAlarm({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

final class ValidateDates extends SaveSingleDateEvent {}

final class UpdateAlarm extends SaveSingleDateEvent {
  UpdateAlarm({required this.index, required this.updatedAlarm});

  final int index;
  final AlarmFormElements updatedAlarm;

  @override
  List<Object?> get props => [index, updatedAlarm];
}

final class OnSubmit extends SaveSingleDateEvent {}

final class ResetState extends SaveSingleDateEvent {}