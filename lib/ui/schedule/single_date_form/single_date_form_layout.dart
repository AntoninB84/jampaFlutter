import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/schedule/single_date_form/single_date_form_bloc.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/home/app_bar_cubit.dart';
import '../../../bloc/notes/save/save_note_bloc.dart';
import '../../reminder/widgets/save_alarm_list.dart';
import '../../widgets/app_bar_config_widget.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/headers.dart';
import '../../widgets/inputs/datetime_input_field.dart';
import '../../widgets/snackbar.dart';

class SingleDateFormLayout extends StatelessWidget {
  const SingleDateFormLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveNoteBloc, SaveNoteState>(
      listener: (context, state) {
        if (state.singleDateSavingStatus.isFailure) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.singleDateSavingStatus.isSaved) {
          //TODO message
          SnackBarX.showSuccess(context, context.strings.edit_recurrent_date_success_feedback);
          // Back to the previous screen after success
          context.pop();
        }
      },
      listenWhen: (previous, current) {
        return previous.singleDateSavingStatus != current.singleDateSavingStatus;
      },
      child: BlocBuilder<SingleDateFormBloc, SingleDateFormState>(
        builder: (context, state) {
          return AppBarConfigWidget(
            config: AppBarConfig(
                leading: Buttons.backButtonIcon(
                    context: context,
                    onPressed: () {
                      context.pop();
                    }
                ),
                actions: [
                  Buttons.saveButtonIcon(
                    context: context,
                    onPressed: state.isValidDate
                        ? () => context.read<SingleDateFormBloc>()
                        .add(OnSubmitSingleDateEvent())
                        : null,
                  )
                ]
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Headers.basicHeader(
                      context: context,
                      title: context.strings.create_date_title,
                    ),
                    const SizedBox(height: kGap16),
                    DatetimeInputField(
                      label: context.strings.create_start_date_field_title,
                      initialDateTime: state.newSingleDateFormElements
                          .selectedStartDateTime,
                      onDateTimeSelected: (dateTime) {
                        context.read<SingleDateFormBloc>().add(
                            SelectStartDateTimeEvent(dateTime: dateTime)
                        );
                      },
                    ),
                    const SizedBox(height: kGap16),
                    DatetimeInputField(
                      label: context.strings.create_end_date_field_title,
                      initialDateTime: state.newSingleDateFormElements
                          .selectedEndDateTime,
                      errorText: state.isValidDate ? null : context.strings
                          .create_date_timeline_error,
                      onDateTimeSelected: (dateTime) {
                        context.read<SingleDateFormBloc>().add(
                            SelectEndDateTimeEvent(dateTime: dateTime)
                        );
                      },
                    ),
                    const SizedBox(height: kGap16),
                    SaveAlarmList(
                      noteId: state.newSingleDateFormElements.noteId,
                      scheduleId: state.newSingleDateFormElements.scheduleId,
                      isEditing: state.isEditing,
                    ),
                    const SizedBox(height: kGap32,),
                  ],
                ),
              ),
            )
          );
        }
      ),
    );
  }
}