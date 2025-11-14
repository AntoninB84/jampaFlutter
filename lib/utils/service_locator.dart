import 'package:get_it/get_it.dart';
import 'package:jampa_flutter/bloc/home/app_bar_cubit.dart';
import 'package:jampa_flutter/bloc/home/settings_menu/settings_menu_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/notes/edit/edit_note_bloc.dart';
import 'package:jampa_flutter/bloc/permissions/permissions_bloc.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/repository/auth_repository.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';
import 'package:jampa_flutter/repository/note_types_repository.dart';
import 'package:jampa_flutter/repository/notes_list_view_repository.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/repository/user_repository.dart';

import '../bloc/schedule/save_recurrent_date/save_recurrent_date_bloc.dart';
import '../bloc/schedule/save_single_date/save_single_date_bloc.dart';
import '../repository/alarm_repository.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AppDatabase>(() => AppDatabase.instance());
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  serviceLocator.registerLazySingleton<AlarmRepository>(() => AlarmRepository());
  serviceLocator.registerLazySingleton<CategoriesRepository>(() => CategoriesRepository());
  serviceLocator.registerLazySingleton<NotesRepository>(() => NotesRepository());
  serviceLocator.registerLazySingleton<NoteTypesRepository>(() => NoteTypesRepository());
  serviceLocator.registerLazySingleton<NotesListViewRepository>(() => NotesListViewRepository());
  serviceLocator.registerLazySingleton<ScheduleRepository>(() => ScheduleRepository());
  serviceLocator.registerLazySingleton<UserRepository>(() => UserRepository());
  serviceLocator.registerLazySingleton<PermissionsBloc>(() => PermissionsBloc());
  serviceLocator.registerLazySingleton<AppBarCubit>(() => AppBarCubit());
  serviceLocator.registerLazySingleton<SettingsMenuCubit>(() => SettingsMenuCubit());
  serviceLocator.registerLazySingleton(() => CreateNoteCubit());
  serviceLocator.registerLazySingleton(() => EditNoteBloc());
  serviceLocator.registerLazySingleton(() => SaveSingleDateBloc());
  serviceLocator.registerLazySingleton(() => SaveRecurrentDateBloc());
}