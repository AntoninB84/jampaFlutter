
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/ui/reminder/form/reminder_form_layout.dart';

import '../../../bloc/notes/save/save_note_bloc.dart';
import '../../../bloc/reminder/form/reminder_form_bloc.dart';
import '../../../utils/service_locator.dart';

class ReminderFormPage extends StatefulWidget {
  const ReminderFormPage({
    super.key,
    required this.scheduleId,
    required this.noteId,
    this.reminderId,
  });

  final String scheduleId;
  final String noteId;
  final String? reminderId;

  @override
  State<ReminderFormPage> createState() => _ReminderFormPageState();
}

class _ReminderFormPageState extends State<ReminderFormPage> {
  late final SaveNoteBloc _saveNoteBloc;
  late final ReminderFormBloc _reminderFormBloc;

  @override
  void initState() {
    super.initState();
    _saveNoteBloc = serviceLocator<SaveNoteBloc>();
    _reminderFormBloc = ReminderFormBloc();

    // Defer initialization to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reminderFormBloc.add(
        InitializeReminderFormEvent(
          reminderId: widget.reminderId,
          scheduleId: widget.scheduleId,
          noteId: widget.noteId,
        )
      );
    });
  }

  @override
  void dispose() {
    _reminderFormBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SaveNoteBloc>.value(value: _saveNoteBloc),
        BlocProvider<ReminderFormBloc>.value(value: _reminderFormBloc),
      ],
      child: ReminderFormLayout(),
    );
  }
}