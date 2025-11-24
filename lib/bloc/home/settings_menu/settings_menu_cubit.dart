import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/routers/main_router.dart';

/// Represents the different entries in the settings menu.
enum SettingsMenuEntry {
  categories(AppRoutes.categories),
  noteTypes(AppRoutes.noteTypes),
  none("forceNullForSettingsMenuEntry");

  const SettingsMenuEntry(this.path);
  final String path;

  /// Returns the go-route name associated with the menu entry.
  String get routeName {
    switch (this) {
      case SettingsMenuEntry.categories:
        return 'Categories';
      case SettingsMenuEntry.noteTypes:
        return 'NoteTypes';
      case SettingsMenuEntry.none:
        return SettingsMenuEntry.none.path;
    }
  }

  /// Returns the display name for the menu entry
  /// based on the current context for internationalization.
  String displayName(BuildContext context) {
    switch (this) {
      case SettingsMenuEntry.categories:
        return context.strings.categories;
      case SettingsMenuEntry.noteTypes:
        return context.strings.note_types;
      case SettingsMenuEntry.none:
        return SettingsMenuEntry.none.path;
    }
  }
}

//region State
class SettingsMenuState extends Equatable {
  /// The currently selected entry in the settings menu.
  final SettingsMenuEntry selectedEntry;

  const SettingsMenuState({
    required this.selectedEntry,
  });

  SettingsMenuState copyWith({
    required SettingsMenuEntry selectedEntry,
  }) {
    return SettingsMenuState(
      selectedEntry: selectedEntry ,
    );
  }

  @override
  List<Object?> get props => [
    selectedEntry,
  ];
}
//endregion

class SettingsMenuCubit extends Cubit<SettingsMenuState> {
  SettingsMenuCubit() : super(
    SettingsMenuState(selectedEntry: SettingsMenuEntry.none,)
  );

  /// Selects a specific entry in the settings menu.
  void selectEntry(SettingsMenuEntry entry) {
    emit(state.copyWith(
        selectedEntry: entry,
    ));
  }

  /// Resets the selected entry if the current path does not match any known entries.
  void reset(String? currentPath){
    // If there's no current path or the selected entry is 'none', do nothing.
    if(currentPath == null ||  state.selectedEntry == SettingsMenuEntry.none) return;

    bool needsReset = true;

    for(final entry in SettingsMenuEntry.values) {
      // Skip any entry having longer path than the current path.
      // It can't be a match.
      if(currentPath.length < entry.path.length) continue;

      // Check if the start of the current path matches the entry's path.
      // Matches with sub-routes as well.
      String subCurrentPath = currentPath.substring(0, entry.path.length);
      if (subCurrentPath == entry.path) {
        // Found a matching entry; no need to reset.
        needsReset = false;
        break;
      }
    }
    // If no matching entry was found, reset the selected entry to 'none'.
    if(needsReset) {
      emit(state.copyWith(
        selectedEntry: SettingsMenuEntry.none,
      ));
    }
  }
}