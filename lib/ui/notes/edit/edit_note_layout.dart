
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/edit/edit_note_cubit.dart';
import 'package:jampa_flutter/ui/notes/widgets/single_date_list_dialog.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_categories_multiselector.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_type_selector.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_title_text_field.dart';
import 'package:jampa_flutter/ui/notes/widgets/note_content_text_field.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';

import '../../widgets/cancel_button.dart';


class EditNoteLayout extends StatelessWidget {
  const EditNoteLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditNoteCubit, EditNoteState>(
      listener: (context, state) {
        if (state.isError) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.isSuccess) {
          SnackBarX.showSuccess(context, context.strings.edit_note_success_feedback);
          // Back to the previous screen after success
          context.pop();
          // Reset the state after navigating back
          context.read<EditNoteCubit>().resetState();
        }
      },
      buildWhen: (previous, current) {
        // Rebuild only when selected categories or dates change
        return (previous.note != current.note) && (current.note != null);
      },
      builder: (context, state) {
        if(state.note == null){
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator()
            ),
          );
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    context.strings.edit_note_title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  NoteTitleTextField(
                    isValid: state.isValidTitle,
                    value: state.note?.title,
                    validator: state.title,
                    onChanged: context.read<EditNoteCubit>().onNameChanged,
                  ),
                  const SizedBox(height: 16),
                  NoteContentTextField(
                    isValid: state.isValidContent,
                    value: state.note?.content,
                    validator: state.content,
                    onChanged: context.read<EditNoteCubit>().onContentChanged,
                  ),
                  const SizedBox(height: 16),
                  NoteTypeSelector(
                    value: state.selectedNoteType,
                    onChanged: (value) => context.read<EditNoteCubit>()
                      ..onSelectedNoteTypeChanged(value),
                  ),
                  const SizedBox(height: 16),
                  NoteCategoriesMultiSelector(
                    selectedCategories: state.selectedCategories,
                    onCategorySelected: (values) => context.read<EditNoteCubit>()
                      ..onSelectedCategoriesChanged(values),
                  ),
                  const SizedBox(height: 16),
                  // DateListButton(
                  //     blocContext: context,
                  //     elements: state.selectedSingleDateElements,
                  // ),
                  // const SizedBox(height: 16),
                  // DateListButton(
                  //     blocContext: context,
                  //     elements: state.selectedRecurrences,
                  //     isRecurrence: true,
                  // ),
                  // const SizedBox(height: 32),
                  SubmitNoteButton(),
                  const SizedBox(height: 16),
                  CancelButton(
                    onPressed: () => context.read<EditNoteCubit>().resetState(),
                  ),
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
                  // blocContext.read<EditNoteCubit>().onRemoveSingleDateElement(value);
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
    return BlocBuilder<EditNoteCubit, EditNoteState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidTitle && !state.isLoading
              ? () => context.read<EditNoteCubit>().onSubmit()
              : null,
          child: state.isLoading
              ? const CupertinoActivityIndicator()
              : Text(context.strings.edit),
        );
      },
    );
  }
}

