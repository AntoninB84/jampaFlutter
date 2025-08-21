import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/categories/categories_page.dart';
import 'package:jampa_flutter/ui/categories/create/create_category_page.dart';

import '../../ui/home/home_page.dart';
import '../../ui/notes/pages/notes_page.dart';

class AppRoutes {
  static const String notes = '/notes';
  static const String noteDetails = '/notes/:id';
  static const String settings = '/settings';
  static const String categories = '/categories';
  static const String createCategory = '/categories/create';
  static const String editCategory = '/categories/edit/:id';
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
                builder: (context, state) => Center(
                    child: TextButton(
                      onPressed: () {context.pushNamed("Categories");},
                      child: Text("Categories"),)
                ),
                routes: [
                  GoRoute(
                    name: "Categories",
                    path: AppRoutes.categories,
                    builder: (context, state) => const CategoriesPage(),
                    routes: [
                      GoRoute(
                        name: "CreateCategory",
                        path: AppRoutes.createCategory,
                        builder: (context, state) => const CreateCategoryPage(),
                      ),
                      GoRoute(
                        name: "EditCategory",
                        path: AppRoutes.editCategory,
                        builder: (context, state) => CreateCategoryPage(categoryId: state.pathParameters['id'],)
                      )
                    ]
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