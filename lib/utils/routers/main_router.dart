import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/categories/create/create_category_page.dart';
import 'package:jampa_flutter/ui/categories/index/categories_page.dart';
import 'package:jampa_flutter/ui/home/home_page.dart';
import 'package:jampa_flutter/ui/note_types/create/create_note_type_page.dart';
import 'package:jampa_flutter/ui/note_types/index/note_types_page.dart';
import 'package:jampa_flutter/ui/notes/create/create_note_page.dart';
import 'package:jampa_flutter/ui/notes/index/notes_page.dart';


class AppRoutes {
  static const String notes = '/notes';
  static const String noteDetails = '/notes/:id';
  static const String createNote = '/notes/create';
  static const String editNote = '/notes/edit/:id';
  static const String settings = '/settings';
  static const String categories = '/categories';
  static const String createCategory = '/categories/create';
  static const String editCategory = '/categories/edit/:id';
  static const String noteTypes = '/note_types';
  static const String createNoteType = '/note_types/create';
  static const String editNoteType = '/note_types/edit/:id';
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
                  name: "CreateNote",
                  path: AppRoutes.createNote,
                  builder: (context, state) => const CreateNotePage(),
                ),
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
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {context.pushNamed("Categories");},
                          child: Text("Categories"),
                        ),
                        TextButton(
                          onPressed: () {context.pushNamed("NoteTypes");},
                          child: Text("Note Types"),
                        ),
                      ],
                    )
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
                  GoRoute(
                    name: "NoteTypes",
                    path: AppRoutes.noteTypes,
                    builder: (context, state) => const NoteTypesPage(),
                    routes: [
                      GoRoute(
                        name: "CreateNoteType",
                        path: AppRoutes.createNoteType,
                        builder: (context, state) => const CreateNoteTypePage(),
                      ),
                      GoRoute(
                        name: "EditNoteType",
                        path: AppRoutes.editNoteType,
                        builder: (context, state) => CreateNoteTypePage(noteTypeId: state.pathParameters['id'],)
                      )
                    ]
                  )
                ]
            )
          ]
        ),
      ]
    ),
  ],
);