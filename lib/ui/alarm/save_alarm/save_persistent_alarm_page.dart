
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/ui/alarm/save_alarm/save_alarm_layout.dart';

import '../../../bloc/alarm/save_alarm/save_alarm_cubit.dart';
import '../../../bloc/schedule/save_single_date/save_single_date_bloc.dart';
import '../../../utils/service_locator.dart';

class SavePersistentAlarmPage extends StatelessWidget {
  const SavePersistentAlarmPage({ super.key,
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
              value: serviceLocator<SaveSingleDateBloc>(),
            ),
          BlocProvider(
              create: (context) {
                if(isForRecurrentDate){
                  if(alarmIndex != null){
                    // Editing an existing alarm for a recurrent date
                    //TODO
                    return SaveAlarmCubit(
                      isSavingPersistentAlarm: true
                    );
                  }else{
                    // Creating a new alarm for a recurrent date
                    //TODO
                    return SaveAlarmCubit(
                      isSavingPersistentAlarm: true
                    );
                  }
                }else{
                  final saveSingleDateCubit = context.read<SaveSingleDateBloc>();
                  if(alarmIndex != null){
                    // Editing an existing alarm
                    return SaveAlarmCubit()..initializeWithData(
                      isSavingPersistentAlarm: true,
                      alarmFormElements: alarmIndex != null ?
                        saveSingleDateCubit.state.newSingleDateFormElements
                            .alarmsForSingleDate.elementAtOrNull(alarmIndex!)
                        : null,
                      initialElementIndex: alarmIndex
                    );
                  }else{
                    // Creating a new alarm
                    return SaveAlarmCubit(
                      scheduleId: saveSingleDateCubit.state.newSingleDateFormElements.scheduleId,
                      isSavingPersistentAlarm: true
                    );
                  }
                }
              }
          ),
        ],
        child: SaveAlarmLayout(isForRecurrentDate: isForRecurrentDate,)
    );
  }
}