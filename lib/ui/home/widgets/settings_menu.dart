import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/auth/auth_bloc.dart';

import '../../../bloc/home/settings_menu/settings_menu_cubit.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../../utils/extensions/app_context_extension.dart';
import '../../../utils/service_locator.dart';
import '../../widgets/confirmation_dialog.dart';

/// A settings menu widget that provides navigation to different settings pages.
class SettingsMenu {

  /// Builds the settings menu widget.
  Widget settingsMenu(BuildContext context) {
    // Using BlocProvider.value to provide the existing instance of SettingsMenuCubit
    return BlocProvider<SettingsMenuCubit>.value(
      value: serviceLocator<SettingsMenuCubit>(),
      child: BlocBuilder<SettingsMenuCubit, SettingsMenuState>(
          builder: (context, state) {
            // Using a MenuAnchor to create a dropdown menu
            // placed relative to the icon button
            return MenuAnchor(
                style: MenuStyle(
                  padding: WidgetStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(kGap8)),
                ),
                builder: (context, controller, child) {
                  return IconButton(
                    onPressed: () {
                      // Toggle the menu open/close state
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

                  // Disconnect option
                 _disconnectButton(context)
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

  Widget _disconnectButton(BuildContext context) {
    return  MenuItemButton(
      onPressed: () {
        showDialog(context: context, builder: (BuildContext dialogContext){
          return ConfirmationDialog(
              title: context.strings.logout_confirmation_title,
              content: context.strings.logout_confirmation_message,
              confirmButtonText: context.strings.confirm,
              cancelButtonText: context.strings.cancel,
              onConfirm: (){
                // Perform logout
                context.read<AuthBloc>().add(AuthLogoutPressed());
                // Reset the selected entry to none
                context.read<SettingsMenuCubit>().selectEntry(SettingsMenuEntry.none);
                // Close the dialog
                dialogContext.pop();
              },
              onCancel: (){
                // Just close the dialog
                dialogContext.pop();
              }
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: kGap24,
          bottom: kGap8,
        ),
        child: Row(
          children: [
            Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(width: kGap8),
            Text(
              context.strings.logout_confirmation_title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
