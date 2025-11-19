part of 'single_date_form_bloc.dart';

sealed class SingleDateFormEvent extends Equatable {
  const SingleDateFormEvent();
}

final class InitializeSingleDateFormEvent extends SingleDateFormEvent {
  const InitializeSingleDateFormEvent({
    this.isSavingPersistentData = false,
    this.scheduleId,
    required this.noteId
  });

  final bool isSavingPersistentData;
  final String? scheduleId;
  final String noteId;

  @override
  List<Object?> get props => [
    isSavingPersistentData,
    scheduleId,
    noteId
  ];
}

final class SelectStartDateTimeEvent extends SingleDateFormEvent {
  const SelectStartDateTimeEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class SelectEndDateTimeEvent extends SingleDateFormEvent {
  const SelectEndDateTimeEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

final class ValidateDatesEvent extends SingleDateFormEvent {
  @override
  List<Object?> get props => [];
}

final class OnSubmitSingleDateEvent extends SingleDateFormEvent {
  @override
  List<Object?> get props => [];
}