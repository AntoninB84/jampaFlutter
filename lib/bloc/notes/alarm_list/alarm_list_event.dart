part of "alarm_list_bloc.dart";

class AlarmListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class InitializeAlarmListFromMemoryState extends AlarmListEvent {
  InitializeAlarmListFromMemoryState({required this.alarmElements});

  final List<AlarmFormElements> alarmElements;

  @override
  List<Object?> get props => [alarmElements];
}

final class LoadPersistentAlarmList extends AlarmListEvent {}

/// Delete from persistent storage
final class DeletePersistentAlarm extends AlarmListEvent {
  DeletePersistentAlarm({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

/// Remove from in-memory list only
final class RemoveAlarmFromMemoryList extends AlarmListEvent {
  RemoveAlarmFromMemoryList({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

final class ResetAlarmListState extends AlarmListEvent {}