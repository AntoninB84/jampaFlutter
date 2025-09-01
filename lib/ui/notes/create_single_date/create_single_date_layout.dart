
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/notes/create_single_date/create_single_date_cubit.dart';
import 'package:jampa_flutter/ui/notes/widgets/datetime_input_field.dart';
import 'package:jampa_flutter/ui/widgets/cancel_button.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

class CreateSingleDateLayout extends StatelessWidget {
  const CreateSingleDateLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateSingleDateCubit, CreateSingleDateState>(
      listener: (context, state){
        if(state.hasSubmitted == true){
          if(state.createdSingleDateFormElements != null) {
            if(state.initialSingleDateFormElementIndex != null){
              //Edit the existing single date in the CreateNoteCubit state
              context.read<CreateNoteCubit>()
                  .onUpdateSingleDateElement(
                    state.initialSingleDateFormElementIndex!,
                    state.createdSingleDateFormElements!,
                  );
            }else{
              //Add the created single date to the CreateNoteCubit state
              context.read<CreateNoteCubit>()
                  .onAddSingleDateElement(state.createdSingleDateFormElements!);
            }
            context.pop();
          }else{
            SnackBarX.showError(context, context.strings.generic_error_message);
          }
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
                context.read<CreateSingleDateCubit>().selectStartDateTime(dateTime);
              },
            ),
            const SizedBox(height: 16),
            DatetimeInputField(
              label: context.strings.create_end_date_field_title,
              initialDateTime: state.selectedEndDateTime,
              errorText: state.isValidDate ? null : context.strings.create_date_timeline_error,
              onDateTimeSelected: (dateTime) {
                context.read<CreateSingleDateCubit>().selectEndDateTime(dateTime);
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
    return BlocBuilder<CreateSingleDateCubit, CreateSingleDateState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidDate
              ? () => context.read<CreateSingleDateCubit>().onSubmit()
              : null,
          child: Text(state.initialSingleDateFormElements != null
              ? context.strings.edit : context.strings.create),
        );
      },
    );
  }
}