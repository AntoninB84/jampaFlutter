
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/notes/create_single_date/save_single_date_cubit.dart';
import 'package:jampa_flutter/bloc/notes/edit/edit_note_bloc.dart';
import 'package:jampa_flutter/ui/notes/create_single_date/save_single_date_layout.dart';

import '../../../utils/service_locator.dart';

class SavePersistentSingleDatePage extends StatelessWidget {
  const SavePersistentSingleDatePage({super.key, this.singleDateIndex});

  final int? singleDateIndex;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<EditNoteBloc>.value(
            value: serviceLocator<EditNoteBloc>(),
          ),
          BlocProvider(
            create: (context) {
              final editNoteBloc = context.read<EditNoteBloc>();
              if(singleDateIndex != null){
                return SaveSingleDateCubit()..initializeWithData(
                  isSavingPersistentDate: true,
                  singleDateFormElements: editNoteBloc.state.singleDates.elementAtOrNull(singleDateIndex!),
                  initialElementIndex: singleDateIndex
                );
              }else{
                final noteId = editNoteBloc.state.note!.id;
                return SaveSingleDateCubit(
                  noteId: noteId,
                  isSavingPersistentData: true
                );
              }
            }
          ),
        ],
        child: SaveSingleDateLayout(),
    );
  }
}