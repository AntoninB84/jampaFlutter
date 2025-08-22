import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/list_view/notes_list_view_bloc.dart';
import 'package:jampa_flutter/bloc/notes/notes_bloc.dart';
import 'package:jampa_flutter/ui/notes/widgets/notes_list_widget.dart';

class NotesLayout extends StatelessWidget {
  const NotesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesListViewBloc, NotesListViewState>(
        bloc: context.read<NotesListViewBloc>(),
        listener: (context, state) {
          // Do nothing for now
        },
        builder: (context, asyncSnapshot) {
          return Stack(
            children: [
              NotesListWidget(),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    context.pushNamed("CreateNote");
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        }
    );
  }
}