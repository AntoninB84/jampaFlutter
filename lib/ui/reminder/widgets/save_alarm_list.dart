import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/form/note_form_helpers.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/ui/widgets/confirmation_dialog.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../utils/constants/styles/sizes.dart';

class SaveAlarmList extends StatefulWidget {
  const SaveAlarmList({
    super.key,
    required this.noteId,
    this.isForRecurrentDate = false,
    this.isSavingPersistentData = false,
    required this.listElements,
    required this.onDateDeleted,
  });

  final String noteId;
  final bool isForRecurrentDate;
  final bool isSavingPersistentData;
  final List<ReminderFormElements> listElements;
  final Function(int) onDateDeleted;

  @override
  State<SaveAlarmList> createState() => _SaveAlarmListState();
}

class _SaveAlarmListState extends State<SaveAlarmList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: (){
              context.pushNamed("ReminderForm", extra: {
                'scheduleId': widget.noteId,
                'isSavingPersistentData': widget.isSavingPersistentData,
              });
            },
            child: Text(context.strings.create_date_add_alarm_button)
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listElements.length,
            itemBuilder: (context, index) {

              final reminder = widget.listElements[index];
              final String displayText = context.strings
                  .alarm_display_text(
                reminder.selectedOffsetNumber,
                (index + 1),
                reminder.selectedOffsetType.getLabel(context),
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
                        'reminderId': reminder.reminderId,
                        'isSavingPersistentData': widget.isSavingPersistentData,
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
                                  title: context.strings.alarm_delete_confirmation_title,
                                  content: context.strings.alarm_delete_confirmation_message(
                                      index, widget.isSavingPersistentData.toString()
                                  ),
                                  confirmButtonText: context.strings.delete,
                                  cancelButtonText: context.strings.cancel,
                                  onCancel: () {dialogContext.pop();},
                                  onConfirm: () {
                                    if(widget.isSavingPersistentData) {
                                      if(widget.isForRecurrentDate){
                                        context.read<SaveNoteBloc>()
                                            .add(RemoveReminderEvent(reminder.reminderId));
                                      }else{
                                        context.read<SaveNoteBloc>()
                                            .add(RemoveReminderEvent(reminder.reminderId));
                                      }
                                      SnackBarX.showSuccess(context, context.strings.alarm_delete_success_feedback);

                                    }else{
                                      //Notify parent
                                      widget.onDateDeleted(index);
                                    }
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
    );
  }
}