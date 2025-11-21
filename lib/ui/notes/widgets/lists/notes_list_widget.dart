import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/list_view/notes_list_view_bloc.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../utils/constants/data/fake_skeleton_data.dart';

class NotesListWidget extends StatefulWidget {
  const NotesListWidget({super.key});

  @override
  State<NotesListWidget> createState() => _NotesListWidgetState();
}

class _NotesListWidgetState extends State<NotesListWidget> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesListViewBloc, NotesListViewState>(
        builder: (context, state) {
          switch(state.listStatus){
            case NotesListStatus.initial:
            case NotesListStatus.loading:
            case NotesListStatus.success:
              List<NoteListViewData> notes = state.listStatus.isLoading ?
                List.filled(3, fakeSkeletonNoteListViewData) : state.notes;

              if(notes.isEmpty){
                return Center(child: Text(context.strings.no_results_found));
              }

              return Skeletonizer(
                enabled: state.listStatus.isLoading,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return Material(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kGap4,
                        ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                            context.pushNamed(
                                'NoteDetails',
                                extra: {'id': note.noteId.toString()}
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            case NotesListStatus.error:
              return const Center(child: Text("Error loading notes"));
          }
        }
    );
  }

  Widget schedulesAndAlarmsLine(NoteListViewData note){
    if(note.schedulesCount > 0 || note.recurringSchedulesCount > 0){
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.only(
              top: kGap4
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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