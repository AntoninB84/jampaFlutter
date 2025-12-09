import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/home/settings_menu/settings_menu_cubit.dart';
import 'package:jampa_flutter/repository/auth_repository.dart';
import 'package:jampa_flutter/ui/auth/login/login_page.dart';
import 'package:jampa_flutter/ui/auth/register/register_page.dart';
import 'package:jampa_flutter/ui/categories/index/categories_page.dart';
import 'package:jampa_flutter/ui/categories/save/save_category_page.dart';
import 'package:jampa_flutter/ui/home/home_page.dart';
import 'package:jampa_flutter/ui/note_types/index/note_types_page.dart';
import 'package:jampa_flutter/ui/note_types/save/save_note_type_page.dart';
import 'package:jampa_flutter/ui/notes/form/note_form_page.dart';
import 'package:jampa_flutter/ui/notes/index/notes_page.dart';
import 'package:jampa_flutter/ui/notes/show/show_note_page.dart';
import 'package:jampa_flutter/ui/reminder/form/reminder_form_page.dart';
import 'package:jampa_flutter/ui/schedule/recurrent_date_form/recurrent_date_form_page.dart';
import 'package:jampa_flutter/ui/schedule/single_date_form/single_date_form_page.dart';
import 'package:jampa_flutter/ui/splash/splash_screen.dart';
import 'package:jampa_flutter/utils/routers/routes.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

final _routerKey = GlobalKey<NavigatorState>();

/// Helper class to convert Stream to ChangeNotifier for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}


/// Unified router containing splash, auth, and main app routes
final GoRouter router = GoRouter(
  navigatorKey: _routerKey,
  initialLocation: kAppRouteSplashPath,
  refreshListenable: GoRouterRefreshStream(serviceLocator<AuthRepository>().status),
  redirect: (context, state) {
    final authStatus = serviceLocator<AuthRepository>().currentStatus;
    final isOnSplash = state.matchedLocation == kAppRouteSplashPath;
    final isOnAuth = state.matchedLocation == kAppRouteLoginPath ||
                      state.matchedLocation == kAppRouteRegisterPath;

    // Don't redirect if auth status is still unknown (initializing)
    if (authStatus == AuthStatus.unknown) {
      return null;
    }

    // If user is authenticated and on auth pages, redirect to splash
    if (authStatus == AuthStatus.authenticated && isOnAuth) {
      return kAppRouteSplashPath;
    }

    // If user is unauthenticated and not on splash or auth pages, redirect to splash
    if (authStatus == AuthStatus.unauthenticated && !isOnSplash && !isOnAuth) {
      return kAppRouteSplashPath;
    }

    return null; // No redirect needed
  },
  routes: <RouteBase>[
    // Splash route
    GoRoute(
      path: kAppRouteSplashPath,
      name: kAppRouteSplashName,
      builder: (context, state) => const SplashScreen(),
    ),

    // Auth routes
    GoRoute(
      path: kAppRouteLoginPath,
      name: kAppRouteLoginName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: kAppRouteRegisterPath,
      name: kAppRouteRegisterName,
      builder: (context, state) => const RegisterPage(),
    ),

    // Main app routes
    ShellRoute(
      builder: (context, state, child) {
        // Defer settings menu reset to avoid blocking navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          serviceLocator<SettingsMenuCubit>().reset(state.fullPath);
        });

        // Wrap child routes with HomePage to provide repositories and blocs
        return HomePage(child: child);
      },
      routes: [
        GoRoute(
            path: kAppRouteNotesPath,
            name: kAppRouteNotesName,
          builder: (context, state) => const NotesPage(),
          routes: [
            GoRoute(
                path: kAppRouteNoteFormPath,
                name: kAppRouteNoteFormName,
                builder: (context, state) => NoteFormPage(
                    noteId: (state.extra as Map?)?['noteId'] as String?
                ),
                routes: [
                  GoRoute(
                    path: kAppRouteRecurrentDateFormPath,
                    name: kAppRouteRecurrentDateFormName,
                    builder: (context, state) => RecurrentDateFormPage(
                      noteId: (state.extra as Map?)?['noteId'] as String,
                      scheduleId: (state.extra as Map?)?['scheduleId'] as String?,
                    ),
                  ),
                  GoRoute(
                    path: kAppRouteSingleDateFormPath,
                    name: kAppRouteSingleDateFormName,
                    builder: (context, state) => SingleDateFormPage(
                      noteId: (state.extra as Map?)?['noteId'] as String,
                      scheduleId: (state.extra as Map?)?['scheduleId'] as String?,
                    ),
                  ),
                  GoRoute(
                      path: kAppRouteReminderFormPath,
                      name: kAppRouteReminderFormName,
                      builder: (context, state) => ReminderFormPage(
                        scheduleId: (state.extra as Map?)?['scheduleId'] as String,
                        reminderId: (state.extra as Map?)?['reminderId'] as String?,
                      )
                  )
                ]
            ),
            GoRoute(
              path: kAppRouteNoteDetailsPath,
              name: kAppRouteNoteDetailsName,
              builder: (context, state) => ShowNotePage(
                  noteId: (state.extra as Map?)?['id']
              ),
            )
          ]
      ),
        GoRoute(
            path: kAppRouteCategoriesPath,
            name: kAppRouteCategoriesName,
            builder: (context, state) => const CategoriesPage(),
            routes: [
              GoRoute(
                path: kAppRouteCreateCategoryPath,
                name: kAppRouteCreateCategoryName,
                builder: (context, state) => const SaveCategoryPage(),
              ),
              GoRoute(
                  path: kAppRouteEditCategoryPath,
                  name: kAppRouteEditCategoryName,
                  builder: (context, state) => SaveCategoryPage(
                    categoryId: (state.extra as Map?)?['id'],
                  )
              )
            ]
        ),
        GoRoute(
            path: kAppRouteNoteTypesPath,
            name: kAppRouteNoteTypesName,
            builder: (context, state) => const NoteTypesPage(),
            routes: [
              GoRoute(
                path: kAppRouteCreateNoteTypePath,
                name: kAppRouteCreateNoteTypeName,
                builder: (context, state) => const SaveNoteTypePage(),
              ),
              GoRoute(
                  path: kAppRouteEditNoteTypePath,
                  name: kAppRouteEditNoteTypeName,
                  builder: (context, state) => SaveNoteTypePage(
                    noteTypeId: (state.extra as Map?)?['id'],
                  )
              )
            ]
        )
      ]
    ),
  ],
);

