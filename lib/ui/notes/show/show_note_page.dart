
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/show/note_bloc.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/ui/notes/show/show_note_layout.dart';

class ShowNotePage extends StatelessWidget {
  const ShowNotePage({super.key, required this.noteId});

  final String? noteId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteBloc>(
      create: (context) => NoteBloc(
        notesRepository: context.read<NotesRepository>(),
      )..add(WatchNoteById(noteId)),
      child: ShowNoteLayout()
    );
  }
}