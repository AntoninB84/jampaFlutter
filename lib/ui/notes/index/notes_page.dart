import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/list_view/notes_list_view_bloc.dart';
import 'package:jampa_flutter/bloc/notes/show/show_note_bloc.dart';
import 'package:jampa_flutter/ui/notes/index/notes_layout.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  late final NotesListViewBloc _notesListViewBloc;
  late final ShowNoteBloc _showNoteBloc;

  @override
  void initState() {
    super.initState();

    // Initialize blocs
    _notesListViewBloc = NotesListViewBloc();
    _showNoteBloc = ShowNoteBloc();

    // Defer any initial events to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notesListViewBloc.add(WatchNotes());
    });
  }

  @override
  void dispose() {
    _notesListViewBloc.close();
    _showNoteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotesListViewBloc>.value(
          value: _notesListViewBloc,
        ),
        // Provided for handling status and delete actions of individual notes
        BlocProvider<ShowNoteBloc>.value(
          value: _showNoteBloc,
        ),
      ],
      child: const NotesLayout(),
    );
  }
}