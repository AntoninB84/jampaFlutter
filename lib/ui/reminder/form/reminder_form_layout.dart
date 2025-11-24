
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/reminder/form/reminder_form_bloc.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/notes/save/save_note_bloc.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/headers.dart';
import '../../widgets/jampa_scaffolded_app_bar_widget.dart';
import '../../widgets/snackbar.dart';
import '../widgets/reminder_offset_text_field.dart';
import '../widgets/reminder_offset_type_selector.dart';

class ReminderFormLayout extends StatelessWidget {
  const ReminderFormLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveNoteBloc, SaveNoteState>(
      listener: (context, state) {
        // Listen for the save status changes to show feedback
        if (state.remindersSavingStatus.isFailure) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.remindersSavingStatus.isSuccessful) {
          SnackBarX.showSuccess(context, context.strings.save_reminder_success_feedback);
          // Back to the previous screen after success
          context.pop();
        }
      },
      listenWhen: (previous, current) {
        return previous.remindersSavingStatus != current.remindersSavingStatus;
      },
      child: BlocBuilder<ReminderFormBloc, ReminderFormState>(
            builder: (context, state) {
            return JampaScaffoldedAppBarWidget(
              actions: [
                Buttons.saveButtonIcon(
                  context: context,
                  onPressed: state.canSubmitForm
                      ? () => context.read<ReminderFormBloc>().add(
                          OnSubmitReminderFormEvent())
                      : null,
                )
              ],
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Headers.basicHeader(
                      context: context,
                      title: context.strings.reminder_title,
                    ),
                    const SizedBox(height: kGap16),

                    // Offset Type Selector
                    ReminderOffsetTypeSelector(
                        selectedValue: state.newReminderFormElements.selectedOffsetType,
                        onChanged: (offsetType) => context.read<ReminderFormBloc>()
                            .add(SelectOffsetTypeEvent(offsetType: offsetType)
                        )
                    ),
                    const SizedBox(height: kGap16),

                    // Offset Number Text Field
                    ReminderOffsetTextField(
                      value: state.offsetNumberValidator.value.toString(),
                      validator: state.offsetNumberValidator,
                      onChanged: (value) => context.read<ReminderFormBloc>()
                          .add(SelectOffsetNumberEvent(offsetNumber: value)),
                    ),
                    const SizedBox(height: kGap16),

                    // Is Notification Checkbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            value: state.newReminderFormElements.isNotification,
                            onChanged: (isNotif) => context.read<ReminderFormBloc>()
                                .add(ToggleIsNotificationEvent(
                                isNotification: isNotif ?? true)
                            )
                        ),
                        const SizedBox(width: kGap8),
                        Text(context.strings.reminder_silent_checkbox_title,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: kGap32),
                  ],
                ),
              )
            );
          }
        ),
);
  }
}
