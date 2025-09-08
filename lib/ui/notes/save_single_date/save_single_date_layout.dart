
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/ui/notes/widgets/lists/save_alarm_list_dialog.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/datetime_input_field.dart';
import 'package:jampa_flutter/ui/widgets/cancel_button.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/schedule/save_single_date/save_single_date_bloc.dart';

class SaveSingleDateLayout extends StatelessWidget {
  const SaveSingleDateLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveSingleDateBloc, SaveSingleDateState>(
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
        return Column(
          children: [
            DatetimeInputField(
              label: context.strings.create_start_date_field_title,
              initialDateTime: state.newSingleDateFormElements.selectedStartDateTime,
              onDateTimeSelected: (dateTime) {
                context.read<SaveSingleDateBloc>().add(
                    SelectStartDateTime(dateTime: dateTime)
                );
              },
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            AlarmListButton(
              isSavingPersistentData: state.isSavingPersistentDate ?? false,
              blocContext: context,
              elements: state.newSingleDateFormElements.alarmsForSingleDate,
            ),
            const SizedBox(height: 32,),
            SubmitSingleDateButton(),
            const SizedBox(height: 16,),
            CancelButton(
              onPressed: () {
                context.read<SaveSingleDateBloc>().add(ResetState());
              },
            ),
          ],
        );
      },
    );
  }
}

class AlarmListButton extends StatelessWidget {
  const AlarmListButton({super.key,
    required this.blocContext,
    required this.elements,
    this.isSavingPersistentData = false
  });

  final BuildContext blocContext;
  final List elements;
  final bool isSavingPersistentData;

  @override
  Widget build(BuildContext listContext) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )
            )
        ),
        onPressed: () {
          showDialog(
              context: listContext,
              builder: (dialogContext) {
                return SaveAlarmListDialog(
                  isSavingPersistentData: isSavingPersistentData,
                  listElements: elements as List<AlarmFormElements>,
                  onDateDeleted: (value) {
                    blocContext.read<SaveSingleDateBloc>()
                        .add(RemoveAlarm(index: value));
                    },
                );
              }
          );
        },
        child: Text(listContext.strings.create_date_alarm_count(elements.length)
        ),
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