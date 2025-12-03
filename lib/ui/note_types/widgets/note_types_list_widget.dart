import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/note_types/note_types_bloc.dart';
import 'package:jampa_flutter/data/models/note_type/note_type.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/ui/widgets/confirmation_dialog.dart';
import 'package:jampa_flutter/utils/constants/data/fake_skeleton_data.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../data/objects/note_type_with_count.dart';
import '../../../utils/enums/ui_status.dart';

/// A widget that displays a list of note types with their usage counts.
class NoteTypesListWidget extends StatefulWidget {
  const NoteTypesListWidget({super.key});

  @override
  State<NoteTypesListWidget> createState() => _NoteTypesListWidgetState();
}

class _NoteTypesListWidgetState extends State<NoteTypesListWidget> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteTypesBloc, NoteTypesState>(
        builder: (context, state) {
          switch(state.listStatus){
            case .initial:
            case .loading:
            case .success:
              // Display skeletons if loading
              List<NoteTypeWithCount> noteTypesWithCount = state.listStatus.isLoading
                  ? List.filled(3, fakeSkeletonNoteTypeWithCount)
                  : state.noteTypesWithCount;

              // Show message if no results found
              if(noteTypesWithCount.isEmpty){
                return Center(child: Text(context.strings.no_results_found));
              }

              return Skeletonizer(
                enabled: state.listStatus.isLoading,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: noteTypesWithCount.length,
                  itemBuilder: (context, index) {
                    final noteType = noteTypesWithCount[index].noteType;
                    final usageCount = noteTypesWithCount[index].noteCount;

                    return Material(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kGap4,
                        ),
                        child: ListTile(
                          title: Text(
                            noteType.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary
                            )
                          ),
                          onTap: () {
                            // Navigate to edit note type screen with note type ID
                            context.pushNamed("EditNoteType", extra: {'id': noteType.id.toString()});
                          },
                          trailing: Row(
                            mainAxisSize: .min,
                            children: [
                              Buttons.deleteButtonIcon(
                                context: context,
                                onPressed: (usageCount > 0) ? null : () {
                                  showDialog(context: context, builder: (BuildContext dialogContext){
                                    return ConfirmationDialog(
                                        title: context.strings.delete_note_type_confirmation_title,
                                        content: context.strings.delete_note_type_confirmation_message(noteType.name),
                                        confirmButtonText: context.strings.delete,
                                        cancelButtonText: context.strings.cancel,
                                        onConfirm: (){
                                          // Dispatch delete event to NoteTypesBloc
                                          context.read<NoteTypesBloc>().add(DeleteNoteType(noteType.id));
                                          // Close the dialog
                                          dialogContext.pop();
                                        },
                                        onCancel: (){
                                          // Just close the dialog
                                          dialogContext.pop();
                                        }
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            case .failure:
              return const Center(child: Text("Error loading noteTypes"));
          }
        }
    );
  }
}