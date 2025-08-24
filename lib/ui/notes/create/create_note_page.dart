
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/ui/notes/create/create_note_layout.dart';

class CreateNotePage extends StatelessWidget {
  const CreateNotePage({super.key, this.noteId});

  final String? noteId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateNoteCubit>(
      create: (context) => CreateNoteCubit(
          notesRepository: context.read<NotesRepository>(),
      )..fetchNoteForUpdate(noteId),
      child: const CreateNoteLayout(),
    );
  }
}