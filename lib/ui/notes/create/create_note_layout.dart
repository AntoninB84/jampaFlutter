
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/notes/widgets/single_date_list_dialog.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_categories_multiselector.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_type_selector.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_title_text_field.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_content_text_field.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';

import '../../widgets/cancel_button.dart';


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
          // Reset the state after navigating back
          context.read<CreateNoteCubit>().resetState();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
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
                  const SizedBox(height: 16),
                  DateListButton(
                      blocContext: context,
                      elements: state.selectedSingleDateElements,
                  ),
                  const SizedBox(height: 16),
                  DateListButton(
                      blocContext: context,
                      elements: state.selectedRecurrences,
                      isRecurrence: true,
                  ),
                  const SizedBox(height: 32),
                  SubmitNoteButton(),
                  const SizedBox(height: 16),
                  CancelButton(),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class DateListButton extends StatelessWidget {
  const DateListButton({super.key,
    required this.blocContext,
    required this.elements,
    this.isRecurrence = false
  });

  final BuildContext blocContext;
  final List elements;
  final bool isRecurrence;

  @override
  Widget build(BuildContext listContext) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )
          )
        ),
        onPressed: () {
          showDialog(
              context: listContext,
              builder: (dialogContext) => SingleDateListDialog(
                fromMemory: true,
                onDateDeleted: (value){
                  blocContext.read<CreateNoteCubit>().onRemoveSingleDateElement(value);
                },
              )
          );
        },
        child: Text(
          isRecurrence ? listContext.strings.create_note_recurrent_date_count(elements.length)
              : listContext.strings.create_note_single_date_count(elements.length)
        ),
      ),
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

