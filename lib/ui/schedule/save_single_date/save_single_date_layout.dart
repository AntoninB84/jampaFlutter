
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/home/app_bar_cubit.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/ui/alarm/widgets/save_alarm_list.dart';
import 'package:jampa_flutter/ui/widgets/Commons.dart';
import 'package:jampa_flutter/ui/widgets/app_bar_config_widget.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/ui/widgets/inputs/datetime_input_field.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/schedule/save_single_date/save_single_date_bloc.dart';

class SaveSingleDateLayout extends StatelessWidget {
  const SaveSingleDateLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarConfigWidget(
      config: AppBarConfig(
        leading: Buttons.backButtonIcon(
            context: context,
            onPressed: (){
              context.pop();
              context.read<SaveSingleDateBloc>().add(ResetState());
            }
        )
      ),
      child: BlocConsumer<SaveSingleDateBloc, SaveSingleDateState>(
        listener: (context, state){
          if(state.hasSubmitted == true){
            if(state.initialSingleDateFormElementIndex != null){
              if(state.isSavingPersistentDate ?? false){
                // Database updated successfully
                SnackBarX.showSuccess(context,
                    context.strings.edit_single_date_success_feedback);
              }else{
                //Edit the existing single date in the CreateNoteCubit state
                context.read<CreateNoteCubit>().onUpdateSingleDateElement(
                  state.initialSingleDateFormElementIndex!,
                  state.newSingleDateFormElements!,
                );
              }
            }else{
              if(state.isSavingPersistentDate ?? false){
                // Successfully created and saved to database
                SnackBarX.showSuccess(context,
                    context.strings.create_single_date_success_feedback);
              }else{
                //Add the created single date to the CreateNoteCubit state
                context.read<CreateNoteCubit>()
                    .onAddSingleDateElement(state.newSingleDateFormElements!);
              }
            }
            // Navigate back
            context.pop();
            context.read<SaveSingleDateBloc>().add(ResetState());
          }else{
            SnackBarX.showError(context, context.strings.generic_error_message);
          }
        },
        listenWhen: (previous, current){
          return (previous.hasSubmitted == false && current.hasSubmitted == true);
        },
        builder: (context, state){
          return SingleChildScrollView(
            child: Column(
              children: [
                Headers.basicHeader(
                  context: context,
                  title: context.strings.create_date_title,
                ),
                const SizedBox(height: kGap16),
                DatetimeInputField(
                  label: context.strings.create_start_date_field_title,
                  initialDateTime: state.newSingleDateFormElements.selectedStartDateTime,
                  onDateTimeSelected: (dateTime) {
                    context.read<SaveSingleDateBloc>().add(
                        SelectStartDateTime(dateTime: dateTime)
                    );
                  },
                ),
                const SizedBox(height: kGap16),
                DatetimeInputField(
                  label: context.strings.create_end_date_field_title,
                  initialDateTime: state.newSingleDateFormElements.selectedEndDateTime,
                  errorText: state.isValidDate ? null : context.strings.create_date_timeline_error,
                  onDateTimeSelected: (dateTime) {
                    context.read<SaveSingleDateBloc>().add(
                        SelectEndDateTime(dateTime: dateTime)
                    );
                  },
                ),
                const SizedBox(height: kGap16),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    context.strings.create_date_alarm_count(
                      state.newSingleDateFormElements.alarmsForSingleDate.length
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: kGap8),
                Commons.secondaryListsContainer(
                  context: context,
                  child: SaveAlarmList(
                    isSavingPersistentData: state.scheduleId != null,
                    listElements: state.newSingleDateFormElements.alarmsForSingleDate,
                    onDateDeleted: (value) {
                      context.read<SaveSingleDateBloc>().add(RemoveAlarm(index: value));
                    },
                  ),
                ),
                const SizedBox(height: kGap16,),
                SubmitSingleDateButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SubmitSingleDateButton extends StatelessWidget {
  const SubmitSingleDateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveSingleDateBloc, SaveSingleDateState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidDate
              ? () => context.read<SaveSingleDateBloc>().add(OnSubmit())
              : null,
          child: Text(state.initialSingleDateFormElementIndex != null
              ? context.strings.edit : context.strings.create),
        );
      },
    );
  }
}