import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/routers/main_router.dart';

enum SettingsMenuEntry {
  categories(AppRoutes.categories),
  noteTypes(AppRoutes.noteTypes),
  none("forceNullForSettingsMenuEntry");

  const SettingsMenuEntry(this.path);
  final String path;

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

  void selectEntry(SettingsMenuEntry entry) {
    emit(state.copyWith(
        selectedEntry: entry,
    ));
  }

  void reset(String? currentPath){
    if(currentPath == null ||  state.selectedEntry == SettingsMenuEntry.none) return;
    bool needsReset = true;

    for(final entry in SettingsMenuEntry.values) {
      if(currentPath.length < entry.path.length) continue;
      String subCurrentPath = currentPath.substring(0, entry.path.length);
      if (subCurrentPath == entry.path) {
        needsReset = false;
        break;
      }
    }
    if(needsReset) {
      emit(state.copyWith(
        selectedEntry: SettingsMenuEntry.none,
      ));
    }
  }
}