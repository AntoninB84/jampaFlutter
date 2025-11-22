part of 'single_date_form_bloc.dart';

sealed class SingleDateFormEvent extends Equatable {
  const SingleDateFormEvent();
}

/// Event to initialize the single date form with existing data
final class InitializeSingleDateFormEvent extends SingleDateFormEvent {
  const InitializeSingleDateFormEvent({
    this.scheduleId,
    required this.noteId
  });

  final String? scheduleId;
  final String noteId;

  @override
  List<Object?> get props => [
    scheduleId,
    noteId
  ];
}

/// Event to select start date and time
final class SelectStartDateTimeEvent extends SingleDateFormEvent {
  const SelectStartDateTimeEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

/// Event to select end date and time
final class SelectEndDateTimeEvent extends SingleDateFormEvent {
  const SelectEndDateTimeEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

/// Event to validate the selected dates
final class ValidateDatesEvent extends SingleDateFormEvent {
  @override
  List<Object?> get props => [];
}

/// Event to submit the single date form
final class OnSubmitSingleDateEvent extends SingleDateFormEvent {
  @override
  List<Object?> get props => [];
}