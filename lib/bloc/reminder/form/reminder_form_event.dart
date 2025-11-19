part of 'reminder_form_bloc.dart';

sealed class ReminderFormEvent extends Equatable {
  const ReminderFormEvent();
}

final class InitializeReminderFormEvent extends ReminderFormEvent {
  const InitializeReminderFormEvent({
    this.isSavingPersistentData = false,
    required this.scheduleId,
    this.reminderId
  });

  final bool isSavingPersistentData;
  final String scheduleId;
  final String? reminderId;

  @override
  List<Object?> get props => [
    isSavingPersistentData,
    scheduleId,
    reminderId
  ];
}

final class SelectOffsetNumberEvent extends ReminderFormEvent {
  const SelectOffsetNumberEvent({required this.offsetNumber});

  final String offsetNumber;

  @override
  List<Object?> get props => [offsetNumber];
}

final class SelectOffsetTypeEvent extends ReminderFormEvent {
  const SelectOffsetTypeEvent({this.offsetType});

  final ReminderOffsetType? offsetType;

  @override
  List<Object?> get props => [offsetType];
}

final class ToggleIsNotificationEvent extends ReminderFormEvent {
  const ToggleIsNotificationEvent({required this.isNotification});

  final bool isNotification;

  @override
  List<Object?> get props => [isNotification];
}

final class ValidateOffsetNumberEvent extends ReminderFormEvent {
  @override
  List<Object?> get props => [];
}

final class OnSubmitReminderFormEvent extends ReminderFormEvent {
  @override
  List<Object?> get props => [];
}