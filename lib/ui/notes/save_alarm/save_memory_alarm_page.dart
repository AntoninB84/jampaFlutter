

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/save_single_date/save_single_date_cubit.dart';
import 'package:jampa_flutter/ui/notes/save_alarm/save_alarm_layout.dart';

import '../../../bloc/notes/save_alarm/save_alarm_cubit.dart';
import '../../../utils/service_locator.dart';

class SaveMemoryAlarmPage extends StatelessWidget {
  const SaveMemoryAlarmPage({
    super.key,
    this.isForRecurrentDate = false,
    this.alarmIndex
  });

  final bool isForRecurrentDate;
  final int? alarmIndex;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          // if(isForRecurrentDate)
            // BlocProvider<CreateNoteCubit>.value(
            //   value: serviceLocator<CreateNoteCubit>(),
            // ),
          if(!isForRecurrentDate)
            BlocProvider.value(
              value: serviceLocator<SaveSingleDateCubit>(),
            ),
          BlocProvider(
            create: (context) {
              if(alarmIndex != null){
                if(isForRecurrentDate){

                }else{
                  final saveSingleDateCubit = context.read<SaveSingleDateCubit>();
                  return SaveAlarmCubit()..initializeWithData(
                      alarmFormElements: saveSingleDateCubit.state
                          .newSingleDateFormElements.alarmsForSingleDate
                          .elementAtOrNull(alarmIndex!),
                      initialElementIndex: alarmIndex
                  );
                }
              }
              return SaveAlarmCubit();
            }
          ),
        ],
        child: SaveAlarmLayout(isForRecurrentDate: isForRecurrentDate,),
    );
  }
}