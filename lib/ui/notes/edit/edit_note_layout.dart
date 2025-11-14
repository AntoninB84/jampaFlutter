
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/edit/edit_note_bloc.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_categories_multiselector.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_type_selector.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_title_text_field.dart';
import 'package:jampa_flutter/ui/notes/widgets/inputs/note_content_text_field.dart';

import '../../../utils/constants/styles/sizes.dart';
import '../widgets/schedules_tab_view.dart';


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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Headers.basicHeader(
                  context: context,
                  title: context.strings.edit_note_title,
                  onBackPressed: (){
                    context.pop();
                    context.read<EditNoteBloc>().add(OnResetState());
                  }
                ),
                const SizedBox(height: kGap16),
                NoteTitleTextField(
                  isValid: state.isValidTitle,
                  value: state.note?.title,
                  validator: state.title,
                  onChanged: (value) => context.read<EditNoteBloc>()
                    .add(OnNameChanged(value: value)),
                ),
                const SizedBox(height: kGap16),
                NoteContentTextField(
                  value: state.content,
                  onChanged: (value) => context.read<EditNoteBloc>()
                      .add(OnContentChanged(value: value)),
                ),
                const SizedBox(height: kGap16),
                NoteTypeSelector(
                  value: state.selectedNoteType,
                  onChanged: (value) => context.read<EditNoteBloc>()
                    .add(OnSelectedNoteTypeChanged(noteType: value)),
                ),
                const SizedBox(height: kGap16),
                NoteCategoriesMultiSelector(
                  selectedCategories: state.selectedCategories,
                  onCategorySelected: (values) => context.read<EditNoteBloc>()
                    .add(OnSelectedCategoriesChanged(categories: values)),
                ),
                const SizedBox(height: kGap8),
                BlocBuilder<EditNoteBloc, EditNoteState>(
                  buildWhen: (previous, current) {
                    return (previous.singleDates != current.singleDates)
                    || (previous.recurrentDates != current.recurrentDates);
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        SchedulesTabView(
                          isSavingPersistentData: true,
                          recurrenceListElements: state.recurrentDates,
                          singleDateListElements: state.singleDates,
                          onSingleDateDeleted: (value) {
                            //Do nothing
                          },
                          onRecurrentDateDeleted: (value) {
                            //Do nothing
                          },
                        ),
                      ],
                    );
                  }
                ),
                const SizedBox(height: kGap8),
                SubmitNoteButton(),
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

