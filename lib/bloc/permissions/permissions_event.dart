
part of 'permissions_bloc.dart';

class PermissionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Events for checking and updating permissions
class CheckPermissions extends PermissionsEvent {}

/// Event for checking notification permission
class CheckNotificationsPermission extends PermissionsEvent {}

/// Event for checking schedule exact alarm permission
class CheckScheduleExactAlarmPermission extends PermissionsEvent {}

/// Event for updating notification permission status
class UpdateNotificationsPermission extends PermissionsEvent {
  final bool granted;

  UpdateNotificationsPermission({required this.granted});

  @override
  List<Object?> get props => [granted];
}

/// Event for updating schedule exact alarm permission status
class UpdateScheduleExactAlarmPermission extends PermissionsEvent {
  final bool granted;

  UpdateScheduleExactAlarmPermission({required this.granted});

  @override
  List<Object?> get props => [granted];
}