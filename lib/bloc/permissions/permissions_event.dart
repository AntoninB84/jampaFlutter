
part of 'permissions_bloc.dart';

class PermissionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckPermissions extends PermissionsEvent {}

class CheckNotificationsPermission extends PermissionsEvent {}
class CheckScheduleExactAlarmPermission extends PermissionsEvent {}

class UpdateNotificationsPermission extends PermissionsEvent {
  final bool granted;

  UpdateNotificationsPermission({required this.granted});

  @override
  List<Object?> get props => [granted];
}

class UpdateScheduleExactAlarmPermission extends PermissionsEvent {
  final bool granted;

  UpdateScheduleExactAlarmPermission({required this.granted});

  @override
  List<Object?> get props => [granted];
}