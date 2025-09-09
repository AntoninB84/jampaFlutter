
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/schedule/save_recurrent_date/save_recurrent_date_bloc.dart';
import 'package:jampa_flutter/ui/alarm/save_alarm/save_alarm_layout.dart';

import '../../../bloc/alarm/save_alarm/save_alarm_cubit.dart';
import '../../../bloc/schedule/save_single_date/save_single_date_bloc.dart';
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
          if(isForRecurrentDate)
            BlocProvider<SaveRecurrentDateBloc>.value(
              value: serviceLocator<SaveRecurrentDateBloc>(),
            ),
          if(!isForRecurrentDate)
            BlocProvider.value(
              value: serviceLocator<SaveSingleDateBloc>(),
            ),
          BlocProvider(
            create: (context) {
              if(alarmIndex != null){
                if(isForRecurrentDate){
                  final saveRecurrentDateBloc = context.read<SaveRecurrentDateBloc>();
                  return SaveAlarmCubit()..initializeWithData(
                      alarmFormElements: alarmIndex != null ?
                      saveRecurrentDateBloc.state.newRecurrentDateFormElements
                          .alarmsForRecurrence.elementAtOrNull(alarmIndex!)
                          : null,
                      initialElementIndex: alarmIndex
                  );
                }else{
                  final saveSingleDateBloc = context.read<SaveSingleDateBloc>();
                  return SaveAlarmCubit()..initializeWithData(
                      alarmFormElements: alarmIndex != null ?
                        saveSingleDateBloc.state.newSingleDateFormElements
                            .alarmsForSingleDate.elementAtOrNull(alarmIndex!)
                        : null,
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