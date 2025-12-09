import 'package:get_it/get_it.dart';
import 'package:jampa_flutter/bloc/home/settings_menu/settings_menu_cubit.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/bloc/permissions/permissions_bloc.dart';
import 'package:jampa_flutter/bloc/reminder/reminder_cubit.dart';
import 'package:jampa_flutter/data/api/auth_api_client.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/repository/auth_repository.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';
import 'package:jampa_flutter/repository/note_types_repository.dart';
import 'package:jampa_flutter/repository/notes_list_view_repository.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/repository/user_repository.dart';
import 'package:jampa_flutter/utils/storage/secure_storage_service.dart';
import 'package:jampa_flutter/utils/storage/sync_storage_service.dart';
import 'package:jampa_flutter/utils/connectivity/connectivity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/sync/sync_bloc.dart';
import '../data/api/sync_api_client.dart';
import '../data/sync/sync_service.dart';
import '../repository/reminder_repository.dart';
import '../repository/sync_repository.dart';

final GetIt serviceLocator = GetIt.instance;

/// Registers all the global services and repositories used in the app
/// with the service locator for dependency injection.
void setupServiceLocator() async {
  // Get SharedPreferences instance
  final sharedPrefs = await SharedPreferences.getInstance();

  // Core services
  serviceLocator.registerLazySingleton<AppDatabase>(() => AppDatabase.instance());
  serviceLocator.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  serviceLocator.registerSingleton<SyncStorageService>(
    SyncStorageService(prefs: sharedPrefs),
  );
  serviceLocator.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // API clients
  serviceLocator.registerLazySingleton<AuthApiClient>(() => AuthApiClient());
  serviceLocator.registerLazySingleton<SyncApiClient>(
        () => SyncApiClient(
      getAccessToken: () async {
        // Get the current access token from SecureStorageService
        final token = await serviceLocator<SecureStorageService>().getAccessToken();
        return token ?? '';
      },
    ),
  );

  //Sync Service
  serviceLocator.registerLazySingleton<SyncService>(
        () => SyncService(
      apiClient: serviceLocator<SyncApiClient>(),
      storageService: serviceLocator<SyncStorageService>(),
      database: serviceLocator<AppDatabase>(),
    ),
  );

  // Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepository(
    apiClient: serviceLocator<AuthApiClient>(),
    secureStorage: serviceLocator<SecureStorageService>(),
  ));
  serviceLocator.registerLazySingleton<UserRepository>(() => UserRepository(
    secureStorage: serviceLocator<SecureStorageService>(),
  ));
  serviceLocator.registerLazySingleton<SyncRepository>(
        () => SyncRepository(
      syncService: serviceLocator<SyncService>(),
    ),
  );
  serviceLocator.registerLazySingleton<ReminderRepository>(() => ReminderRepository());
  serviceLocator.registerLazySingleton<CategoriesRepository>(() => CategoriesRepository());
  serviceLocator.registerLazySingleton<NotesRepository>(() => NotesRepository());
  serviceLocator.registerLazySingleton<NoteTypesRepository>(() => NoteTypesRepository());
  serviceLocator.registerLazySingleton<NotesListViewRepository>(() => NotesListViewRepository());
  serviceLocator.registerLazySingleton<ScheduleRepository>(() => ScheduleRepository());

  // Blocs and Cubits
  serviceLocator.registerLazySingleton<PermissionsBloc>(() => PermissionsBloc());
  serviceLocator.registerLazySingleton<SettingsMenuCubit>(() => SettingsMenuCubit());
  serviceLocator.registerFactory<SyncBloc>(
    () => SyncBloc(
      syncRepository: serviceLocator<SyncRepository>(),
      connectivityService: serviceLocator<ConnectivityService>(),
    ),
  );
  serviceLocator.registerLazySingleton<ReminderCubit>(() => ReminderCubit());
  serviceLocator.registerFactory(() => SaveNoteBloc());
}