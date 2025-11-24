import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/data/models/reminder.dart';
import 'package:jampa_flutter/ui/widgets/Commons.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/ui/widgets/confirmation_dialog.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../utils/constants/styles/sizes.dart';

/// A widget that displays a list of reminders associated with a specific schedule.
/// It allows users to add, edit, and delete reminders
/// inside of the single or recurring schedule form.
class SaveReminderList extends StatefulWidget {
  const SaveReminderList({
    super.key,
    required this.scheduleId,
    this.isEditing = false,
  });

  /// The ID of the schedule to which the reminders are associated.
  final String scheduleId;

  /// A flag indicating whether the reminders are being edited.
  /// This is used to customize the delete confirmation message.
  final bool isEditing;

  @override
  State<SaveReminderList> createState() => _SaveReminderListState();
}

class _SaveReminderListState extends State<SaveReminderList> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveNoteBloc, SaveNoteState>(
      listener: (context, state) {
        // Do nothing for now
      },
      buildWhen: (previous, current) {
        return previous.reminders != current.reminders;
      },
      builder: (context, state) {
        // Filter reminders associated with the given scheduleId from
        // the [SaveNoteBloc] state.
        List<ReminderEntity> listElements = state.reminders
            .where((reminder) => reminder.scheduleId == widget.scheduleId)
            .toList();

        return Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                context.strings.create_date_reminder_count,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: kGap8),
            Commons.secondaryListsContainer(
              context: context,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        context.pushNamed("ReminderForm", extra: {
                          'scheduleId': widget.scheduleId,
                        });
                      },
                      child: Text(context.strings.create_date_add_reminder_button)
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listElements.length,
                      itemBuilder: (context, index) {

                        final reminder = listElements[index];

                        // Generate the display text for the reminder
                        // e.g., "10 minutes before"
                        final String displayText = context.strings
                            .reminder_display_text(
                          reminder.offsetValue,
                          (index + 1),
                          reminder.offsetType.getLabel(context),
                        );

                        return Material(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: kGap4,
                            ),
                            child: ListTile(
                              dense: true,
                              title: Text(displayText),
                              onTap: (){
                                // Navigate to the ReminderForm for editing
                                context.pushNamed("ReminderForm", extra: {
                                  'scheduleId': reminder.scheduleId,
                                  'reminderId': reminder.id,
                                });
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Buttons.deleteButtonIcon(
                                    context: context,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) => ConfirmationDialog(
                                            title: context.strings.reminder_delete_confirmation_title,
                                            content: context.strings.reminder_delete_confirmation_message(
                                                index, widget.isEditing.toString()
                                            ),
                                            confirmButtonText: context.strings.delete,
                                            cancelButtonText: context.strings.cancel,
                                            onCancel: () {
                                              // Close the dialog
                                              dialogContext.pop();
                                            },
                                            onConfirm: () {
                                              // Delete or remove the reminder
                                              context.read<SaveNoteBloc>()
                                                  .add(RemoveOrDeleteReminderEvent(reminder.id));
                                              // Close the dialog
                                              dialogContext.pop();
                                            }
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}