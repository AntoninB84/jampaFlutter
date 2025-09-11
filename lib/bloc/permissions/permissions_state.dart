
part of 'permissions_bloc.dart';

class PermissionsState extends Equatable {
  final bool notificationsGranted;
  final bool scheduleExactAlarmGranted;

  const PermissionsState({
    required this.notificationsGranted,
    required this.scheduleExactAlarmGranted,
  });

  PermissionsState copyWith({
    bool? notificationsGranted,
    bool? scheduleExactAlarmGranted,
  }) {
    return PermissionsState(
      notificationsGranted: notificationsGranted ?? this.notificationsGranted,
      scheduleExactAlarmGranted: scheduleExactAlarmGranted ?? this.scheduleExactAlarmGranted,
    );
  }

  @override
  List<Object?> get props => [notificationsGranted, scheduleExactAlarmGranted];
}