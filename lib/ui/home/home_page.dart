import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/permissions/permissions_bloc.dart';
import 'package:jampa_flutter/bloc/sync/sync_bloc.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../repository/categories_repository.dart';
import '../../repository/note_types_repository.dart';
import '../../repository/notes_list_view_repository.dart';
import '../../repository/reminder_repository.dart';
import '../../utils/extensions/app_context_extension.dart';
import '../widgets/snackbar.dart';

/// The HomePage widget that sets up repositories and blocs for the app.
///
/// It wraps child routes with necessary dependencies (repositories and blocs).
///
/// Also initiates permission checks and automatic sync on load.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.child});

  final Widget child;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final PermissionsBloc _permissionsBloc;
  late final SyncBloc _syncBloc;

  @override
  void initState() {
    super.initState();
    _permissionsBloc = serviceLocator<PermissionsBloc>();
    _syncBloc = serviceLocator<SyncBloc>();

    // Start initial sync after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _syncBloc.add(SyncRequested());
      }
    });
    // Trigger permission check on load for notifications and alarms scheduling.
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
          BlocProvider<PermissionsBloc>.value(
            value: _permissionsBloc
          ),
          BlocProvider<SyncBloc>.value(
            value: _syncBloc,
          ),
        ],
        child: BlocConsumer<SyncBloc, SyncState>(
          listener: (context, state) {
            if (state is SyncSuccess) {
              SnackBarX.showSuccess(context, context.strings.sync_success_message);
            } else if (state is SyncFailure) {
              SnackBarX.showError(context, context.strings.sync_failed_message);
            } else if (state is SyncNoNetwork) {
              SnackBarX.showError(context, context.strings.sync_no_network_message);
            }
          },
          builder: (context, state){
            return Stack(
              children: [
                widget.child,
                // Sync in progress indicator
                if (state is SyncInProgress)
                  _syncProgressIndicator(context)
              ],
            );
          },
        )
      ),
    );
  }

  Widget _syncProgressIndicator(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Material(
        color: Theme.of(context).colorScheme.surface.withValues(
          alpha: 0.7
        ),
        child: Center(
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(kGap16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onSurfaceVariant
                    ),
                  ),
                  const SizedBox(height: kGap40),
                  Text(
                    context.strings.sync_in_progress,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}