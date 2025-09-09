
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/categories/categories_bloc.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/enums/weekdays_enum.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class RecurrenceWeekdaysMultiSelector extends StatefulWidget{
  const RecurrenceWeekdaysMultiSelector({
    super.key,
    this.selectedWeekdays = const [],
    required this.onWeekdaySelected,
    required this.validator,
  });

  final List<WeekdaysEnum> selectedWeekdays;
  final Function(List<WeekdaysEnum>) onWeekdaySelected;
  final String? Function(List<DropdownItem<WeekdaysEnum>>?)? validator;

  @override
  State<RecurrenceWeekdaysMultiSelector> createState() => _RecurrenceWeekdaysMultiSelectorState();
}

class _RecurrenceWeekdaysMultiSelectorState extends State<RecurrenceWeekdaysMultiSelector>{
  @override
  Widget build(BuildContext context) {
    return MultiDropdown(
      key: UniqueKey(),
      enabled: true,
      onSelectionChange: widget.onWeekdaySelected,
      items: WeekdaysEnum.values.map((weekday) {
        return DropdownItem<WeekdaysEnum>(
          value: weekday,
          label: weekday.displayName(context),
          selected: widget.selectedWeekdays.contains(weekday),
        );
      }).toList(),
      validator: widget.validator,
    );
  }
}
