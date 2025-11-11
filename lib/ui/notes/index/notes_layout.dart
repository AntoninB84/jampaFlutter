import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/list_view/notes_list_view_bloc.dart';
import 'package:jampa_flutter/ui/notes/widgets/lists/notes_list_widget.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/constants/styles/styles.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headers.listHeader(
                context: context,
                title: context.strings.notes,
                onAddPressed: (){
                  context.pushNamed("CreateNote");
                },
              ),
              Expanded(
                child: NotesListWidget()
              ),
            ],
          );
        }
    );
  }
}