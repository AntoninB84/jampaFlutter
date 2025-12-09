
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/extensions/schedule_extension.dart';
import 'package:jampa_flutter/utils/routers/routes.dart';

import '../../../data/models/schedule/schedule.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../../utils/enums/weekdays_enum.dart';
import '../../widgets/confirmation_dialog.dart';

/// A widget that displays a list of recurrent dates for a note,
/// allowing users to add, edit, or delete them.
///
/// Is used only inside the NoteForm screen.
class SaveRecurrentDateList extends StatefulWidget {
  const SaveRecurrentDateList({
    super.key,
    required this.noteId,
    required this.listElements,
    this.isEditing = false,
  });

  /// The ID of the note associated with the recurrent dates.
  final String noteId;

  /// The list of recurrent date entities to display.
  final List<ScheduleEntity> listElements;

  /// Indicates whether the note is being edited.
  /// Used to customize deletion confirmation messages.
  final bool isEditing;

  @override
  State<SaveRecurrentDateList> createState() => _SaveRecurrentDateListState();
}

class _SaveRecurrentDateListState extends State<SaveRecurrentDateList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: (){
              // Navigate to the RecurrentDateForm to add a new recurrent date.
              context.pushNamed(kAppRouteRecurrentDateFormName, extra: {
                'noteId': widget.noteId,
              });
            },
            child: Text(context.strings.create_note_add_recurrent_date_button)
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listElements.length,
            itemBuilder: (context, index) {
              final recurrence = widget.listElements[index];

              // Determine the display text based on the recurrence type.
              // (e.g., "Every 3 days", "Every Monday", etc.)
              String displayText = 'null';
              switch(recurrence.recurrenceType){
                case null:throw UnimplementedError();
                case .intervalDays:
                  displayText = recurrence.recurrenceType!.displayName(context,
                    value: recurrence.recurrenceInterval.toString(),
                  );break;
                case .intervalYears:
                  displayText = recurrence.recurrenceType!.displayName(context,
                    value: recurrence.recurrenceInterval.toString(),
                  ); break;
                case .dayBasedWeekly:
                  displayText = recurrence.recurrenceType!.displayName(context,
                    value: WeekdaysEnum.weekdaysString(context,
                        recurrence.recurrenceDayAsList),
                  ); break;
                case .dayBasedMonthly:
                  displayText = recurrence.recurrenceType!.displayName(context,
                    value: recurrence.recurrenceDay.toString(),
                  ); break;
              }

              return Material(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kGap4,
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(displayText),
                    onTap: (){
                      // Navigate to the RecurrentDateForm to edit the selected recurrent date.
                      context.pushNamed(kAppRouteRecurrentDateFormName, extra: {
                        'scheduleId': recurrence.id,
                        'noteId': recurrence.noteId,
                      });
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Buttons.deleteButtonIcon(
                          context: context,
                          onPressed: () {
                            showDialog(context: context, builder: (BuildContext dialogContext){
                              return ConfirmationDialog(
                                  title: context.strings.delete_recurrent_date_confirmation_title,
                                  content: context.strings.delete_recurrent_date_confirmation_message(
                                      displayText,
                                      widget.isEditing.toString()
                                  ),
                                  confirmButtonText: context.strings.delete,
                                  cancelButtonText: context.strings.cancel,
                                  onConfirm: (){
                                    // Dispatch an event to remove or delete the recurrent date.
                                    context.read<SaveNoteBloc>()
                                      .add(RemoveOrDeleteRecurrentDateEvent(
                                        recurrence.id));
                                    // Close the dialog.
                                    dialogContext.pop();
                                  },
                                  onCancel: (){
                                    // Close the dialog without taking any action.
                                    dialogContext.pop();
                                  }
                              );
                            });
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