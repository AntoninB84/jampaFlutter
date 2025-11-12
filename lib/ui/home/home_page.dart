import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/permissions/permissions_bloc.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../bloc/settings_menu/settings_menu_bloc.dart';
import '../../repository/alarm_repository.dart';
import '../../repository/categories_repository.dart';
import '../../repository/note_types_repository.dart';
import '../../repository/notes_list_view_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

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
          BlocProvider<SettingsMenuCubit>.value(
            value: serviceLocator<SettingsMenuCubit>(),
          )
        ],
        child: Scaffold(
          body: SafeArea(
            minimum: EdgeInsets.symmetric(
              horizontal: kGap16,
              vertical: kGap4
            ),
            child: navigationShell,
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Image.asset("assets/images/logo.png", height: 30,),
            actions: [
              _settingsMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsMenu(BuildContext context) {
    return BlocBuilder<SettingsMenuCubit, SettingsMenuState>(
      builder: (context, state) {
        return MenuAnchor(
            style: MenuStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.all(kGap8)),
            ),
            builder: (context, controller, child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: Icon(Icons.settings),
              );
            },
            menuChildren: <Widget>[
              for (final entry in SettingsMenuEntry.values)
                if(entry != SettingsMenuEntry.none)
                  MenuItemButton(
                    onPressed: onMenuItemPressed(
                      context: context,
                      state: state,
                      entry: entry,
                    ),
                    child: Text(
                        entry.displayName(context)
                    ),
                  ),
            ]
        );
      }
    );
  }

  Function()? onMenuItemPressed({
    required BuildContext context,
    required SettingsMenuState state,
    required SettingsMenuEntry entry,
  }) {
    if (state.selectedEntry == SettingsMenuEntry.none) {
      //Not currently in any menu pages, we push normally
      return () {
        context.pushNamed(entry.routeName);
        context.read<SettingsMenuCubit>().selectEntry(entry);
      };
    } else if (state.selectedEntry != SettingsMenuEntry.none
        && state.selectedEntry != entry) {
      // Currently in a menu page, but not the one we want to go to
      return () {
        context.replaceNamed(entry.routeName);
        context.read<SettingsMenuCubit>().selectEntry(entry);
      };
    }
    // Currently in the same menu page, do nothing thus disable the button
    return null;
  }

}