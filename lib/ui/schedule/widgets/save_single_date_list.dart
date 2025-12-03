
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/form/note_form_helpers.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';

import '../../../data/models/schedule/schedule.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../widgets/confirmation_dialog.dart';

/// A widget that displays a list of single date schedule elements
/// and allows adding, editing, and deleting them.
///
/// Is only used inside the NoteForm screen.
class SaveSingleDateList extends StatefulWidget {
  const SaveSingleDateList({
    super.key,
    required this.noteId,
    required this.listElements,
    this.isEditing = false,
  });

  /// The ID of the note to which the schedule elements belong.
  final String noteId;

  /// The list of single date schedule elements to display.
  final List<ScheduleEntity> listElements;

  /// Indicates whether the note is being edited.
  /// Used in deletion confirmation dialogs.
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
              // Navigate to the SingleDateForm to add a new single date schedule element.
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

              // Format the display text for the schedule element.
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
                      // Navigate to the SingleDateForm to edit the selected single date schedule element.
                      context.pushNamed('SingleDateForm', extra: {
                        'scheduleId': date.id,
                        'noteId': date.noteId,
                      });
                    },
                    trailing: Row(
                      mainAxisSize: .min,
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
                                    // Dispatch an event to remove or delete the selected single date schedule element.
                                    context.read<SaveNoteBloc>()
                                      .add(RemoveOrDeleteSingleDateEvent(
                                        date.id));
                                    // Close the dialog.
                                    dialogContext.pop();
                                  },
                                  onCancel: (){
                                    // Close the dialog without making any changes.
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