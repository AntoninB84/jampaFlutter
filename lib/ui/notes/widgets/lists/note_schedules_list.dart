// This is a list widget that displays the schedules and its related alarms for a note.
// The schedules are given to this widget already sorted by date and time.
// The list implements a separator only between the dates anteriorly and posteriorly to the current date.
// The given list is a list of ScheduleWithNextOccurrence objects.
// The comparison is made using the nextOccurrence property of the ScheduleWithNextOccurrence object.

import 'package:flutter/material.dart';
import 'package:jampa_flutter/data/objects/schedule_with_next_occurrence.dart';

class NoteSchedulesList extends StatefulWidget {
  final List<ScheduleWithNextOccurrence> schedules;

  const NoteSchedulesList({super.key, required this.schedules});

  @override
  State<NoteSchedulesList> createState() => _NoteSchedulesListState();
}

class _NoteSchedulesListState extends State<NoteSchedulesList> {
  @override
  Widget build(BuildContext context) {
    if(widget.schedules.isEmpty) {
      return Center(
        child: Text(
          "No schedules available.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    DateTime now = DateTime.now();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: ListView.separated(
        itemCount: widget.schedules.length,
        separatorBuilder: (context, index) {
          DateTime? currentScheduleDate = widget.schedules[index].nextOccurrence;
          DateTime? nextScheduleDate = widget.schedules[index + 1].nextOccurrence;

          bool isCurrentBeforeNow = currentScheduleDate?.isBefore(now) ?? true;
          bool isNextAfterNow = nextScheduleDate?.isAfter(now) ?? false;

          if(isCurrentBeforeNow && isNextAfterNow) {
            return Divider(
              thickness: 2.0,
              color: Theme.of(context).colorScheme.primary,
            );
          } else {
            return SizedBox.shrink();
          }
        },
        itemBuilder: (context, index) {
          ScheduleWithNextOccurrence schedule = widget.schedules[index];
          return ListTile(
            title: Text(
              "Schedule on ${schedule.nextOccurrence}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
      ),
    );
  }
}