
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../../utils/constants/styles/sizes.dart';

class RecurrenceTypeSelector extends StatelessWidget {
  const RecurrenceTypeSelector({super.key, this.value, required this.onChanged});

  final RecurrenceType? value;
  final Function(RecurrenceType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<RecurrenceType>(
      decoration: InputDecoration(
        labelText: context.strings.create_recurrent_date_field_title,
        border: OutlineInputBorder(
            borderRadius: kRadius8
        ),
      ),
      dropdownColor: Theme.of(context).popupMenuTheme.color,
      borderRadius: kRadius12,
      value: value,
      items: RecurrenceType.values.map((recurrenceType) {
        return DropdownMenuItem<RecurrenceType>(
          value: recurrenceType,
          child: Text(recurrenceType.displayName(context)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}