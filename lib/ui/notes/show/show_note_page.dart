
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/show/show_note_bloc.dart';
import 'package:jampa_flutter/ui/notes/show/show_note_layout.dart';

class ShowNotePage extends StatefulWidget {
  const ShowNotePage({super.key, required this.noteId});

  final String? noteId;

  @override
  State<ShowNotePage> createState() => _ShowNotePageState();
}

class _ShowNotePageState extends State<ShowNotePage> {
  late final ShowNoteBloc _showNoteBloc;

  @override
  void initState() {
    super.initState();
    _showNoteBloc = ShowNoteBloc();

    // Defer data fetching to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNoteBloc.add(GetNoteById(widget.noteId));
      _showNoteBloc.add(WatchSchedulesAndAlarmsByNoteId(widget.noteId));
    });
  }

  @override
  void dispose() {
    _showNoteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShowNoteBloc>.value(
      value: _showNoteBloc,
      child: ShowNoteLayout()
    );
  }
}