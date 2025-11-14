import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/permissions/permissions_bloc.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/ui/home/widgets/app_bar.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../repository/alarm_repository.dart';
import '../../repository/categories_repository.dart';
import '../../repository/note_types_repository.dart';
import '../../repository/notes_list_view_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            create: (context) => serviceLocator<AlarmRepository>()
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PermissionsBloc>.value(
            value: serviceLocator<PermissionsBloc>()
              ..add(CheckPermissions()),
          ),
        ],
        child: Scaffold(
          body: SafeArea(
            minimum: EdgeInsets.symmetric(
              horizontal: kGap16,
              vertical: kGap4
            ),
            child: widget.navigationShell,
          ),
          appBar: JampaAppBar(),
        ),
      ),
    );
  }


}