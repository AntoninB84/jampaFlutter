import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/home/settings_menu/settings_menu_bloc.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../../utils/service_locator.dart';

class SettingsMenu {
  Widget settingsMenu(BuildContext context) {
    return BlocProvider<SettingsMenuCubit>.value(
      value: serviceLocator<SettingsMenuCubit>(),
      child: BlocBuilder<SettingsMenuCubit, SettingsMenuState>(
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
      ),
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
