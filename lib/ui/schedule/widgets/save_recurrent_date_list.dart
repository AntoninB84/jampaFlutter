
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/bloc/notes/edit/edit_note_bloc.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../utils/constants/styles/sizes.dart';
import '../../../utils/enums/weekdays_enum.dart';
import '../../widgets/confirmation_dialog.dart';

class SaveRecurrentDateList extends StatefulWidget {
  const SaveRecurrentDateList({
    super.key,
    this.isSavingPersistentData = false,
    required this.listElements,
    required this.onDateDeleted,
  });

  final bool isSavingPersistentData;
  final List<RecurrenceFormElements> listElements;
  final Function(int) onDateDeleted;

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
              context.pushNamed(widget.isSavingPersistentData
                  ? 'SavePersistentRecurrentDate'
                  : 'SaveMemoryRecurrentDate',
              );
            },
            child: Text(context.strings.create_note_add_recurrent_date_button)
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listElements.length,
            itemBuilder: (context, index) {
              final recurrence = widget.listElements[index];
              String displayText = 'null';

              switch(recurrence.selectedRecurrenceType){
                case null:throw UnimplementedError();
                case RecurrenceType.intervalDays:
                  displayText = recurrence.selectedRecurrenceType!.displayName(context,
                    value: recurrence.selectedRecurrenceDaysInterval.toString(),
                  );break;
                case RecurrenceType.intervalYears:
                  displayText = recurrence.selectedRecurrenceType!.displayName(context,
                    value: recurrence.selectedRecurrenceYearsInterval.toString(),
                  ); break;
                case RecurrenceType.dayBasedWeekly:
                  displayText = recurrence.selectedRecurrenceType!.displayName(context,
                    value: WeekdaysEnum.weekdaysString(context,
                        recurrence.selectedRecurrenceWeekdays ?? []),
                  ); break;
                case RecurrenceType.dayBasedMonthly:
                  displayText = recurrence.selectedRecurrenceType!.displayName(context,
                    value: recurrence.selectedRecurrenceMonthDate.toString(),
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
                      context.pushNamed(widget.isSavingPersistentData
                          ? 'SavePersistentRecurrentDate'
                          : 'SaveMemoryRecurrentDate',
                          extra: {'dateIndex': index, 'scheduleId': recurrence.scheduleId}
                      );
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
                                      widget.isSavingPersistentData.toString()
                                  ),
                                  confirmButtonText: context.strings.delete,
                                  cancelButtonText: context.strings.cancel,
                                  onConfirm: (){
                                    if(widget.isSavingPersistentData) {
                                      context.read<EditNoteBloc>()
                                          .add(OnDeletePersistentSchedule(
                                          scheduleId: recurrence.scheduleId!));
                                    }else{
                                      widget.onDateDeleted(index);
                                    }
                                    dialogContext.pop();
                                  },
                                  onCancel: (){dialogContext.pop();}
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