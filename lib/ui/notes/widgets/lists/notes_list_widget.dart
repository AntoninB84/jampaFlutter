import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/list_view/notes_list_view_bloc.dart';
import 'package:jampa_flutter/bloc/notes/show/show_note_bloc.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/enums/ui_status.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../utils/constants/data/fake_skeleton_data.dart';
import '../../../widgets/snackbar.dart';

/// Widget displaying a list of notes with loading skeletons and error handling.
class NotesListWidget extends StatefulWidget {
  const NotesListWidget({super.key});

  @override
  State<NotesListWidget> createState() => _NotesListWidgetState();
}

class _NotesListWidgetState extends State<NotesListWidget> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShowNoteBloc, ShowNoteState>(
      listener: (context, showNoteState) {
        if(showNoteState.status.isFailure) {
          // Handle generic failure such as loading note failure
          SnackBarX.showError(context, context.strings.generic_error_message);
        }else{
          // Handle deletion feedback
          if(showNoteState.noteDeletionStatus.isSuccess) {
            SnackBarX.showSuccess(context, context.strings.delete_note_success_feedback);
          } else if(showNoteState.noteDeletionStatus.isFailure) {
            SnackBarX.showError(context, context.strings.delete_note_error_message);
          }
        }
      },
      builder: (context, showNoteState){
        return BlocBuilder<NotesListViewBloc, NotesListViewState>(
            builder: (context, state) {
              switch(state.listStatus){
                case .initial:
                case .loading:
                case .success:
                // Show loading skeletons if loading, else show actual notes
                  List<NoteListViewData> notes = state.listStatus.isLoading ?
                  List.filled(3, fakeSkeletonNoteListViewData) : state.notes;

                  // Show message if no notes found
                  if(notes.isEmpty){
                    return Center(child: Text(context.strings.no_results_found));
                  }

                  return Skeletonizer(
                    enabled: state.listStatus.isLoading,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: notes.length,
                      // Add cache extent to pre-render items and improve scrolling
                      cacheExtent: 500,
                      itemBuilder: (context, index) {
                        final note = notes[index];

                        return Material(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: kGap4,
                            ),
                            child: dismissibleWidget(
                              context: context,
                              note: note,
                              child: ListTile(
                                dense: true,
                                title: Text(
                                  note.noteTitle,
                                  style: TextStyle(
                                      fontSize: kBodyLSize,
                                      color: Theme.of(context).colorScheme.primary
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: .center,
                                  crossAxisAlignment: .end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        note.noteTypeName ?? '',
                                        style: TextStyle(
                                          fontSize: kBodyMSize,
                                        ),
                                      ),
                                    ),
                                    schedulesAndAlarmsLine(note)
                                  ],
                                ),
                                subtitle: Text(
                                  note.categoriesNames ?? "",
                                  style: TextStyle(
                                      fontSize: kBodySSize
                                  ),
                                ),
                                onTap: (){
                                  // Navigate to note details page upon tapping a note
                                  context.pushNamed(
                                      'NoteDetails',
                                      extra: {'id': note.noteId.toString()}
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                case .failure:
                  return const Center(child: Text("Error loading notes"));
              }
            }
        );
      },
    );
  }

  ///
  Widget dismissibleWidget({
    required BuildContext context,
    required NoteListViewData note,
    required Widget child,
  }){
    return Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.errorContainer,
          alignment: .centerLeft,
          padding: const EdgeInsets.only(
              left: kGap16
          ),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        secondaryBackground: Container(
          color: Theme.of(context).colorScheme.primary,
          alignment: .centerRight,
          padding: const EdgeInsets.only(
              right: kGap16
          ),
          child: Icon(
            Icons.check_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        onDismissed: (direction) {
          if(direction == .endToStart){
            // Mark note as completed
            context.read<ShowNoteBloc>().add(
                ChangeNoteStatus(noteId: note.noteId, newStatus: .done));
          }else if (direction == .startToEnd){
            // Trigger note deletion in the bloc
            context.read<ShowNoteBloc>().add(DeleteNoteById(note.noteId));
          }
        },
        key: UniqueKey(),
        child: child
    );
  }

  /// Widget to display schedules and alarms count information for a note.
  Widget schedulesAndAlarmsLine(NoteListViewData note){
    // Only show if there are schedules or recurring schedules
    if(note.schedulesCount > 0 || note.recurringSchedulesCount > 0){
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.only(
              top: kGap4
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              // Show SINGLE DATE schedules count if greater than 0
              if(note.schedulesCount > 0)
                Row(
                  children: [
                    Text(
                      "${note.schedulesCount}",
                      style: TextStyle(
                        fontSize: kLabelSSize,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: kLabelSSize,
                    ),
                  ],
                ),
              // Show RECURRING schedules count if greater than 0
              if(note.recurringSchedulesCount > 0)
                Padding(
                  padding: const EdgeInsets.only(
                    left: kGap4
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${note.recurringSchedulesCount}",
                        style: TextStyle(
                          fontSize: kLabelSSize,
                        ),
                      ),
                      Icon(
                        Icons.repeat,
                        size: kLabelSSize,
                      ),
                    ],
                  ),
                ),
              // Show reminders count if greater than 0
              if(note.remindersCount > 0)
                Padding(
                  padding: const EdgeInsets.only(
                      left: kGap4
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${note.remindersCount}",
                        style: TextStyle(
                          fontSize: kLabelSSize,
                        ),
                      ),
                      Icon(
                        Icons.alarm,
                        size: kLabelSSize,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return kEmptyWidget;
  }
}