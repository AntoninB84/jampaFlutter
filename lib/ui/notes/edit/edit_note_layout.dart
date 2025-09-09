
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/bloc/notes/edit/edit_note_bloc.dart';
import 'package:jampa_flutter/ui/schedule/widgets/save_recurrent_date_list_dialog.dart';
import 'package:jampa_flutter/ui/schedule/widgets/save_single_date_list_dialog.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_categories_multiselector.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_type_selector.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_title_text_field.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_content_text_field.dart';

import '../../widgets/cancel_button.dart';


class EditNoteLayout extends StatelessWidget {
  const EditNoteLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditNoteBloc, EditNoteState>(
      listener: (context, state) {
        if (state.isError) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.isSuccess) {
          SnackBarX.showSuccess(context, context.strings.edit_note_success_feedback);
          // Back to the previous screen after success
          context.pop();
          // Reset the state after navigating back
          context.read<EditNoteBloc>().add(OnResetState());
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
                    onChanged: (value) => context.read<EditNoteBloc>()
                      .add(OnNameChanged(value: value)),
                  ),
                  const SizedBox(height: 16),
                  NoteContentTextField(
                    isValid: state.isValidContent,
                    value: state.note?.content,
                    validator: state.content,
                    onChanged: (value) => context.read<EditNoteBloc>()
                        .add(OnContentChanged(value: value)),
                  ),
                  const SizedBox(height: 16),
                  NoteTypeSelector(
                    value: state.selectedNoteType,
                    onChanged: (value) => context.read<EditNoteBloc>()
                      .add(OnSelectedNoteTypeChanged(noteType: value)),
                  ),
                  const SizedBox(height: 16),
                  NoteCategoriesMultiSelector(
                    selectedCategories: state.selectedCategories,
                    onCategorySelected: (values) => context.read<EditNoteBloc>()
                      .add(OnSelectedCategoriesChanged(categories: values)),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<EditNoteBloc, EditNoteState>(
                    buildWhen: (previous, current) {
                      return previous.singleDates != current.singleDates;
                    },
                    builder: (context, state) {
                      return DateListButton(
                          blocContext: context,
                          elements: state.singleDates,
                      );
                    }
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<EditNoteBloc, EditNoteState>(
                    buildWhen: (previous, current) {
                      return previous.recurrentDates != current.recurrentDates;
                    },
                    builder: (context, state) {
                      return DateListButton(
                          blocContext: context,
                          elements: state.recurrentDates,
                          isRecurrence: true,
                      );
                    }
                  ),
                  const SizedBox(height: 32),
                  SubmitNoteButton(),
                  const SizedBox(height: 16),
                  CancelButton(
                    onPressed: () => context.read<EditNoteBloc>()
                        .add(OnResetState()),
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
              builder: (dialogContext) {
                if(isRecurrence){
                  return SaveRecurrentDateListDialog(
                    isSavingPersistentData: true,
                    listElements: elements as List<RecurrenceFormElements>,
                    onDateDeleted: (value) {
                      // Do nothing, as we are loading from persistent storage with a stream
                    },
                  );
                }
                return SaveSingleDateListDialog(
                  isSavingPersistentData: true,
                  listElements: elements as List<SingleDateFormElements>,
                  onDateDeleted: (value) {
                    // Do nothing, as we are loading from persistent storage with a stream
                  },
                );
              }
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
    return BlocBuilder<EditNoteBloc, EditNoteState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidTitle && !state.isLoading
              ? () => context.read<EditNoteBloc>().add(OnSubmit())
              : null,
          child: state.isLoading
              ? const CupertinoActivityIndicator()
              : Text(context.strings.edit),
        );
      },
    );
  }
}

