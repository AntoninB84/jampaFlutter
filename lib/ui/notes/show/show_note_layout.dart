
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/notes/widgets/lists/note_schedules_list.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/enums/ui_status.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/notes/show/show_note_bloc.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/jampa_scaffolded_app_bar_widget.dart';
import '../widgets/inputs/note_content_text_field.dart';

class ShowNoteLayout extends StatelessWidget {
  const ShowNoteLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShowNoteBloc, ShowNoteState>(
      listener: (context, state) {
        if(state.status.isFailure) {
          // Handle generic failure such as loading note failure
          SnackBarX.showError(context, context.strings.generic_error_message);
          // Navigate back automatically
          context.pop();
        }else{
          // Handle deletion feedback
          if(state.noteDeletionStatus.isSuccess) {
            SnackBarX.showSuccess(context, context.strings.delete_note_success_feedback);
            context.pop();
          } else if(state.noteDeletionStatus.isFailure) {
            SnackBarX.showError(context, context.strings.delete_note_error_message);
          }
        }
      },
      builder: (context, state) {
        return JampaScaffoldedAppBarWidget(
          actions: [
            Buttons.editButtonIcon(
              context: context,
              onPressed: () {
                // Navigate to edit note page with note ID
                context.pushNamed("NoteForm", extra: {
                  "noteId": state.note?.id.toString() ?? ''
                });
              },
            ),
            Buttons.deleteButtonIcon(
              context: context,
              onPressed: (){
                showDialog(context: context, builder: (BuildContext dialogContext){
                  return ConfirmationDialog(
                      title: context.strings.delete_note_confirmation_title,
                      content: context.strings.delete_note_confirmation_message(state.note?.title ?? ''),
                      confirmButtonText: context.strings.delete,
                      cancelButtonText: context.strings.cancel,
                      onConfirm: (){
                        // Trigger note deletion in the bloc
                        context.read<ShowNoteBloc>().add(DeleteNoteById(state.note?.id));
                        // Close the dialog
                        context.pop();
                      },
                      onCancel: (){
                        // Just close the dialog
                        dialogContext.pop();
                      }
                  );
                });
              },
            )
          ],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                // Note title
                Text(state.note?.title ?? 'No Title', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: kGap16),

                // Note content quill editor
                NoteContentTextField(
                  quillController: state.quillController,
                  editorMaxHeight: MediaQuery.sizeOf(context).height * 0.5,
                ),
                const SizedBox(height: kGap10,),

                // Schedules and Reminders Section Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: kGap16
                  ),
                  child: Text(
                    context.strings.show_note_schedules_and_reminders,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                // List of schedules and reminders
                NoteSchedulesList(schedules: state.schedulesAndReminders)
              ],
            ),
          )
        );
      }
    );
  }
}