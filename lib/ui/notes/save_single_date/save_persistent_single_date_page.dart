
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/save_single_date/save_single_date_bloc.dart';
import 'package:jampa_flutter/bloc/notes/edit/edit_note_bloc.dart';
import 'package:jampa_flutter/ui/notes/save_single_date/save_single_date_layout.dart';

import '../../../utils/service_locator.dart';

class SavePersistentSingleDatePage extends StatelessWidget {
  const SavePersistentSingleDatePage({super.key, this.singleDateIndex});

  final int? singleDateIndex;

  @override
  Widget build(BuildContext widgetContext) {
    return BlocProvider<EditNoteBloc>.value(
      value: serviceLocator<EditNoteBloc>(),
      child: Builder(
          builder: (context) {
            // Using Builder to have a new context with the EditNoteBloc available
            return BlocProvider<SaveSingleDateBloc>.value(
              value: serviceLocator<SaveSingleDateBloc>()..add(InitializeWithData(
                  noteId: context.read<EditNoteBloc>().state.note?.id,
                  isSavingPersistentDate: true,
                  singleDateFormElements: singleDateIndex != null
                    ? context.read<EditNoteBloc>().state.singleDates
                      .elementAtOrNull(singleDateIndex!)
                    : null,
                  initialElementIndex: singleDateIndex
              )),
              child: SaveSingleDateLayout(),
            );
          }
      ),
    );
  }
}