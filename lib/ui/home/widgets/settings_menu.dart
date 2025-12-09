import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/auth/auth_bloc.dart';
import 'package:jampa_flutter/bloc/sync/sync_bloc.dart';

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

                  // Sync option
                  const Divider(),
                 _syncButton(context),

                  // Disconnect option
                  const Divider(),
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
    // Capture references NOW, while the context is still active
    final router = GoRouter.of(context);
    final settingsMenuCubit = context.read<SettingsMenuCubit>();

    if (state.selectedEntry == SettingsMenuEntry.none) {
      //Not currently in any menu pages, we push normally
      return () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          router.pushNamed(entry.routeName);
          settingsMenuCubit.selectEntry(entry);
        });
      };
    } else if (state.selectedEntry != SettingsMenuEntry.none
        && state.selectedEntry != entry) {
      // Currently in a menu page, but not the one we want to go to
      return () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          router.replaceNamed(entry.routeName);
          settingsMenuCubit.selectEntry(entry);
        });
      };
    }
    // Currently in the same menu page, do nothing thus disable the button
    return null;
  }

  Widget _syncButton(BuildContext context) {
    return BlocBuilder<SyncBloc, SyncState>(
      builder: (context, state) {
        // Detect active sync state safely
        bool isSyncing = state is SyncInProgress;

        // Capture the bloc reference NOW, while the context is still active
        final syncBloc = context.read<SyncBloc>();

        return MenuItemButton(
          onPressed: isSyncing
              ? null
              : () {
                  // Use addPostFrameCallback to ensure the menu finishes closing
                  // before we dispatch the event
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    syncBloc.add(SyncRequested());
                  });
                },
          child: Padding(
            padding: const EdgeInsets.only(
              top: kGap8,
              bottom: kGap8,
            ),
            child: Row(
              children: [
                // show spinner while syncing, otherwise the sync icon
                if (isSyncing)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.sync,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                SizedBox(width: kGap8),
                Text(
                  context.strings.sync_button_tooltip,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _disconnectButton(BuildContext context) {
    // Capture the context references NOW, while the context is still active
    final authBloc = context.read<AuthBloc>();
    final settingsMenuCubit = context.read<SettingsMenuCubit>();
    final navigator = Navigator.of(context);
    final strings = context.strings;

    return MenuItemButton(
      onPressed: () {
        // Use addPostFrameCallback to ensure the menu finishes closing
        // before we show the dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: navigator.context,
            builder: (BuildContext dialogContext) {
              return ConfirmationDialog(
                title: strings.logout_confirmation_title,
                content: strings.logout_confirmation_message,
                confirmButtonText: strings.confirm,
                cancelButtonText: strings.cancel,
                onConfirm: () {
                  // Perform logout
                  authBloc.add(AuthLogoutPressed());
                  // Reset the selected entry to none
                  settingsMenuCubit.selectEntry(SettingsMenuEntry.none);
                  // Close the dialog
                  dialogContext.pop();
                },
                onCancel: () {
                  // Just close the dialog
                  dialogContext.pop();
                }
              );
            }
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kGap8,
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
