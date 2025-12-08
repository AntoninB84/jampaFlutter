import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/ui/notes/form/note_form_layout.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../bloc/notes/form/note_form_bloc.dart';

class NoteFormPage extends StatefulWidget {
  const NoteFormPage({super.key, this.noteId});

  final String? noteId;

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  late final SaveNoteBloc _saveNoteBloc;
  late final NoteFormBloc _noteFormBloc;

  @override
  void initState() {
    super.initState();
    // Initialize blocs in initState to avoid blocking build
    _saveNoteBloc = serviceLocator<SaveNoteBloc>();
    _noteFormBloc = NoteFormBloc();

    // Defer heavy operations to after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.noteId != null) {
        _saveNoteBloc.add(FetchNoteEvent(noteId: widget.noteId));
        _noteFormBloc.add(InitializeNoteFormEvent(
          noteId: widget.noteId!,
          isEditing: true
        ));
      }
    });
  }

  @override
  void dispose() {
    _noteFormBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _saveNoteBloc),
        BlocProvider.value(value: _noteFormBloc),
      ],
      child: NoteFormLayout(),
    );
  }
}
