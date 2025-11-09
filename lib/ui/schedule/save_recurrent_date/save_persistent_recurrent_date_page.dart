
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/edit/edit_note_bloc.dart';
import 'package:jampa_flutter/bloc/schedule/save_recurrent_date/save_recurrent_date_bloc.dart';
import 'package:jampa_flutter/ui/schedule/save_recurrent_date/save_recurrent_date_layout.dart';

import '../../../utils/service_locator.dart';

class SavePersistentRecurrentDatePage extends StatelessWidget {
  const SavePersistentRecurrentDatePage({super.key, this.recurrentDateIndex, this.scheduleId});

  final int? recurrentDateIndex;
  final int? scheduleId;

  @override
  Widget build(BuildContext widgetContext) {
    return BlocProvider<EditNoteBloc>.value(
      value: serviceLocator<EditNoteBloc>(),
      child: Builder(
          builder: (context) {
            // Using Builder to have a new context with the EditNoteBloc available
            return BlocProvider<SaveRecurrentDateBloc>.value(
              value: serviceLocator<SaveRecurrentDateBloc>()..add(InitializeWithData(
                  noteId: context.read<EditNoteBloc>().state.note?.id,
                  isSavingPersistentDate: true,
                  scheduleId: scheduleId,
                  recurrentDateFormElements: recurrentDateIndex != null
                    ? context.read<EditNoteBloc>().state.recurrentDates
                      .elementAtOrNull(recurrentDateIndex!)
                    : null,
                  initialElementIndex: recurrentDateIndex
              )),
              child: SaveRecurrentDateLayout(),
            );
          }
      ),
    );
  }
}