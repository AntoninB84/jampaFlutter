import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/ui/schedule/widgets/save_recurrent_date_list.dart';
import 'package:jampa_flutter/ui/schedule/widgets/save_single_date_list.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/schedule/save_recurrent_date_list/save_recurrent_date_list_bloc.dart';
import '../../../bloc/schedule/save_single_date_list/save_single_date_list_bloc.dart';

class SchedulesTabView extends StatefulWidget {
  const SchedulesTabView({
    super.key,
    this.isSavingPersistentData = false,
    this.recurrenceListElements = const [],
    this.singleDateListElements = const [],
    required this.onRecurrentDateDeleted,
    required this.onSingleDateDeleted,
  });

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
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 0.2,
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.zero,
              bottom: Radius.circular(4.0)
            ),
          ),
          padding: const EdgeInsets.all(kGap8),
          child: TabBarView(
            controller: _tabController,
            children: [
              SaveSingleDateList(
                listElements: widget.singleDateListElements,
                onDateDeleted: widget.onSingleDateDeleted
              ),
              SaveRecurrentDateList(
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