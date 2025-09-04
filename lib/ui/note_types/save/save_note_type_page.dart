
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/note_types/save/save_note_type_cubit.dart';
import 'package:jampa_flutter/ui/note_types/save/save_note_type_layout.dart';

class SaveNoteTypePage extends StatelessWidget {
  const SaveNoteTypePage({super.key, this.noteTypeId});

  final String? noteTypeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaveNoteTypeCubit>(
      create: (context) => SaveNoteTypeCubit()
        ..fetchNoteTypeForUpdate(noteTypeId),
      child: const SaveNoteTypeLayout(),
    );
  }
}