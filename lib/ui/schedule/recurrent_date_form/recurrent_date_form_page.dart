
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/ui/schedule/recurrent_date_form/recurrent_date_form_layout.dart';

import '../../../bloc/schedule/recurrent_date_form/recurrent_date_form_bloc.dart';
import '../../../utils/service_locator.dart';

class RecurrentDateFormPage extends StatefulWidget {
  const RecurrentDateFormPage({
    super.key,
    required this.noteId,
    this.scheduleId,
  });

  final String noteId;
  final String? scheduleId;

  @override
  State<RecurrentDateFormPage> createState() => _RecurrentDateFormPageState();
}

class _RecurrentDateFormPageState extends State<RecurrentDateFormPage> {
  late final SaveNoteBloc _saveNoteBloc;
  late final RecurrentDateFormBloc _recurrentDateFormBloc;

  @override
  void initState() {
    super.initState();
    _saveNoteBloc = serviceLocator<SaveNoteBloc>();
    _recurrentDateFormBloc = RecurrentDateFormBloc();
    
    // Defer initialization to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recurrentDateFormBloc.add(
        InitializeRecurrentDateFormEvent(
          noteId: widget.noteId,
          scheduleId: widget.scheduleId,
        )
      );
    });
  }

  @override
  void dispose() {
    _recurrentDateFormBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext widgetContext) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SaveNoteBloc>.value(value: _saveNoteBloc),
        BlocProvider<RecurrentDateFormBloc>.value(value: _recurrentDateFormBloc),
      ],
      child: RecurrentDateFormLayout(),
    );
  }
}