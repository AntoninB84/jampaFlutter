import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/home/settings_menu/settings_menu_bloc.dart';
import 'package:jampa_flutter/ui/categories/index/categories_page.dart';
import 'package:jampa_flutter/ui/categories/save/save_category_page.dart';
import 'package:jampa_flutter/ui/home/home_page.dart';
import 'package:jampa_flutter/ui/note_types/index/note_types_page.dart';
import 'package:jampa_flutter/ui/note_types/save/save_note_type_page.dart';
import 'package:jampa_flutter/ui/notes/index/notes_page.dart';
import 'package:jampa_flutter/ui/notes/show/show_note_page.dart';
import 'package:jampa_flutter/ui/reminder/form/reminder_form_page.dart';
import 'package:jampa_flutter/ui/schedule/single_date_form/single_date_form_page.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../ui/notes/form/note_form_page.dart';
import '../../ui/schedule/recurrent_date_form/recurrent_date_form_page.dart';


class AppRoutes {
  static const String notes = '/notes';
  static const String noteDetails = '/details';
  static const String noteForm = '/noteForm';
  static const String recurrentDateForm = '/recurrentDateForm';
  static const String singleDateForm = '/singleDateForm';
  static const String reminderForm = '/reminderForm';

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
        // Check and reset settings menu state on each navigation
        serviceLocator<SettingsMenuCubit>().reset(state.fullPath);

        return HomePage(navigationShell: navigationShell,);
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
                  name: "NoteForm",
                  path: AppRoutes.noteForm,
                  builder: (context, state) => NoteFormPage(
                    noteId: (state.extra as Map?)?['noteId'] as String?
                  ),
                  routes: [
                    GoRoute(
                      name: "RecurrentDateForm",
                      path: AppRoutes.recurrentDateForm,
                      builder: (context, state) => RecurrentDateFormPage(
                        noteId: (state.extra as Map?)?['noteId'] as String,
                        scheduleId: (state.extra as Map?)?['scheduleId'] as String?,
                      ),
                    ),
                    GoRoute(
                      name: "SingleDateForm",
                      path: AppRoutes.singleDateForm,
                      builder: (context, state) => SingleDateFormPage(
                        noteId: (state.extra as Map?)?['noteId'] as String,
                        scheduleId: (state.extra as Map?)?['scheduleId'] as String?,
                      ),
                    ),
                    GoRoute(
                      name: "ReminderForm",
                      path: AppRoutes.reminderForm,
                      builder: (context, state) => ReminderFormPage(
                        scheduleId: (state.extra as Map?)?['scheduleId'] as String,
                        reminderId: (state.extra as Map?)?['reminderId'] as String?,
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
                  ]
                )
              ]
            ),
            GoRoute(
                name: "Categories",
                path: AppRoutes.categories,
                builder: (context, state) => const CategoriesPage(),
                routes: [
                  GoRoute(
                    name: "CreateCategory",
                    path: AppRoutes.createCategory,
                    builder: (context, state) => const SaveCategoryPage(),
                  ),
                  GoRoute(
                      name: "EditCategory",
                      path: AppRoutes.editCategory,
                      builder: (context, state) => SaveCategoryPage(
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
                    builder: (context, state) => const SaveNoteTypePage(),
                  ),
                  GoRoute(
                      name: "EditNoteType",
                      path: AppRoutes.editNoteType,
                      builder: (context, state) => SaveNoteTypePage(
                        noteTypeId: (state.extra as Map?)?['id'],
                      )
                  )
                ]
            )
          ]
        ),
        // StatefulShellBranch(
        //   routes: [
        //     //TODO : Calendar branch
        //   ]
        // ),
      ]
    ),
  ],
);