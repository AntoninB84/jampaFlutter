
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/ui/notes/save_alarm/save_alarm_layout.dart';

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
              if(alarmIndex != null){
                if(isForRecurrentDate){

                }else{
                  final saveSingleDateCubit = context.read<SaveSingleDateBloc>();
                  return SaveAlarmCubit()..initializeWithData(
                      alarmFormElements: alarmIndex != null ?
                        saveSingleDateCubit.state.newSingleDateFormElements
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