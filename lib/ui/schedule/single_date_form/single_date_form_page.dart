
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/notes/save/save_note_bloc.dart';
import '../../../bloc/schedule/single_date_form/single_date_form_bloc.dart';
import '../../../utils/service_locator.dart';
import 'single_date_form_layout.dart';

class SingleDateFormPage extends StatefulWidget {
  const SingleDateFormPage({
    super.key,
    this.scheduleId,
    required this.noteId,
  });

  final String noteId;
  final String? scheduleId;

  @override
  State<SingleDateFormPage> createState() => _SingleDateFormPageState();
}

class _SingleDateFormPageState extends State<SingleDateFormPage> {
  late final SaveNoteBloc _saveNoteBloc;
  late final SingleDateFormBloc _singleDateFormBloc;

  @override
  void initState() {
    super.initState();
    _saveNoteBloc = serviceLocator<SaveNoteBloc>();
    _singleDateFormBloc = SingleDateFormBloc();

    // Defer initialization to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _singleDateFormBloc.add(
        InitializeSingleDateFormEvent(
          noteId: widget.noteId,
          scheduleId: widget.scheduleId,
        )
      );
    });
  }

  @override
  void dispose() {
    _singleDateFormBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SaveNoteBloc>.value(value: _saveNoteBloc),
        BlocProvider<SingleDateFormBloc>.value(value: _singleDateFormBloc),
      ],
      child: SingleDateFormLayout(),
    );
  }
}