
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/edit/edit_note_bloc.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import 'edit_note_layout.dart';

class EditNotePage extends StatelessWidget {
  const EditNotePage({super.key, this.noteId});

  final String? noteId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditNoteBloc>.value(
      value: serviceLocator<EditNoteBloc>()
        ..add(FetchNoteForUpdate(noteId: noteId)),
      child: const EditNoteLayout(),
    );
  }
}