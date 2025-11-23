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

class SaveReminderList extends StatefulWidget {
  const SaveReminderList({
    super.key,
    required this.noteId,
    required this.scheduleId,
    this.isEditing = false,
  });

  final String noteId;
  final String scheduleId;
  final bool isEditing;

  @override
  State<SaveReminderList> createState() => _SaveReminderListState();
}

class _SaveReminderListState extends State<SaveReminderList> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveNoteBloc, SaveNoteState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      buildWhen: (previous, current) {
        return previous.reminders != current.reminders;
      },
      builder: (context, state) {
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
                                            onCancel: () {dialogContext.pop();},
                                            onConfirm: () {
                                              context.read<SaveNoteBloc>()
                                                  .add(RemoveOrDeleteReminderEvent(reminder.id));
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