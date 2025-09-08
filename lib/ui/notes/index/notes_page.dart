import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/list_view/notes_list_view_bloc.dart';
import 'package:jampa_flutter/ui/notes/index/notes_layout.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesListViewBloc>(
      create: (context) => NotesListViewBloc()..add(WatchNotes()),
      child: const NotesLayout(),
    );
  }
}