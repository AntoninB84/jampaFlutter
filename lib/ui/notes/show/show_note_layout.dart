
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_content_text_field.dart';
import 'package:jampa_flutter/ui/notes/widgets/lists/note_schedules_list.dart';
import 'package:jampa_flutter/ui/widgets/app_bar_config_widget.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/home/app_bar_cubit.dart';
import '../../../bloc/notes/show/show_note_bloc.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../widgets/confirmation_dialog.dart';

class ShowNoteLayout extends StatelessWidget {
  const ShowNoteLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShowNoteBloc, ShowNoteState>(
      listener: (context, state) {
        if(state.status.isFailure) {
          SnackBarX.showError(context, context.strings.generic_error_message);
          context.pop();
        }else{
          if(state.deletionSuccess) {
            SnackBarX.showSuccess(context, context.strings.delete_note_success_feedback);
            context.pop();
          } else if(state.deletionFailure) {
            SnackBarX.showError(context, context.strings.delete_note_error_message);
          }
        }
      },
      builder: (context, state) {
        return AppBarConfigWidget(
          config: AppBarConfig(
            actions: [
              Buttons.editButtonIcon(
                context: context,
                onPressed: () {
                  // Navigate to edit note page
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
                          context.read<ShowNoteBloc>().add(DeleteNoteById(state.note?.id));
                          context.pop();
                        },
                        onCancel: (){dialogContext.pop();}
                    );
                  });
                },
              )
            ]
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(state.note?.title ?? 'No Title', style: Theme.of(context).textTheme.headlineMedium),
                   const SizedBox(height: kGap16),
                   NoteContentTextField(
                     quillController: state.quillController,
                     editorMaxHeight: MediaQuery.sizeOf(context).height * 0.5,
                   ),
                   const SizedBox(height: kGap10,),
                   Padding(
                     padding: const EdgeInsets.symmetric(
                       vertical: kGap16
                     ),
                     child: Text(
                       context.strings.show_note_schedules_and_alarms,
                       style: Theme.of(context).textTheme.titleLarge,
                     ),
                   ),
                   NoteSchedulesList(schedules: state.schedulesAndAlarms)
                 ],
              ),
            )
          ),
        );
      }
    );
  }
}