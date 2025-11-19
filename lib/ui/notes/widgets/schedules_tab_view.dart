import 'package:flutter/material.dart';
import 'package:jampa_flutter/bloc/notes/form/note_form_helpers.dart';
import 'package:jampa_flutter/ui/schedule/widgets/save_recurrent_date_list.dart';
import 'package:jampa_flutter/ui/schedule/widgets/save_single_date_list.dart';
import 'package:jampa_flutter/ui/widgets/Commons.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

class SchedulesTabView extends StatefulWidget {
  const SchedulesTabView({
    super.key,
    required this.noteId,
    this.isSavingPersistentData = false,
    required this.recurrenceListElements,
    required this.singleDateListElements,
    required this.onRecurrentDateDeleted,
    required this.onSingleDateDeleted,
  });

  final String noteId;
  final bool isSavingPersistentData;
  final List<RecurrenceFormElements> recurrenceListElements;
  final List<SingleDateFormElements> singleDateListElements;
  final Function(int) onRecurrentDateDeleted;
  final Function(int) onSingleDateDeleted;

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
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: context.strings.create_note_single_date_count(
                  widget.singleDateListElements.length
              ),
            ),
            Tab(
              text: context.strings.create_note_recurrent_date_count(
                  widget.recurrenceListElements.length
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
                isSavingPersistentData: widget.isSavingPersistentData,
                listElements: widget.singleDateListElements,
                onDateDeleted: widget.onSingleDateDeleted
              ),
              SaveRecurrentDateList(
                noteId: widget.noteId,
                isSavingPersistentData: widget.isSavingPersistentData,
                listElements: widget.recurrenceListElements,
                onDateDeleted: widget.onRecurrentDateDeleted
              )
            ],
          ),
        ),
      ],
    );
  }
}