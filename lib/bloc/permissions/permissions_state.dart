
part of 'permissions_bloc.dart';

class PermissionsState extends Equatable {

  /// Indicates whether notification permissions have been granted.
  final bool notificationsGranted;

  /// Indicates whether schedule exact alarm permissions have been granted.
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