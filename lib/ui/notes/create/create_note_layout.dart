
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_categories_multiselector.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_type_selector.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_title_text_field.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_content_text_field.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';


class CreateNoteLayout extends StatelessWidget {
  const CreateNoteLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateNoteCubit, CreateNoteState>(
      listener: (context, state) {
        if (state.isError) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.isSuccess) {
          SnackBarX.showSuccess(context,
              state.note != null ?
                context.strings.edit_note_success_feedback
                  : context.strings.create_note_success_feedback);
          // Back to the previous screen after success
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  state.note != null ?
                    context.strings.edit_note_title
                      : context.strings.create_note_title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                NoteTitleTextField(),
                const SizedBox(height: 16),
                NoteContentTextField(),
                const SizedBox(height: 16),
                NoteTypeSelector(),
                const SizedBox(height: 16),
                NoteCategoriesMultiSelector(),
                const SizedBox(height: 32),
                SubmitNoteButton(),
                const SizedBox(height: 16),
                CancelButton(),
              ],
            ),
          ),
        );
      }
    );
  }
}

class SubmitNoteButton extends StatelessWidget {
  const SubmitNoteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNoteCubit, CreateNoteState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidTitle && !state.isLoading
              ? () => context.read<CreateNoteCubit>().onSubmit()
              : null,
          child: state.isLoading
              ? const CupertinoActivityIndicator()
              : Text(state.note != null ? context.strings.edit : context.strings.create),
        );
      },
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.pop(),
      child: Text(context.strings.cancel),
    );
  }
}

