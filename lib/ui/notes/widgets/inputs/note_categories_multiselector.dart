
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/categories/categories_bloc.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/constants/styles/styles.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class NoteCategoriesMultiSelector extends StatefulWidget{
  const NoteCategoriesMultiSelector({
    super.key,
    this.selectedCategories = const [],
    required this.onCategorySelected,
  });

  final List<CategoryEntity> selectedCategories;
  final Function(List<CategoryEntity>) onCategorySelected;

  @override
  State<NoteCategoriesMultiSelector> createState() => _NoteCategoriesMultiSelectorState();
}

class _NoteCategoriesMultiSelectorState extends State<NoteCategoriesMultiSelector>{
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesBloc>(
        create: (context) => CategoriesBloc()..add(WatchCategories()),
        child: BlocConsumer<CategoriesBloc, CategoriesState>(
            listener: (context, state) {
              if (state.listStatus.isError) {
                SnackBarX.showError(context, context.strings.generic_error_message);
              }
            },
            builder: (context, state) {
              List<CategoryEntity> categories = state.categories;

              return MultiDropdown(
                key: UniqueKey(),
                enabled: true,
                closeOnBackButton: true,
                onSelectionChange: widget.onCategorySelected,
                items: categories.map((category) {
                  return DropdownItem<CategoryEntity>(
                    value: category,
                    label: category.name,
                    selected: widget.selectedCategories.contains(category),
                  );
                }).toList(),
                fieldDecoration: MultiDropdownTheme.fieldDecoration(
                  context,
                  context.strings.create_note_categories_field_title
                ),
                dropdownDecoration: MultiDropdownTheme.dropdownDecoration(context),
                dropdownItemDecoration: MultiDropdownTheme.dropdownItemDecoration(context),
                chipDecoration: MultiDropdownTheme.chipDecoration(context),
              );
            }
        )
    );
  }
}
