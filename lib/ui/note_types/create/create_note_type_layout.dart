
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/ui/note_types/widgets/note_type_name_text_field.dart';

import '../../../bloc/note_types/create/create_note_type_cubit.dart';

class CreateNoteTypeLayout extends StatelessWidget {
  const CreateNoteTypeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateNoteTypeCubit, CreateNoteTypeState>(
      listener: (context, state) {
        if (state.isError) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.isSuccess) {
          SnackBarX.showSuccess(context,
              state.noteType != null ?
                context.strings.edit_note_type_success_feedback
                  : context.strings.create_note_type_success_feedback);
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
                  state.noteType != null ?
                    context.strings.edit_note_type_title
                      : context.strings.create_note_type_title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                NoteTypeNameTextField(),
                const SizedBox(height: 16),
                SubmitNoteTypeButton(),
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

class SubmitNoteTypeButton extends StatelessWidget {
  const SubmitNoteTypeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNoteTypeCubit, CreateNoteTypeState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidName && !state.existsAlready && !state.isLoading
              ? () => context.read<CreateNoteTypeCubit>().onSubmit()
              : null,
          child: state.isLoading
              ? const CupertinoActivityIndicator()
              : Text(state.noteType != null ? context.strings.edit : context.strings.create),
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

