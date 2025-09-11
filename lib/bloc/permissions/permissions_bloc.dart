
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc() : super(
      PermissionsState(
        notificationsGranted: false,
        scheduleExactAlarmGranted: false
      )
  ) {
   on<CheckPermissions>(_onCheckPermissions);
   on<CheckNotificationsPermission>(_onCheckNotificationsPermission);
   on<CheckScheduleExactAlarmPermission>(_onCheckScheduleExactAlarmPermission);
   on<UpdateNotificationsPermission>(_onUpdateNotificationsPermission);
   on<UpdateScheduleExactAlarmPermission>(_onUpdateScheduleExactAlarmPermission);
  }


  Future<void> _onCheckPermissions(CheckPermissions event, Emitter<PermissionsState> emit) async {
    add(CheckScheduleExactAlarmPermission());
    add(CheckNotificationsPermission());
  }

  Future<void> _onCheckNotificationsPermission(CheckNotificationsPermission event, Emitter<PermissionsState> emit) async {
    final status = await Permission.notification.status;
    if(status.isDenied){
      debugPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      emit(state.copyWith(notificationsGranted: res.isGranted));
      debugPrint('Notification permission ${res.isGranted ? '' : 'not'} granted.');
    }else{
      emit(state.copyWith(notificationsGranted: status.isGranted));
    }
  }

  Future<void> _onCheckScheduleExactAlarmPermission(CheckScheduleExactAlarmPermission event, Emitter<PermissionsState> emit) async {
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      debugPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      emit(state.copyWith(scheduleExactAlarmGranted: res.isGranted));
      debugPrint('Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
    }else{
      emit(state.copyWith(scheduleExactAlarmGranted: status.isGranted));
    }
  }

  Future<void> _onUpdateNotificationsPermission(UpdateNotificationsPermission event, Emitter<PermissionsState> emit) async {
    //TODO
    emit(state.copyWith(notificationsGranted: event.granted));
  }

  Future<void> _onUpdateScheduleExactAlarmPermission(UpdateScheduleExactAlarmPermission event, Emitter<PermissionsState> emit) async {
    //TODO
    emit(state.copyWith(scheduleExactAlarmGranted: event.granted));
  }

}