part of "save_alarm_list_bloc.dart";

class SaveAlarmListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class InitializeSaveAlarmListFromMemoryState extends SaveAlarmListEvent {
  InitializeSaveAlarmListFromMemoryState({required this.alarmElements});

  final List<AlarmFormElements> alarmElements;

  @override
  List<Object?> get props => [alarmElements];
}

/// Delete from persistent storage
final class DeletePersistentAlarm extends SaveAlarmListEvent {
  DeletePersistentAlarm({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

/// Remove from in-memory list only
final class RemoveAlarmFromMemoryList extends SaveAlarmListEvent {
  RemoveAlarmFromMemoryList({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

final class ResetSaveAlarmListState extends SaveAlarmListEvent {}