import 'package:get_it/get_it.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/notes/edit/edit_note_cubit.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/repository/auth_repository.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';
import 'package:jampa_flutter/repository/note_types_repository.dart';
import 'package:jampa_flutter/repository/notes_list_view_repository.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/repository/user_repository.dart';

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
  serviceLocator.registerLazySingleton(
      () => CreateNoteCubit(notesRepository: serviceLocator<NotesRepository>())
  );
  serviceLocator.registerLazySingleton(
      () => EditNoteCubit(notesRepository: serviceLocator<NotesRepository>())
  );
}