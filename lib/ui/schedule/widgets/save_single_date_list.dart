
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/form/note_form_helpers.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';

import '../../../data/models/schedule.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../widgets/confirmation_dialog.dart';

class SaveSingleDateList extends StatefulWidget {
  const SaveSingleDateList({
    super.key,
    required this.noteId,
    required this.listElements,
    this.isEditing = false,
  });

  final String noteId;
  final List<ScheduleEntity> listElements;
  final bool isEditing;

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
              context.pushNamed('SingleDateForm', extra: {
                'noteId': widget.noteId,
              });
            },
            child: Text(context.strings.create_note_add_single_date_button)
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listElements.length,
            itemBuilder: (context, index) {
              final date = widget.listElements[index];
              final String displayText = date.startDateTime != null
                  ? date.startDateTime!.toFullFormat(context)
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
                      context.pushNamed('SingleDateForm', extra: {
                        'scheduleId': date.id,
                        'noteId': date.noteId,
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
                                  title: context.strings.delete_single_date_confirmation_title,
                                  content: context.strings.delete_single_date_confirmation_message(
                                      displayText,
                                      widget.isEditing.toString()
                                  ),
                                  confirmButtonText: context.strings.delete,
                                  cancelButtonText: context.strings.cancel,
                                  onConfirm: (){
                                    context.read<SaveNoteBloc>()
                                      .add(RemoveOrDeleteSingleDateEvent(
                                        date.id));
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