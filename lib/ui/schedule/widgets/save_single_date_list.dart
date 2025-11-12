
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/notes/edit/edit_note_bloc.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../widgets/confirmation_dialog.dart';

class SaveSingleDateList extends StatefulWidget {
  const SaveSingleDateList({
    super.key,
    this.isSavingPersistentData = false,
    required this.listElements,
    required this.onDateDeleted,
  });

  final bool isSavingPersistentData;
  final List<SingleDateFormElements> listElements;
  final Function(int) onDateDeleted;

  @override
  State<SaveSingleDateList> createState() => _SaveSingleDateListState();
}

class _SaveSingleDateListState extends State<SaveSingleDateList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: (){
              context.pushNamed(widget.isSavingPersistentData
                  ? 'SavePersistentSingleDate'
                  : 'SaveMemorySingleDate',
              );
            },
            child: Text(context.strings.create_note_add_single_date_button)
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listElements.length,
            itemBuilder: (context, index) {
              final date = widget.listElements[index];
              final String displayText = date.selectedStartDateTime != null
                  ? date.selectedStartDateTime!.toLocal().toString()
                  : 'null';

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
                          ? 'SavePersistentSingleDate'
                          : 'SaveMemorySingleDate',
                          extra: {'dateIndex': index, 'scheduleId': date.scheduleId}
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            showDialog(context: context, builder: (BuildContext dialogContext){
                              return ConfirmationDialog(
                                  title: context.strings.delete_single_date_confirmation_title,
                                  content: context.strings.delete_single_date_confirmation_message(
                                      displayText,
                                      widget.isSavingPersistentData.toString()
                                  ),
                                  confirmButtonText: context.strings.delete,
                                  cancelButtonText: context.strings.cancel,
                                  onConfirm: (){
                                    if(widget.isSavingPersistentData) {
                                      context.read<EditNoteBloc>()
                                          .add(OnDeletePersistentSchedule(
                                          scheduleId: date.scheduleId!));
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