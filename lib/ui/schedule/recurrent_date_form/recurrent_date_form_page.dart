
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/ui/schedule/recurrent_date_form/recurrent_date_form_layout.dart';

import '../../../bloc/schedule/recurrent_date_form/recurrent_date_form_bloc.dart';
import '../../../utils/service_locator.dart';

class RecurrentDateFormPage extends StatelessWidget {
  const RecurrentDateFormPage({
    super.key,
    required this.noteId,
    this.scheduleId,
  });

  final String noteId;
  final String? scheduleId;

  @override
  Widget build(BuildContext widgetContext) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SaveNoteBloc>.value(
          value: serviceLocator<SaveNoteBloc>(),
        ),
        BlocProvider<RecurrentDateFormBloc>(
          create: (context) => RecurrentDateFormBloc()..add(
            InitializeRecurrentDateFormEvent(
              noteId: noteId,
              scheduleId: scheduleId,
            )
          )
        )
      ],
      child: RecurrentDateFormLayout(),
    );
  }
}