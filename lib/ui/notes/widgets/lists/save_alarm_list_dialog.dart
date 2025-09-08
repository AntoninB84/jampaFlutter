import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/ui/widgets/confirmation_dialog.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../../bloc/alarm/save_alarm_list/save_alarm_list_bloc.dart';

class SaveAlarmListDialog extends StatefulWidget {
  const SaveAlarmListDialog({
    super.key,
    this.isSavingPersistentData = false,
    required this.listElements,
    required this.onDateDeleted,
  });

  final bool isSavingPersistentData;
  final List<AlarmFormElements> listElements;
  final Function(int) onDateDeleted;

  @override
  State<SaveAlarmListDialog> createState() => _SaveAlarmListDialogState();
}

class _SaveAlarmListDialogState extends State<SaveAlarmListDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaveAlarmListBloc>(
      create: (context) => SaveAlarmListBloc()
        ..add(InitializeSaveAlarmListFromMemoryState(
            alarmElements: widget.listElements
        )
      ),
      child: BlocConsumer<SaveAlarmListBloc, SaveAlarmListState>(
        listener: (context, state){
          if(widget.isSavingPersistentData){
            // Show that delete was successful
            SnackBarX.showSuccess(context, context.strings.alarm_delete_success_feedback);
          }
        },
        listenWhen: (previous, current){
          return previous.alarmElements.length > current.alarmElements.length;
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
                      itemCount: state.alarmElements.length,
                      itemBuilder: (context, index) {

                        final alarm = state.alarmElements[index];
                        final String displayText = context.strings
                          .alarm_display_text(
                            alarm.selectedOffsetNumber,
                            (index + 1),
                            alarm.selectedOffsetType.getLabel(context),
                        );

                        return ListTile(
                          title: Text(displayText),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  context.pop(index);
                                  context.pushNamed(widget.isSavingPersistentData
                                      ? 'SavePersistentAlarm'
                                      : 'SaveMemoryAlarm',
                                      extra: {'alarmIndex': index}
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
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
                                          context.read<SaveAlarmListBloc>()
                                              .add(DeletePersistentAlarm(id: alarm.alarmId!));
                                        }else{
                                          //Remove from state
                                          context.read<SaveAlarmListBloc>()
                                              .add(RemoveAlarmFromMemoryList(index: index));
                                          //Notify CreateNoteCubit
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
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        context.pop();
                        context.pushNamed(widget.isSavingPersistentData
                            ? 'SavePersistentAlarm'
                            : 'SaveMemoryAlarm',
                        );
                      },
                      child: Text(context.strings.create_date_add_alarm_button)
                  )
                ],
              ),
            ),
          );
        },
      )
    );
  }
}