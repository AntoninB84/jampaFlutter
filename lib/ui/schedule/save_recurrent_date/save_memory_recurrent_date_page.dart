
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/schedule/save_recurrent_date/save_recurrent_date_bloc.dart';
import 'package:jampa_flutter/ui/schedule/save_recurrent_date/save_recurrent_date_layout.dart';

import '../../../utils/service_locator.dart';

class SaveMemoryRecurrentDatePage extends StatelessWidget {
  const SaveMemoryRecurrentDatePage({super.key, this.recurrentDateIndex});

  final int? recurrentDateIndex;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateNoteCubit>.value(
          value: serviceLocator<CreateNoteCubit>(),
        ),
        BlocProvider<SaveRecurrentDateBloc>.value(
          value: serviceLocator<SaveRecurrentDateBloc>()..add(InitializeWithData(
              isSavingPersistentDate: false,
              recurrentDateFormElements: recurrentDateIndex != null
                  ? serviceLocator<CreateNoteCubit>().state.selectedRecurrences.elementAtOrNull(recurrentDateIndex!)
                  : SaveRecurrentDateBloc.emptyRecurrentFormElements,
              initialElementIndex: recurrentDateIndex
          )),
        )
      ],
      child: SaveRecurrentDateLayout(),
    );
  }
}