import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:jampa_flutter/bloc/auth/auth_bloc.dart';
import 'package:jampa_flutter/repository/auth_repository.dart';
import 'package:jampa_flutter/repository/user_repository.dart';
import 'package:jampa_flutter/utils/constants/l10n/app_localizations.dart';
import 'package:jampa_flutter/utils/constants/styles/themes.dart';
import 'package:jampa_flutter/utils/helpers/flavors.dart';
import 'package:jampa_flutter/utils/local_notification_manager.dart';
import 'package:jampa_flutter/utils/routers/auth_router.dart';
import 'package:jampa_flutter/utils/routers/main_router.dart';
import 'package:jampa_flutter/utils/service_locator.dart';
import 'package:jampa_flutter/workers/reminder_worker.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize flavor
  FlavorConfig.initialize(flavor: String.fromEnvironment("FLAVOR_TYPE"));
  // Initialize GetIt service locator
  setupServiceLocator();
  // Initialize local notifications
  await LocalNotificationManager().initialize();
  // Initialize reminder worker
  if(FlavorConfig.appFlavor.isProduction){
    setupReminderWorker();
  }
  // Initialize alarm package
  await Alarm.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(),
          dispose: (repository) => repository.dispose(),
        ),
        RepositoryProvider(create: (_) => UserRepository()),
      ],
      child: BlocProvider(
        lazy: false,
        create: (context) => AuthBloc()..add(AuthVerificationRequested()),
        child: BlocBuilder<AuthBloc,AuthState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Jampa',
              localizationsDelegates: AppLocalizations.localizationsDelegates
              + [
                FlutterQuillLocalizations.delegate
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              localeResolutionCallback: (locale, supportedLocales) {
                for (final supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                return const Locale('fr');
              },
              theme: MaterialTheme.lightTheme,
              highContrastTheme: MaterialTheme.lightHighContrast,
              darkTheme: MaterialTheme.darkTheme,
              highContrastDarkTheme: MaterialTheme.darkHighContrast,
              routerConfig: state.status == AuthStatus.authenticated
                  ? mainRouter : authRouter,
            );
          },
        ),
      ),
    );
  }
}