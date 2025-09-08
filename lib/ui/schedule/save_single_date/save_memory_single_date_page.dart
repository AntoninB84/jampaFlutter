
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/ui/schedule/save_single_date/save_single_date_layout.dart';

import '../../../bloc/schedule/save_single_date/save_single_date_bloc.dart';
import '../../../utils/service_locator.dart';

class SaveMemorySingleDatePage extends StatelessWidget {
  const SaveMemorySingleDatePage({super.key, this.singleDateIndex});

  final int? singleDateIndex;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateNoteCubit>.value(
          value: serviceLocator<CreateNoteCubit>(),
        ),
        BlocProvider<SaveSingleDateBloc>.value(
          value: serviceLocator<SaveSingleDateBloc>()..add(InitializeWithData(
              isSavingPersistentDate: false,
              singleDateFormElements: singleDateIndex != null
                  ? serviceLocator<CreateNoteCubit>().state.selectedSingleDateElements.elementAtOrNull(singleDateIndex!)
                  : null,
              initialElementIndex: singleDateIndex
          )),
        )
      ],
      child: SaveSingleDateLayout(),
    );
  }
}