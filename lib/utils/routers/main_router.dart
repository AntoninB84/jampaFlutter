import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/categories/create/create_category_page.dart';
import 'package:jampa_flutter/ui/categories/index/categories_page.dart';
import 'package:jampa_flutter/ui/home/home_page.dart';
import 'package:jampa_flutter/ui/note_types/create/create_note_type_page.dart';
import 'package:jampa_flutter/ui/note_types/index/note_types_page.dart';
import 'package:jampa_flutter/ui/notes/create/create_note_page.dart';
import 'package:jampa_flutter/ui/notes/create_single_date/save_memory_single_date_page.dart';
import 'package:jampa_flutter/ui/notes/create_single_date/save_persistent_single_date_page.dart';
import 'package:jampa_flutter/ui/notes/edit/edit_note_page.dart';
import 'package:jampa_flutter/ui/notes/index/notes_page.dart';
import 'package:jampa_flutter/ui/notes/show/show_note_page.dart';


class AppRoutes {
  static const String notes = '/notes';
  static const String noteDetails = '/details';
  static const String createNote = '/create';
  static const String editNote = '/edit';
  static const String saveMemorySingleDate = '/saveMemorySingleDate';
  static const String savePersistentSingleDate = '/savePersistentSingleDate';
  static const String settings = '/settings';
  static const String categories = '/categories';
  static const String createCategory = '/create';
  static const String editCategory = '/edit';
  static const String noteTypes = '/note_types';
  static const String createNoteType = '/create';
  static const String editNoteType = '/edit';
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
                  routes: [
                    GoRoute(
                      name: "SaveMemorySingleDate",
                      path: AppRoutes.saveMemorySingleDate,
                      builder: (context, state) => SaveMemorySingleDatePage(
                        singleDateIndex: (state.extra as Map?)?['dateIndex'] as int?,
                      )
                    )
                  ]
                ),
                GoRoute(
                  name: "NoteDetails",
                  path: AppRoutes.noteDetails,
                  builder: (context, state) => ShowNotePage(
                      noteId: (state.extra as Map?)?['id']
                  ),
                  routes: [
                    GoRoute(
                      name: "EditNote",
                      path: AppRoutes.editNote,
                      builder: (context, state) => EditNotePage(
                        noteId: (state.extra as Map?)?['id']
                      ),
                      routes: [
                        GoRoute(
                            name: "SavePersistentSingleDate",
                            path: AppRoutes.savePersistentSingleDate,
                            builder: (context, state) => SavePersistentSingleDatePage(
                              singleDateIndex: (state.extra as Map?)?['dateIndex'] as int?,
                            )
                        )
                      ]
                    )
                  ]
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
                        builder: (context, state) => CreateCategoryPage(
                          categoryId: (state.extra as Map?)?['id'],
                        )
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
                        builder: (context, state) => CreateNoteTypePage(
                          noteTypeId: (state.extra as Map?)?['id'],
                        )
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