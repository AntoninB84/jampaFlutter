part of "save_alarm_list_bloc.dart";

class SaveAlarmListState extends Equatable {
  const SaveAlarmListState({
    this.alarmListStatus = UIListStatusEnum.loading,
    this.alarmElements = const [],
  });

  final UIListStatusEnum alarmListStatus;
  final List<AlarmFormElements> alarmElements;

  SaveAlarmListState copyWith({
    UIListStatusEnum? alarmListStatus,
    List<AlarmFormElements>? alarmElements,
  }) {
    return SaveAlarmListState(
      alarmListStatus: alarmListStatus ?? this.alarmListStatus,
      alarmElements: alarmElements ?? this.alarmElements,
    );
  }

  @override
  List<Object?> get props => [
        alarmListStatus,
        alarmElements,
      ];
}