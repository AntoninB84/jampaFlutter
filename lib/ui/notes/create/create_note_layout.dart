
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/schedule/widgets/save_recurrent_date_list_dialog.dart';
import 'package:jampa_flutter/ui/schedule/widgets/save_single_date_list_dialog.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_categories_multiselector.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_type_selector.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_title_text_field.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_content_text_field.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';

import '../../../bloc/notes/create/create_note_form_helpers.dart';
import '../../../utils/constants/styles/sizes.dart';
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
          SnackBarX.showSuccess(context, context.strings.create_note_success_feedback);
          // Back to the previous screen after success
          context.pop();
          // Reset the state after navigating back
          context.read<CreateNoteCubit>().resetState();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Headers.basicHeader(
                  context: context,
                  title: context.strings.create_note_title,
                  onBackPressed: (){
                    context.pop();
                    context.read<CreateNoteCubit>().resetState();
                  }
                ),
                const SizedBox(height: kGap16),
                NoteTitleTextField(
                  isValid: state.isValidTitle,
                  validator: state.title,
                  onChanged: context.read<CreateNoteCubit>().onNameChanged,
                ),
                const SizedBox(height: kGap16),
                NoteContentTextField(
                  isValid: state.isValidContent,
                  validator: state.content,
                  onChanged: context.read<CreateNoteCubit>().onContentChanged,
                ),
                const SizedBox(height: kGap16),
                NoteTypeSelector(
                  value: state.selectedNoteType,
                  onChanged: context.read<CreateNoteCubit>()
                      .onSelectedNoteTypeChanged,
                ),
                const SizedBox(height: kGap16),
                NoteCategoriesMultiSelector(
                  selectedCategories: state.selectedCategories,
                  onCategorySelected: context.read<CreateNoteCubit>()
                      .onSelectedCategoriesChanged
                ),
                const SizedBox(height: kGap16),
                DateListButton(
                    blocContext: context,
                    elements: state.selectedSingleDateElements,
                ),
                const SizedBox(height: kGap16),
                DateListButton(
                    blocContext: context,
                    elements: state.selectedRecurrences,
                    isRecurrence: true,
                ),
                const SizedBox(height: kGap32),
                SubmitNoteButton(),
              ],
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
                    listElements: elements as List<RecurrenceFormElements>,
                    onDateDeleted: (value) {
                      blocContext.read<CreateNoteCubit>().onRemoveRecurrenceElement(value);                  },
                  );
                }
                return SaveSingleDateListDialog(
                  listElements: elements as List<SingleDateFormElements>,
                  onDateDeleted: (value) {
                    blocContext.read<CreateNoteCubit>().onRemoveSingleDateElement(value);                  },
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
    return BlocBuilder<CreateNoteCubit, CreateNoteState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidTitle && !state.isLoading
              ? () => context.read<CreateNoteCubit>().onSubmit()
              : null,
          child: state.isLoading
              ? const CupertinoActivityIndicator()
              : Text(context.strings.create),
        );
      },
    );
  }
}

