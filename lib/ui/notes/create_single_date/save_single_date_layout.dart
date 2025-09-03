
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/notes/create_single_date/save_single_date_cubit.dart';
import 'package:jampa_flutter/ui/notes/widgets/datetime_input_field.dart';
import 'package:jampa_flutter/ui/widgets/cancel_button.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

class SaveSingleDateLayout extends StatelessWidget {
  const SaveSingleDateLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveSingleDateCubit, SaveSingleDateState>(
      listener: (context, state){
        if(state.hasSubmitted == true && state.createdSingleDateFormElements != null){
          if(state.initialSingleDateFormElementIndex != null){
            if(state.isSavingPersistentDate ?? false){
              SnackBarX.showSuccess(context, 
                  context.strings.edit_single_date_success_feedback);
            }else{
              //Edit the existing single date in the CreateNoteCubit state
              context.read<CreateNoteCubit>().onUpdateSingleDateElement(
                state.initialSingleDateFormElementIndex!,
                state.createdSingleDateFormElements!,
              );
            }
          }else{
            if(state.isSavingPersistentDate ?? false){
              SnackBarX.showSuccess(context,
                  context.strings.create_single_date_success_feedback);
            }else{
              //Add the created single date to the CreateNoteCubit state
              context.read<CreateNoteCubit>()
                  .onAddSingleDateElement(state.createdSingleDateFormElements!);
            }
          }
          // Navigate back
          context.pop();
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
              initialDateTime: state.selectedStartDateTime,
              onDateTimeSelected: (dateTime) {
                context.read<SaveSingleDateCubit>().selectStartDateTime(dateTime);
              },
            ),
            const SizedBox(height: 16),
            DatetimeInputField(
              label: context.strings.create_end_date_field_title,
              initialDateTime: state.selectedEndDateTime,
              errorText: state.isValidDate ? null : context.strings.create_date_timeline_error,
              onDateTimeSelected: (dateTime) {
                context.read<SaveSingleDateCubit>().selectEndDateTime(dateTime);
              },
            ),
            const SizedBox(height: 32,),
            SubmitSingleDateButton(),
            const SizedBox(height: 16,),
            CancelButton(),
          ],
        );
      },
    );
  }
}

class SubmitSingleDateButton extends StatelessWidget {
  const SubmitSingleDateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveSingleDateCubit, SaveSingleDateState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidDate
              ? () => context.read<SaveSingleDateCubit>().onSubmit()
              : null,
          child: Text(state.initialSingleDateFormElements != null
              ? context.strings.edit : context.strings.create),
        );
      },
    );
  }
}