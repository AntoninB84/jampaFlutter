
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/bloc/schedule/save_recurrent_date_list/save_recurrent_date_list_bloc.dart';
import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../utils/enums/weekdays_enum.dart';
import '../../widgets/confirmation_dialog.dart';

class SaveRecurrentDateListDialog extends StatefulWidget {
  const SaveRecurrentDateListDialog({
    super.key,
    this.isSavingPersistentData = false,
    required this.listElements,
    required this.onDateDeleted,
  });

  final bool isSavingPersistentData;
  final List<RecurrenceFormElements> listElements;
  final Function(int) onDateDeleted;

  @override
  State<SaveRecurrentDateListDialog> createState() => _SaveRecurrentDateListDialogState();
}

class _SaveRecurrentDateListDialogState extends State<SaveRecurrentDateListDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaveRecurrentDateListBloc>(
      create: (context) => SaveRecurrentDateListBloc()
        ..add(InitializeSaveRecurrentDateListFromMemoryState(
            recurrentDateElements: widget.listElements
        )
      ),
      child: BlocConsumer<SaveRecurrentDateListBloc, SaveRecurrentDateListState>(
        listener: (context, state){
          
        },
        builder: (context, state) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.recurrentDateElements.length,
                      itemBuilder: (context, index) {
                        final recurrence = state.recurrentDateElements[index];
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
          
                        return ListTile(
                          title: Text(displayText),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  context.pop();
                                  context.pushNamed(widget.isSavingPersistentData
                                      ? 'SavePersistentRecurrentDate'
                                      : 'SaveMemoryRecurrentDate',
                                    extra: {'dateIndex': index}
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
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
                                            context.read<SaveRecurrentDateListBloc>()
                                                .add(DeletePersistentRecurrentDate(id: recurrence.scheduleId!));
                                          }else{
                                            //Remove from state
                                            context.read<SaveRecurrentDateListBloc>()
                                                .add(RemoveRecurrentDateFromMemoryList(index: index));
                                            //Notify CreateNoteCubit
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
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      context.pop();
                      context.pushNamed(widget.isSavingPersistentData
                          ? 'SavePersistentRecurrentDate'
                          : 'SaveMemoryRecurrentDate',
                      );
                    },
                    child: Text(context.strings.create_note_add_recurrent_date_button)
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}