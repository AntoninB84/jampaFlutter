import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/list_view/notes_list_view_bloc.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

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
              return const Center(child: CircularProgressIndicator());
            case NotesListStatus.success:

              if(state.notes.isEmpty){
                return Center(child: Text(context.strings.no_results_found));
              }
              return ListView.builder(
                controller: scrollController,
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return ListTile(
                    title: Text(note.noteTitle ?? ""),
                    trailing: Text(note.noteTypeName ?? ''),
                    subtitle: Text(note.categoriesNames ?? "",
                      style: TextStyle(fontSize:10 ),
                    ),
                    onTap: (){
                      context.pushNamed(
                          'NoteDetails',
                          extra: {'id': note.noteId.toString()}
                      );
                    },
                  );
                },
              );
            case NotesListStatus.error:
              return const Center(child: Text("Error loading notes"));
          }
        }
    );
  }
}