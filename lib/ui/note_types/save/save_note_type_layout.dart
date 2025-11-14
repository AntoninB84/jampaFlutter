
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/note_types/widgets/note_type_name_text_field.dart';
import 'package:jampa_flutter/ui/widgets/app_bar_config_widget.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/home/app_bar_cubit.dart';
import '../../../bloc/note_types/save/save_note_type_cubit.dart';
import '../../../utils/constants/styles/sizes.dart';

class SaveNoteTypeLayout extends StatelessWidget {
  const SaveNoteTypeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarConfigWidget(
      config: AppBarConfig(),
      child: BlocConsumer<SaveNoteTypeCubit, SaveNoteTypeState>(
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Headers.basicHeader(
                  context: context,
                  title: state.noteType != null ?
                  context.strings.edit_note_type_title
                      : context.strings.create_note_type_title,
                ),
                const SizedBox(height: kGap16),
                NoteTypeNameTextField(),
                const SizedBox(height: kGap16),
                Row(
                  children: [
                    SubmitNoteTypeButton(),
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class SubmitNoteTypeButton extends StatelessWidget {
  const SubmitNoteTypeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveNoteTypeCubit, SaveNoteTypeState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidName && !state.existsAlready && !state.isLoading
              ? () => context.read<SaveNoteTypeCubit>().onSubmit()
              : null,
          child: state.isLoading
              ? const CupertinoActivityIndicator()
              : Text(
                  state.noteType != null ? context.strings.edit : context.strings.create,
                ),
        );
      },
    );
  }
}

