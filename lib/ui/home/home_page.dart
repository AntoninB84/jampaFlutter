import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/permissions/permissions_bloc.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../repository/categories_repository.dart';
import '../../repository/note_types_repository.dart';
import '../../repository/notes_list_view_repository.dart';
import '../../repository/reminder_repository.dart';

/// The HomePage widget that sets up repositories and blocs for the app.
///
/// It wraps child routes with necessary dependencies (repositories and blocs).
///
/// Also initiates permission checks on load.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.child});

  final Widget child;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final PermissionsBloc _permissionsBloc;

  @override
  void initState() {
    super.initState();
    _permissionsBloc = serviceLocator<PermissionsBloc>();
    // Trigger permission check on load
    _permissionsBloc.add(CheckPermissions());
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => serviceLocator<CategoriesRepository>(),
        ),
        RepositoryProvider(
          create: (context) => serviceLocator<NoteTypesRepository>(),
        ),
        RepositoryProvider(
          create: (context) => serviceLocator<NotesListViewRepository>(),
        ),
        RepositoryProvider(
          create: (context) => serviceLocator<NotesRepository>(),
        ),
        RepositoryProvider(
            create: (context) => serviceLocator<ScheduleRepository>()
        ),
        RepositoryProvider(
            create: (context) => serviceLocator<ReminderRepository>()
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Provide the PermissionsBloc and trigger a permission check on load
          // for notifications and alarms scheduling.
          BlocProvider<PermissionsBloc>.value(
            value: _permissionsBloc
          ),
        ],
        child: widget.child
      ),
    );
  }


}