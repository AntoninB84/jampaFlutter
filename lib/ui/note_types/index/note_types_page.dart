import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/note_types/note_types_bloc.dart';
import 'package:jampa_flutter/ui/note_types/index/note_types_layout.dart';

class NoteTypesPage extends StatefulWidget {
  const NoteTypesPage({super.key});

  @override
  State<NoteTypesPage> createState() => _NoteTypesPageState();
}

class _NoteTypesPageState extends State<NoteTypesPage> {

  late final NoteTypesBloc _noteTypesBloc;

  @override
  void initState() {
    super.initState();
    _noteTypesBloc = NoteTypesBloc();

    // Defer data fetching to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _noteTypesBloc.add(WatchNoteTypesWithCount());
    });
  }

  @override
  void dispose() {
    _noteTypesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteTypesBloc>.value(
      value: _noteTypesBloc,
      child: NoteTypesLayout(),
    );
  }
}