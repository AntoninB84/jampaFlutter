import 'package:flutter/material.dart';
import 'package:jampa_flutter/data/objects/schedule_with_next_occurrence.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';
import 'package:jampa_flutter/utils/extensions/schedule_extension.dart';

import '../../../../utils/constants/styles/sizes.dart';

/// A widget that displays a list of schedules associated with a note.
/// Also displays associated reminders for each schedule.
///
/// A separator is shown between past and upcoming schedules.
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
          context.strings.show_note_no_schedules,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    DateTime now = DateTime.now();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: ListView.separated(
        itemCount: widget.schedules.length,
        separatorBuilder: (context, index) {
          DateTime? currentScheduleDate = widget.schedules[index].nextOccurrence;
          DateTime? nextScheduleDate = widget.schedules[index + 1].nextOccurrence;

          bool isCurrentBeforeNow = currentScheduleDate?.isAfter(now) ?? true;
          bool isNextAfterNow = nextScheduleDate?.isBefore(now) ?? false;

          if(isCurrentBeforeNow && isNextAfterNow) {
            return listTimelineSeparator();
          } else {
            return kEmptyWidget;
          }
        },
        itemBuilder: (context, index) {
          ScheduleWithNextOccurrence item = widget.schedules[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: kGap4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  child: ListTile(
                    title: Text(
                      item.schedule.displayNameAndValue(context),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: nextOrLastOccurrenceWidget(item),
                  ),
                ),
                reminderSubListWidget(item),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds a sublist widget displaying reminders for a given schedule item.
  Widget reminderSubListWidget(ScheduleWithNextOccurrence item) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: item.schedule.reminders?.length ?? 0,
        itemBuilder: (context, subIndex) {
          final reminder = item.schedule.reminders?[subIndex];
          if(reminder == null) return kEmptyWidget;
          final String displayText = context.strings
              .reminder_display_text(
            reminder.offsetValue,
            (subIndex + 1),
            reminder.offsetType.getLabel(context),
          );

          return Padding(
            padding: const EdgeInsets.only(
                top: kGap4,
                left: kGap16
            ),
            child: Material(
              child: ListTile(
                dense: true,
                title: Text(
                  displayText,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          );
        }
    );
  }

  /// Builds a timeline separator widget to indicate the transition
  /// between past and upcoming schedules.
  Widget listTimelineSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kGap8),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 2.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGap8),
            child: Text(
                context.strings.passed,
                style: Theme.of(context).textTheme.bodyMedium
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 2.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a widget displaying the next/last occurrence date
  Widget? nextOrLastOccurrenceWidget(ScheduleWithNextOccurrence item) {
    if(item.schedule.isRecurring
        && item.nextOccurrence != null)
    {
      String nextOrLastOccurrenceDate = item.nextOccurrence!.toFullFormat(context);
      String displayText = item.nextOccurrence!.isBefore(DateTime.now())
          ? context.strings.show_note_previous_occurrence(nextOrLastOccurrenceDate)
          : context.strings.show_note_next_occurrence(nextOrLastOccurrenceDate);

      return Text(
        displayText,
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return null;
  }
}