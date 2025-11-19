
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/notes/save/save_note_bloc.dart';
import '../../../bloc/schedule/single_date_form/single_date_form_bloc.dart';
import '../../../utils/service_locator.dart';
import 'single_date_form_layout.dart';

class SingleDateFormPage extends StatelessWidget {
  const SingleDateFormPage({
    super.key,
    this.scheduleId,
    required this.noteId,
    required this.isSavingPersistentData,
  });

  final String noteId;
  final String? scheduleId;
  final bool isSavingPersistentData;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SaveNoteBloc>.value(
          value: serviceLocator<SaveNoteBloc>(),
        ),
        BlocProvider<SingleDateFormBloc>(
            create: (context) => SingleDateFormBloc()..add(
                InitializeSingleDateFormEvent(
                  noteId: noteId,
                  scheduleId: scheduleId,
                  isSavingPersistentData: isSavingPersistentData,
                )
            )
        )
      ],
      child: SingleDateFormLayout(),
    );
  }
}