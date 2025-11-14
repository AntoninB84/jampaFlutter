import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/bloc/schedule/save_recurrent_date/save_recurrent_date_bloc.dart';
import 'package:jampa_flutter/bloc/schedule/save_single_date/save_single_date_bloc.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/ui/widgets/confirmation_dialog.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../utils/constants/styles/sizes.dart';

class SaveAlarmList extends StatefulWidget {
  const SaveAlarmList({
    super.key,
    this.isForRecurrentDate = false,
    this.isSavingPersistentData = false,
    required this.listElements,
    required this.onDateDeleted,
  });

  final bool isForRecurrentDate;
  final bool isSavingPersistentData;
  final List<AlarmFormElements> listElements;
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
              context.pushNamed(widget.isSavingPersistentData
                  ? (widget.isForRecurrentDate ? 'SavePersistentAlarmForRecurrentDate' : 'SavePersistentAlarmForSingleDate')
                  : (widget.isForRecurrentDate ? 'SaveMemoryAlarmForRecurrentDate' : 'SaveMemoryAlarmForSingleDate'),
              );
            },
            child: Text(context.strings.create_date_add_alarm_button)
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listElements.length,
            itemBuilder: (context, index) {

              final alarm = widget.listElements[index];
              final String displayText = context.strings
                  .alarm_display_text(
                alarm.selectedOffsetNumber,
                (index + 1),
                alarm.selectedOffsetType.getLabel(context),
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
                      context.pushNamed(widget.isSavingPersistentData
                          ? (widget.isForRecurrentDate ? 'SavePersistentAlarmForRecurrentDate' : 'SavePersistentAlarmForSingleDate')
                          : (widget.isForRecurrentDate ? 'SaveMemoryAlarmForRecurrentDate' : 'SaveMemoryAlarmForSingleDate'),
                          extra: {'alarmIndex': index}
                      );
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
                                        context.read<SaveRecurrentDateBloc>()
                                            .add(DeletePersistentAlarmFromRecurrence(alarmId: alarm.alarmId!));
                                      }else{
                                        context.read<SaveSingleDateBloc>()
                                            .add(DeletePersistentAlarmFromSingleDate(alarmId: alarm.alarmId!));
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