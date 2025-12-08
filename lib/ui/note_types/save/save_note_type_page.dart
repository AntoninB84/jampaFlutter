
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/note_types/save/save_note_type_cubit.dart';
import 'package:jampa_flutter/ui/note_types/save/save_note_type_layout.dart';

class SaveNoteTypePage extends StatefulWidget {
  const SaveNoteTypePage({super.key, this.noteTypeId});

  final String? noteTypeId;

  @override
  State<SaveNoteTypePage> createState() => _SaveNoteTypePageState();
}

class _SaveNoteTypePageState extends State<SaveNoteTypePage> {

  late final SaveNoteTypeCubit _saveNoteTypeCubit;

  @override
  void initState() {
    super.initState();

    _saveNoteTypeCubit = SaveNoteTypeCubit();

    // Defer data fetching to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveNoteTypeCubit.fetchNoteTypeForUpdate(widget.noteTypeId);
    });
  }

  @override
  void dispose() {
    _saveNoteTypeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaveNoteTypeCubit>.value(
      value: _saveNoteTypeCubit,
      child: const SaveNoteTypeLayout(),
    );
  }
}