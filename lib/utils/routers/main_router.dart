import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/categories/categories_page.dart';

import '../../ui/home/home_page.dart';
import '../../ui/notes/pages/notes_page.dart';

class AppRoutes {
  static const String notes = '/notes';
  static const String noteDetails = '/notes/:id';
  static const String settings = '/settings';
}

final _routerKey = GlobalKey<NavigatorState>();

final GoRouter mainRouter = GoRouter(
  navigatorKey: _routerKey,
  initialLocation: AppRoutes.notes,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomePage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "NotesIndex",
              path: AppRoutes.notes,
              builder: (context, state) => const NotesPage(),
              routes: [
                GoRoute(
                  name: "NoteDetails",
                  path: AppRoutes.noteDetails,
                  builder: (context, state) => Center(
                    child: Text("Note Details Page for ID: ${state.pathParameters['id']}"),
                  )
                )
              ]
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                name: "Settings",
                path: AppRoutes.settings,
                builder: (context, state) => Center(child: TextButton(onPressed: () { context.pushNamed("Categories"); }, child: Text("Settings"),)),
                routes: [
                  GoRoute(
                    name: "Categories",
                    path: '/categories',
                    builder: (context, state) => const CategoriesPage()
                  ),
                ]
            )
          ]
        ),
      ]
    ),
    GoRoute(
      name: "Test",
      builder: (context, state) => Center(child: Text("Test")),
      path: '/test'
    )
  ],
);