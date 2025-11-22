import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/ui/schedule/widgets/save_recurrent_date_list.dart';
import 'package:jampa_flutter/ui/schedule/widgets/save_single_date_list.dart';
import 'package:jampa_flutter/ui/widgets/Commons.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/notes/save/save_note_bloc.dart';

class SchedulesTabView extends StatefulWidget {
  const SchedulesTabView({
    super.key,
    required this.noteId,
    this.isEditing = false,
  });

  final String noteId;
  final bool isEditing;

  @override
  State<SchedulesTabView> createState() => _SchedulesTabViewState();
}

class _SchedulesTabViewState extends State<SchedulesTabView>
    with SingleTickerProviderStateMixin {

  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveNoteBloc, SaveNoteState>(
        buildWhen: (previous, current) {
          return (previous.singleDateSchedules != current.singleDateSchedules)
              || (previous.recurrentSchedules != current.recurrentSchedules);
        },
        builder: (context, dataState) {
          return Column(
            children: [
              TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: context.strings.create_note_single_date_count(
                          dataState.singleDateSchedules.length
                      ),
                    ),
                    Tab(
                      text: context.strings.create_note_recurrent_date_count(
                          dataState.recurrentSchedules.length
                      ),
                    ),
                  ]
              ),
              Commons.secondaryListsContainer(
                context: context,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SaveSingleDateList(
                      noteId: widget.noteId,
                      listElements: dataState.singleDateSchedules,
                      isEditing: widget.isEditing,
                    ),
                    SaveRecurrentDateList(
                      noteId: widget.noteId,
                      listElements: dataState.recurrentSchedules,
                      isEditing: widget.isEditing
                    )
                  ],
                ),
              ),
            ],
          );
        }
    );
  }
}