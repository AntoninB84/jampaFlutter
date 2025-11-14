
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_content_text_field.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/notes/show/note_bloc.dart';
import '../../widgets/confirmation_dialog.dart';

class ShowNoteLayout extends StatelessWidget {
  const ShowNoteLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteState>(
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
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: (){
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back)
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigate to edit note page
                  context.pushNamed("EditNote", extra: {
                    "id": state.note?.id.toString() ?? ''
                  });
                },
              ),
              IconButton(
                  onPressed: (){
                    showDialog(context: context, builder: (BuildContext dialogContext){
                      return ConfirmationDialog(
                          title: context.strings.delete_note_confirmation_title,
                          content: context.strings.delete_note_confirmation_message(state.note?.title ?? ''),
                          confirmButtonText: context.strings.delete,
                          cancelButtonText: context.strings.cancel,
                          onConfirm: (){
                            context.read<NoteBloc>().add(DeleteNoteById(state.note?.id));
                            context.pop();
                          },
                          onCancel: (){dialogContext.pop();}
                      );
                    });
                  },
                  icon: const Icon(Icons.delete)
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(state.note?.title ?? 'No Title', style: Theme.of(context).textTheme.headlineMedium),
                 const SizedBox(height: 16),
                 NoteContentTextField(
                   value: state.noteContent,
                   onChanged: (document) {
                     context.read<NoteBloc>().add(OnChangeNoteContent(document));
                   },
                 )
               ],
            ),
          )
        );
      }
    );
  }
}