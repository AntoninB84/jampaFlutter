
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/notes/save_single_date/save_single_date_cubit.dart';
import 'package:jampa_flutter/ui/notes/save_single_date/save_single_date_layout.dart';

import '../../../utils/service_locator.dart';

class SaveMemorySingleDatePage extends StatelessWidget {
  const SaveMemorySingleDatePage({super.key, this.singleDateIndex});

  final int? singleDateIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateNoteCubit>.value(
      value: serviceLocator<CreateNoteCubit>(),
      child: Builder(
          builder: (context) {
            // Using Builder to have a new context with the CreateNoteCubit available
            return BlocProvider<SaveSingleDateCubit>.value(
              value: serviceLocator<SaveSingleDateCubit>()..initializeWithData(
                  isSavingPersistentDate: false,
                  singleDateFormElements: context.read<CreateNoteCubit>()
                      .state.selectedSingleDateElements.elementAtOrNull(singleDateIndex!),
                  initialElementIndex: singleDateIndex
              ),
              child: SaveSingleDateLayout(),
            );
          }
      ),
    );
  }
}