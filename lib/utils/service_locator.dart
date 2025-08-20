import 'package:get_it/get_it.dart';
import 'package:jampa_flutter/data/database.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AppDatabase>(() => AppDatabase.instance());
}