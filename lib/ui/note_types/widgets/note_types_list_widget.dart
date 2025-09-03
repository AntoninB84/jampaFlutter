import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/note_types/note_types_bloc.dart';
import 'package:jampa_flutter/ui/widgets/confirmation_dialog.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

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
            case NoteTypesListStatus.initial:
            case NoteTypesListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case NoteTypesListStatus.success:
              return ListView.builder(
                controller: scrollController,
                itemCount: state.noteTypesWithCount.length,
                itemBuilder: (context, index) {
                  final noteType = state.noteTypesWithCount[index].noteType;
                  final usageCount = state.noteTypesWithCount[index].noteCount;

                  return ListTile(
                    title: Text(noteType.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            context.pushNamed("EditNoteType", extra: {'id': noteType.id.toString()});
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: (usageCount > 0) ? null : () {
                            showDialog(context: context, builder: (BuildContext dialogContext){
                              return ConfirmationDialog(
                                  title: context.strings.delete_note_type_confirmation_title,
                                  content: context.strings.delete_note_type_confirmation_message(noteType.name),
                                  confirmButtonText: context.strings.delete,
                                  cancelButtonText: context.strings.cancel,
                                  onConfirm: (){
                                    context.read<NoteTypesBloc>().add(DeleteNoteType(noteType.id!));
                                    dialogContext.pop();
                                  },
                                  onCancel: (){dialogContext.pop();}
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            case NoteTypesListStatus.error:
              return const Center(child: Text("Error loading noteTypes"));
          }
        }
    );
  }
}