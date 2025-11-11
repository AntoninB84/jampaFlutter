
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/schedule/save_recurrent_date/save_recurrent_date_bloc.dart';
import 'package:jampa_flutter/ui/alarm/widgets/alarm_offset_text_field.dart';
import 'package:jampa_flutter/ui/widgets/cancel_button.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/enums/alarm_offset_type_enum.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/alarm/save_alarm/save_alarm_cubit.dart';
import '../../../bloc/schedule/save_single_date/save_single_date_bloc.dart';
import '../../../utils/constants/styles/sizes.dart';

class SaveAlarmLayout extends StatelessWidget {
  const SaveAlarmLayout({super.key,
    required this.isForRecurrentDate,
  });

  final bool isForRecurrentDate;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveAlarmCubit, SaveAlarmState>(
      listener: (context, state) {
        if(state.hasSubmitted == true) {
          if(state.initialAlarmFormElementIndex != null){
            //Editing
            if(state.isSavingPersistentAlarm ?? false){
              // Database updated successfully
              SnackBarX.showSuccess(context,
                  context.strings.alarm_edit_success_feedback);
            }else{
              if(isForRecurrentDate){
                // Edit the existing alarm in the CreateRecurrentDateCubit state
                context.read<SaveRecurrentDateBloc>().add(UpdateAlarmForRecurrence(
                  index: state.initialAlarmFormElementIndex!,
                  updatedAlarm: state.newAlarmFormElements,
                ));
              }else{
                //Edit the existing alarm in the CreateNoteCubit state
                context.read<SaveSingleDateBloc>().add(UpdateAlarm(
                  index: state.initialAlarmFormElementIndex!,
                  updatedAlarm: state.newAlarmFormElements,
                ));
              }
            }
          }else{
            //Creating
            if(state.isSavingPersistentAlarm ?? false){
              // Successfully created and saved to database
              SnackBarX.showSuccess(context,
                  context.strings.alarm_add_success_feedback);
            }else{
              if(isForRecurrentDate){
                //Add the created alarm to the CreateRecurrentDateCubit state
                context.read<SaveRecurrentDateBloc>()
                    .add(AddAlarmForRecurrence(alarm: state.newAlarmFormElements));
              }else{
                //Add the created alarm to the CreateSingleDateCubit state
                context.read<SaveSingleDateBloc>()
                    .add(AddAlarm(alarm: state.newAlarmFormElements));
              }
            }
          }
          // Navigate back
          context.pop();
        } else {
          SnackBarX.showError(context, context.strings.generic_error_message);
        }
      },
      listenWhen: (previous, current) {
        return (previous.hasSubmitted == false && current.hasSubmitted == true);
      },
      builder: (context, state) {
        return Column(
          children: [
            Headers.noActionHeader(
              context: context,
              title: context.strings.alarm_title,
            ),
            const SizedBox(height: kGap16),
            AlarmOffsetTypeSelector(
              selectedValue: state.newAlarmFormElements.selectedOffsetType,
              onChanged: context.read<SaveAlarmCubit>().selectOffsetType
            ),
            const SizedBox(height: kGap16),
            AlarmOffsetTextField(
              value: state.offsetNumberValidator.value.toString(),
              validator: state.offsetNumberValidator,
              isValid: state.isValidOffsetNumber,
              onChanged: context.read<SaveAlarmCubit>().selectOffsetNumber,
            ),
            const SizedBox(height: kGap16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: state.newAlarmFormElements.isSilentAlarm,
                    onChanged: context.read<SaveAlarmCubit>().toggleSilentAlarm
                ),
                const SizedBox(width: kGap8),
                Text(context.strings.alarm_silent_checkbox_title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: kGap32),
            SubmitAlarmButton(),
            const SizedBox(height: kGap16),
            CancelButton()
          ],
        );
      },
    );
  }
}

class AlarmOffsetTypeSelector extends StatelessWidget {
  const AlarmOffsetTypeSelector({super.key,
    required this.selectedValue,
    required this.onChanged
  });

  final AlarmOffsetType selectedValue;
  final Function(AlarmOffsetType?) onChanged;

  String getAlarmOffsetTypeLabel(AlarmOffsetType alarmOffsetType, BuildContext context) {
    switch (alarmOffsetType) {
      case AlarmOffsetType.days:
        return context.strings.alarm_offset_type_days;
      case AlarmOffsetType.hours:
        return context.strings.alarm_offset_type_hours;
      case AlarmOffsetType.minutes:
        return context.strings.alarm_offset_type_minutes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AlarmOffsetType>(
      decoration: InputDecoration(
        labelText: context.strings.alarm_offset_type_field_title,
        border: OutlineInputBorder(
            borderRadius: kRadius8
        ),
      ),
      dropdownColor: Theme.of(context).popupMenuTheme.color,
      borderRadius: kRadius12,
      value: selectedValue,
      items: AlarmOffsetType.values.map((alarmOffsetType) {
        return DropdownMenuItem<AlarmOffsetType>(
          value: alarmOffsetType,
          child: Text(getAlarmOffsetTypeLabel(alarmOffsetType, context)),
        );
      }).toList(),
      onChanged: onChanged
    );
  }
}

class SubmitAlarmButton extends StatelessWidget {
  const SubmitAlarmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveAlarmCubit, SaveAlarmState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidAlarm
              ? () => context.read<SaveAlarmCubit>().onSubmit()
              : null,
          child: Text(state.initialAlarmFormElementIndex != null ? context.strings.edit : context.strings.create),
        );
      },
    );
  }
}