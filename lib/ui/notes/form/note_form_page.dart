import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/ui/notes/form/note_form_layout.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../bloc/notes/form/note_form_bloc.dart';

class NoteFormPage extends StatelessWidget {
  const NoteFormPage({super.key, this.noteId});

  final String? noteId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: serviceLocator<SaveNoteBloc>()
            ..add(FetchNoteEvent(noteId: noteId)),
        ),
        BlocProvider<NoteFormBloc>(
          create: (context) {
            final bloc = NoteFormBloc();
            // Initialize the form if noteId is provided
            if (noteId != null) {
              bloc.add(InitializeNoteFormEvent(
                  noteId: noteId!,
                  isEditing: true
              ));
            }
            return bloc;
          },
        ),
      ],
      child: NoteFormLayout(),
    );
  }
}
