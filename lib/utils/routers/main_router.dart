import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../ui/home/home_page.dart';
import '../../ui/notes/pages/notes_page.dart';

class AppRoutes {
  static const String notes = '/notes';
  static const String noteDetails = '/notes/:id';
  static const String search = '/search';
  static const String profile = '/profile';
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
                name: "Search",
                path: AppRoutes.search,
                builder: (context, state) => const Center(child: Text("Search Page")),
                routes: []
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                name: "Profile",
                path: AppRoutes.profile,
                builder: (context, state) => const Center(child: Text("Profile Page")),
                routes: []
            )
          ]
        )
      ]
    ),
    GoRoute(
      name: "Test",
      builder: (context, state) => Center(child: Text("Test")),
      path: '/test'
    )
  ],
);