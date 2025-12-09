part of 'reminder_form_bloc.dart';

sealed class ReminderFormEvent extends Equatable {
  const ReminderFormEvent();
}

/// Event to initialize the reminder form, optionally with an existing reminder ID.
/// This event is used to set up the form for either creating a new reminder
/// or editing an existing one.
final class InitializeReminderFormEvent extends ReminderFormEvent {
  const InitializeReminderFormEvent({
    required this.scheduleId,
    required this.noteId,
    this.reminderId
  });

  /// The ID of the parent schedule.
  final String scheduleId;
  /// The ID of the parent note.
  final String noteId;
  /// The ID of the reminder to edit, if any.
  final String? reminderId;

  @override
  List<Object?> get props => [
    scheduleId,
    noteId,
    reminderId
  ];
}

/// Event to select the offset number for the reminder.
final class SelectOffsetNumberEvent extends ReminderFormEvent {
  const SelectOffsetNumberEvent({required this.offsetNumber});

  final String offsetNumber;

  @override
  List<Object?> get props => [offsetNumber];
}

/// Event to select the offset type for the reminder.
final class SelectOffsetTypeEvent extends ReminderFormEvent {
  const SelectOffsetTypeEvent({this.offsetType});

  final ReminderOffsetType? offsetType;

  @override
  List<Object?> get props => [offsetType];
}

/// Event to toggle whether the reminder is a notification or an alarm
final class ToggleIsNotificationEvent extends ReminderFormEvent {
  const ToggleIsNotificationEvent({required this.isNotification});

  final bool isNotification;

  @override
  List<Object?> get props => [isNotification];
}

/// Event to submit the reminder form to the [SaveNoteBloc] for saving.
final class OnSubmitReminderFormEvent extends ReminderFormEvent {
  @override
  List<Object?> get props => [];
}