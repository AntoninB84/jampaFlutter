import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/auth/auth_bloc.dart';
import 'package:jampa_flutter/repository/auth_repository.dart';
import 'package:jampa_flutter/repository/user_repository.dart';
import 'package:jampa_flutter/utils/constants/l10n/app_localizations.dart';
import 'package:jampa_flutter/utils/local_notification_manager.dart';
import 'package:jampa_flutter/utils/routers/main_router.dart';
import 'package:jampa_flutter/utils/service_locator.dart';
import 'package:jampa_flutter/utils/constants/styles/themes.dart';
import 'package:jampa_flutter/workers/alarm_worker.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await LocalNotificationManager().initialize();
  setupAlarmWorker();
  await Alarm.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        create: (context) => AuthBloc()..add(AuthSubscriptionRequested()),
        child: BlocBuilder<AuthBloc,AuthState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Jampa Flutter',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
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
              // routerConfig: state.status == AuthStatus.authenticated
              //     ? mainRouter : authRouter,
              routerConfig: mainRouter,
            );
          },
        ),
      ),
    );
  }
}