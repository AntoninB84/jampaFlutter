part of "alarm_list_bloc.dart";

class AlarmListState extends Equatable {
  const AlarmListState({
    this.alarmListStatus = UIListStatusEnum.loading,
    this.alarmElements = const [],
  });

  final UIListStatusEnum alarmListStatus;
  final List<AlarmFormElements> alarmElements;

  AlarmListState copyWith({
    UIListStatusEnum? alarmListStatus,
    List<AlarmFormElements>? alarmElements,
  }) {
    return AlarmListState(
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