
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/note_types/note_types_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../repository/note_types_repository.dart';

class NoteTypeSelector extends StatelessWidget {
  const NoteTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteTypesBloc>(
      create: (context) => NoteTypesBloc(
          noteTypesRepository: context.read<NoteTypesRepository>()
      )..add(WatchNoteTypes()),
      child: BlocConsumer<CreateNoteCubit, CreateNoteState>(
        listener: (context, state){
          if(state.note != null){
            context.read<CreateNoteCubit>()
                .onSelectedNoteTypeChanged(state.note!.noteType);
          }
        },
        listenWhen: (previous, current) {
          // Only listen for changes in the note
          return (previous.note != current.note);
        },
        builder: (context, createNoteState) {

          NoteTypeEntity? selectedTypeFromState;

          return BlocConsumer<NoteTypesBloc, NoteTypesState>(
            listener: (context, state) {
              if (state.listStatus.isError) {
                SnackBarX.showError(context, context.strings.generic_error_message);
              }
            },
            listenWhen: (previous, current) {
              // Only listen for changes in the listStatus
              return previous.listStatus != current.listStatus;
            },
            builder: (context, noteTypesState) {
              List<NoteTypeEntity> noteTypes = noteTypesState.noteTypes;
              if(noteTypes.isNotEmpty) {
                selectedTypeFromState = createNoteState.selectedNoteType;
              }

              return DropdownButtonFormField<NoteTypeEntity>(
                decoration: InputDecoration(
                  labelText: context.strings.create_note_type_field_title,
                  border: OutlineInputBorder(),
                ),
                value: selectedTypeFromState,
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
    );
  }
}