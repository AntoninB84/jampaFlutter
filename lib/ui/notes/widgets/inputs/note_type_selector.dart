
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/note_types/note_types_bloc.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

class NoteTypeSelector extends StatelessWidget {
  const NoteTypeSelector({super.key, this.value, required this.onChanged});

  final NoteTypeEntity? value;
  final Function(NoteTypeEntity?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteTypesBloc>(
      create: (context) => NoteTypesBloc()..add(WatchNoteTypes()),
      child: BlocConsumer<NoteTypesBloc, NoteTypesState>(
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

            return DropdownButtonFormField<NoteTypeEntity>(
              decoration: InputDecoration(
                labelText: context.strings.create_note_type_field_title,
                border: OutlineInputBorder(),
              ),
              value: value,
              items: noteTypesState.noteTypes.map((noteType) {
                return DropdownMenuItem<NoteTypeEntity>(
                  value: noteType,
                  child: Text(noteType.name),
                );
              }).toList(),
              onChanged: onChanged,
            );
          }
      )
    );
  }
}