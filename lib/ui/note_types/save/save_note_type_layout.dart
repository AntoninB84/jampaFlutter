import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/note_types/widgets/note_type_name_text_field.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/ui/widgets/jampa_scaffolded_app_bar_widget.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/enums/ui_status.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/note_types/save/save_note_type_cubit.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../widgets/buttons/buttons.dart';

class SaveNoteTypeLayout extends StatelessWidget {
  const SaveNoteTypeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveNoteTypeCubit, SaveNoteTypeState>(
      listener: (context, state) {
        if (state.saveNoteTypeStatus.isFailure) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.saveNoteTypeStatus.isSuccess) {
          SnackBarX.showSuccess(
            context,
            state.noteType != null
                ? context.strings.edit_note_type_success_feedback
                : context.strings.create_note_type_success_feedback,
          );
          // Back to the previous screen after success
          context.pop();
        }
      },
      builder: (context, state) {
        return JampaScaffoldedAppBarWidget(
          actions: [
            Buttons.saveButtonIcon(
              context: context,
              onPressed: state.isValidName && !state.existsAlready && !state.saveNoteTypeStatus.isLoading
                  ? () => context.read<SaveNoteTypeCubit>().onSubmit()
                  : null,
            )
          ],
          body: Column(
            crossAxisAlignment: .start,
            children: [
              Headers.basicHeader(
                context: context,
                title: state.noteType != null
                    ? context.strings.edit_note_type_title
                    : context.strings.create_note_type_title,
              ),
              const SizedBox(height: kGap16),
              NoteTypeNameTextField(),
              const SizedBox(height: kGap16),
            ],
          ),
        );
      },
    );
  }
}
