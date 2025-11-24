import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/notes/form/note_form_bloc.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/headers.dart';
import '../../widgets/jampa_scaffolded_app_bar_widget.dart';
import '../../widgets/snackbar.dart';
import '../widgets/inputs/note_categories_multiselector.dart';
import '../widgets/inputs/note_content_text_field.dart';
import '../widgets/inputs/note_title_text_field.dart';
import '../widgets/inputs/note_type_selector.dart';
import '../widgets/schedules_tab_view.dart';

class NoteFormLayout extends StatelessWidget {
  const NoteFormLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveNoteBloc, SaveNoteState>(
      listener: (context, dataState) {
        if(!dataState.isSavingInProgress){
          // Do not show anything while saving is in progress
          // This is to prevent the reset of the State before handling the saving
          // of Schedules and Reminders associated to the Note in the SaveNoteBloc
          if (dataState.noteSavingStatus.isFailure) {
            SnackBarX.showError(context, context.strings.generic_error_message);
          } else if (dataState.noteSavingStatus.isSuccessful) {
            SnackBarX.showSuccess(context, context.strings.save_note_success_feedback);
            // Back to the previous screen after success
            context.pop();
            // Clean the SaveNoteBloc state
            context.read<SaveNoteBloc>().add(CleanStateEvent());
          }
        }
      },
      listenWhen: (previous, current) {
        return previous.noteSavingStatus != current.noteSavingStatus;
      },
      child: BlocBuilder<NoteFormBloc, NoteFormState>(
        builder: (context, state) {
          return JampaScaffoldedAppBarWidget(
              leading: Buttons.backButtonIcon(
                  context: context,
                  onPressed: (){
                    // Back to the previous screen
                    context.pop();
                    // Clean the SaveNoteBloc state
                    context.read<SaveNoteBloc>().add(CleanStateEvent());
                  }
              ),
              actions: [
                Buttons.saveButtonIcon(
                  context: context,
                  onPressed: state.canSubmitForm
                      ? () => context.read<NoteFormBloc>().add(SaveNoteFormEvent())
                      : null,
                )
              ],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Headers.basicHeader(
                    context: context,
                    title: state.isEditing
                        ? context.strings.edit_note_title
                        : context.strings.create_note_title,
                  ),
                  const SizedBox(height: kGap16),
                  // Title Text Field
                  NoteTitleTextField(
                    value: state.title.value,
                    validator: state.title,
                    onChanged: (value) => context.read<NoteFormBloc>()
                        .add(TitleChangedEvent(title: value)),
                  ),
                  const SizedBox(height: kGap16),
                  // Quill Editor for Note Content
                  NoteContentTextField(
                    quillController: state.quillController,
                    editorMaxHeight: MediaQuery.sizeOf(context).height * 0.3,
                  ),
                  const SizedBox(height: kGap16),
                  // Note Type Dropdown Selector
                  NoteTypeSelector(
                    value: state.selectedNoteType,
                    onChanged: (value) => context.read<NoteFormBloc>()
                        .add(SelectedNoteTypeChangedEvent(noteType: value)),
                  ),
                  const SizedBox(height: kGap16),
                  // Note Categories Multi Selector
                  NoteCategoriesMultiSelector(
                    selectedCategories: state.selectedCategories,
                    onCategorySelected: (values) => context.read<NoteFormBloc>()
                        .add(SelectedCategoriesChangedEvent(categories: values)),
                  ),
                  const SizedBox(height: kGap8),
                  // Single Dates and Recurring Schedules Tab View
                  SchedulesTabView(
                    noteId: state.noteId,
                    isEditing: state.isEditing,
                  ),
                  const SizedBox(height: kGap32),
                ],
              ),
            ),
          );
        },
      )
    );
  }
}
