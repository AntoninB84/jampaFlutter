
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/notes/create_single_date/create_single_date_cubit.dart';
import 'package:jampa_flutter/ui/notes/create_single_date/create_single_date_layout.dart';

import '../../../utils/service_locator.dart';

class CreateSingleDatePage extends StatelessWidget {
  const CreateSingleDatePage({super.key, this.singleDateIndex});

  final int? singleDateIndex;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<CreateNoteCubit>.value(
            value: serviceLocator<CreateNoteCubit>(),
          ),
          BlocProvider(
            create: (context) {
              if(singleDateIndex != null){
                final createNoteCubit = context.read<CreateNoteCubit>();
                return CreateSingleDateCubit()..initializeWithData(
                  singleDateFormElements: createNoteCubit.state.selectedSingleDateElements.elementAtOrNull(singleDateIndex!),
                  initialElementIndex: singleDateIndex
                );
              }
              return CreateSingleDateCubit();
            }
          ),
        ],
        child: CreateSingleDateLayout(),
    );
  }
}