import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/note_types/note_types_bloc.dart';
import 'package:jampa_flutter/ui/note_types/index/note_types_layout.dart';

class NoteTypesPage extends StatelessWidget {
  const NoteTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteTypesBloc>(
      create: (context) => NoteTypesBloc()
        ..add(WatchNoteTypesWithCount()),
      child: const NoteTypesLayout(),
    );
  }
}