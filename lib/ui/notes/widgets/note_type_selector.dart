
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/note_types/note_types_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../repository/note_types_repository.dart';

class NoteTypeSelector extends StatelessWidget {
  const NoteTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NoteTypesRepository(),
      child: BlocProvider<NoteTypesBloc>(
        create: (context) => NoteTypesBloc(
            noteTypesRepository: context.read<NoteTypesRepository>()
        )..add(WatchNoteTypes()),
        child: BlocConsumer<NoteTypesBloc, NoteTypesState>(
          listener: (context, state) {
            if (state.listStatus.isError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.strings.generic_error_message))
              );
            }
          },
          builder: (context, state) {
            List<NoteTypeEntity> noteTypes = state.noteTypes;

            NoteTypeEntity? selectedType = noteTypes.isNotEmpty ? noteTypes.first : null;

            return BlocConsumer<CreateNoteCubit, CreateNoteState>(
              listener: (context, state){
                if(state.note != null){
                  selectedType = noteTypes.isNotEmpty ?
                      noteTypes.firstWhere(
                        (noteType) => noteType == state.selectedNoteType,
                        orElse: () => noteTypes.first)
                      : null;
                }
              },
              listenWhen: (previous, current) {
                // Only listen for changes in the note
                return previous.note != current.note;
              },
              builder: (context, state) {
                return DropdownButtonFormField<NoteTypeEntity>(
                  decoration: InputDecoration(
                    labelText: context.strings.create_note_type_field_title,
                    border: OutlineInputBorder(),
                  ),
                  value: selectedType,
                  items: noteTypes.map((noteType) {
                    return DropdownMenuItem<NoteTypeEntity>(
                      value: noteType,
                      child: Text(noteType.name),
                    );
                  }).toList(),
                  onChanged: (selectedType) {
                    if (selectedType != null) {
                      context.read<CreateNoteCubit>()
                          .onSelectedNoteTypeChanged(selectedType);
                    }
                  },
                );
              }
            );
          }
        )
      ),
    );
  }
}