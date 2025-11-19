import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/home/app_bar_cubit.dart';
import '../../../bloc/notes/form/note_form_bloc.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../widgets/app_bar_config_widget.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/headers.dart';
import '../../widgets/snackbar.dart';
import '../widgets/inputs/note_categories_multiselector.dart';
import '../widgets/inputs/note_content_text_field.dart';
import '../widgets/inputs/note_title_text_field.dart';
import '../widgets/inputs/note_type_selector.dart';

class NoteFormLayout extends StatelessWidget {
  const NoteFormLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveNoteBloc, SaveNoteState>(
      listener: (context, state) {
        if (state.noteSavingStatus.isFailure) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.noteSavingStatus.isSuccess) {
          SnackBarX.showSuccess(context, context.strings.save_note_success_feedback);
          // Back to the previous screen after success
          context.pop();
          context.read<SaveNoteBloc>().add(CleanStateEvent());
        }
      },
      listenWhen: (previous, current) {
        return previous.noteSavingStatus != current.noteSavingStatus;
      },
      child: BlocBuilder<NoteFormBloc, NoteFormState>(
        builder: (context, state) {
          return AppBarConfigWidget(
            config: AppBarConfig(
              leading: Buttons.backButtonIcon(
                context: context,
                onPressed: (){
                  context.pop();
                  context.read<SaveNoteBloc>().add(CleanStateEvent());
                }
              ),
              actions: [
                Buttons.saveButtonIcon(
                  context: context,
                  onPressed: state.isValidTitle && !state.status.isLoading
                      ? () => context.read<NoteFormBloc>().add(SaveNoteFormEvent())
                      : null,
                )
              ]
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Headers.basicHeader(
                      context: context,
                      title: state.isSavingPersistentData
                          ? context.strings.edit_note_title
                          : context.strings.create_note_title,
                    ),
                    const SizedBox(height: kGap16),
                    NoteTitleTextField(
                      isValid: state.isValidTitle,
                      value: state.title.value,
                      validator: state.title,
                      onChanged: (value) => context.read<NoteFormBloc>()
                          .add(TitleChangedEvent(title: value)),
                    ),
                    const SizedBox(height: kGap16),
                    NoteContentTextField(
                      value: state.content,
                      editorMaxHeight: MediaQuery.sizeOf(context).height * 0.3,
                      onChanged: (value) => context.read<NoteFormBloc>()
                          .add(ContentChangedEvent(content: value)),
                    ),
                    const SizedBox(height: kGap16),
                    NoteTypeSelector(
                      value: state.selectedNoteType,
                      onChanged: (value) => context.read<NoteFormBloc>()
                          .add(SelectedNoteTypeChangedEvent(noteType: value)),
                    ),
                    const SizedBox(height: kGap16),
                    NoteCategoriesMultiSelector(
                      selectedCategories: state.selectedCategories,
                      onCategorySelected: (values) => context.read<NoteFormBloc>()
                          .add(SelectedCategoriesChangedEvent(categories: values)),
                    ),
                    const SizedBox(height: kGap8),
                    BlocBuilder<SaveNoteBloc, SaveNoteState>(
                        buildWhen: (previous, current) {
                          return (previous.singleDateSchedules != current.singleDateSchedules)
                              || (previous.recurrentSchedules != current.recurrentSchedules);
                        },
                        builder: (context, state) {
                          return Column(
                            children: [
                              // SchedulesTabView(
                              //   isSavingPersistentData: true,
                              //   recurrenceListElements: state.re,
                              //   singleDateListElements: state.singleDates,
                              //   onSingleDateDeleted: (value) {
                              //     //Do nothing
                              //   },
                              //   onRecurrentDateDeleted: (value) {
                              //     //Do nothing
                              //   },
                              // ),
                            ],
                          );
                        }
                    ),
                    const SizedBox(height: kGap32),
                  ],
                ),
              ),
            )
          );
        },
      )
    );
  }
}
