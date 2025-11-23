
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/note_types/note_types_bloc.dart';
import 'package:jampa_flutter/ui/note_types/widgets/note_types_list_widget.dart';
import 'package:jampa_flutter/ui/widgets/jampa_scaffolded_app_bar_widget.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../widgets/headers.dart';

class NoteTypesLayout extends StatelessWidget {
  const NoteTypesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteTypesBloc, NoteTypesState>(
        bloc: context.read<NoteTypesBloc>(),
        listener: (context, state) {
          if (state.deletionError) {
            SnackBarX.showError(context, context.strings.delete_note_type_error_message);
          } else if (state.deletionSuccess) {
            SnackBarX.showSuccess(context, context.strings.delete_note_type_success_feedback);
          }
        },
        builder: (context, asyncSnapshot) {
          return JampaScaffoldedAppBarWidget(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Headers.listHeader(
                  context: context,
                  title: context.strings.note_types,
                  onAddPressed: (){
                    context.pushNamed("CreateNoteType");
                  },
                  onBackPressed: (){
                    context.pop();
                  },
                ),
                Expanded(
                  child: NoteTypesListWidget()
                ),
              ],
            ),
          );
        }
    );
  }
}