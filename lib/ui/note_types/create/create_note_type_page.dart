
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/note_types/create/create_note_type_cubit.dart';
import 'package:jampa_flutter/repository/note_types_repository.dart';
import 'package:jampa_flutter/ui/note_types/create/create_note_type_layout.dart';

class CreateNoteTypePage extends StatelessWidget {
  const CreateNoteTypePage({super.key, this.noteTypeId});

  final String? noteTypeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateNoteTypeCubit>(
      create: (context) => CreateNoteTypeCubit()
        ..fetchNoteTypeForUpdate(noteTypeId),
      child: const CreateNoteTypeLayout(),
    );
  }
}