
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/ui/reminder/form/reminder_form_layout.dart';

import '../../../bloc/notes/save/save_note_bloc.dart';
import '../../../bloc/reminder/form/reminder_form_bloc.dart';
import '../../../utils/service_locator.dart';

class ReminderFormPage extends StatelessWidget {
  const ReminderFormPage({
    super.key,
    required this.scheduleId,
    this.reminderId,
  });

  final String scheduleId;
  final String? reminderId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SaveNoteBloc>.value(
          value: serviceLocator<SaveNoteBloc>(),
        ),
        BlocProvider<ReminderFormBloc>(
            create: (context) => ReminderFormBloc()..add(
                InitializeReminderFormEvent(
                  reminderId: reminderId,
                  scheduleId: scheduleId,
                )
            )
        )
      ],
      child: ReminderFormLayout(),
    );
  }
}