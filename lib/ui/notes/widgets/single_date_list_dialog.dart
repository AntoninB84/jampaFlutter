
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/notes/single_date_list/single_date_list_bloc.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../widgets/confirmation_dialog.dart';

class SingleDateListDialog extends StatefulWidget {
  const SingleDateListDialog({
    super.key,
    required this.fromMemory,
    required this.onDateDeleted,
  });

  final bool fromMemory;
  final Function(int) onDateDeleted;

  @override
  State<SingleDateListDialog> createState() => _SingleDateListDialogState();
}

class _SingleDateListDialogState extends State<SingleDateListDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SingleDateListBloc>(
      create: (context) {
        final bloc = SingleDateListBloc();
        if(widget.fromMemory){
          final createNoteState = serviceLocator<CreateNoteCubit>().state;
          bloc.add(InitializeSingleDateListFromMemoryState(
            singleDateElements: createNoteState.selectedSingleDateElements,
          ));
        }else{
          bloc.add(LoadPersistentSingleDateList());
        }
        return bloc;
      },
      child: BlocConsumer<SingleDateListBloc, SingleDateListState>(
        listener: (context, state){
          
        },
        builder: (context, state) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.singleDateElements.length,
                      itemBuilder: (context, index) {
                        final date = state.singleDateElements[index];
                        final String displayText = date.selectedStartDateTime != null
                            ? date.selectedStartDateTime!.toLocal().toString()
                            : 'null';
          
                        return ListTile(
                          title: Text(displayText),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  context.pop();
                                  context.pushNamed('CreateSingleDate',
                                    extra: {'dateIndex': index}
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(context: context, builder: (BuildContext dialogContext){
                                    return ConfirmationDialog(
                                        title: context.strings.delete_date_confirmation_title('false'),
                                        content: context.strings.delete_date_confirmation_message(
                                            displayText,
                                            'false'
                                        ),
                                        confirmButtonText: context.strings.delete,
                                        cancelButtonText: context.strings.cancel,
                                        onConfirm: (){
                                          if(widget.fromMemory) {
                                            //Remove from state
                                            context.read<SingleDateListBloc>()
                                                .add(RemoveSingleDateFromMemoryList(index: index));
                                            //Notify CreateNoteCubit
                                            widget.onDateDeleted(index);
                                          }else{
                                            //TODO
                                            // context.read<SingleDateListBloc>()
                                            //     .add(DeletePersistentSingleDate(id: date.id));
                                          }
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
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      context.pop();
                      context.pushNamed('CreateSingleDate');
                    },
                    child: Text(context.strings.create_note_add_single_date_button)
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}