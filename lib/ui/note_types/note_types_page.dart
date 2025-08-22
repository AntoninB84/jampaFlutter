import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/note_types/note_types_bloc.dart';
import 'package:jampa_flutter/repository/note_types_repository.dart';
import 'package:jampa_flutter/ui/note_types/note_types_layout.dart';

class NoteTypesPage extends StatelessWidget {
  const NoteTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => NoteTypesRepository(),
        child: BlocProvider<NoteTypesBloc>(
          create: (context) => NoteTypesBloc(
              noteTypesRepository: context.read<NoteTypesRepository>()
          )..add(ListenNoteTypes()),

          child: const NoteTypesLayout(),
        )
    );
  }
}