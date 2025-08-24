
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/categories/categories_bloc.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../bloc/notes/create/create_note_cubit.dart';

class NoteCategoriesMultiSelector extends StatefulWidget{
  const NoteCategoriesMultiSelector({super.key});

  @override
  State<NoteCategoriesMultiSelector> createState() => _NoteCategoriesMultiSelectorState();
}

class _NoteCategoriesMultiSelectorState extends State<NoteCategoriesMultiSelector>{
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesBloc>(
        create: (context) => CategoriesBloc(
            categoriesRepository: context.read<CategoriesRepository>()
        )..add(WatchCategories()),
        child: BlocConsumer<CategoriesBloc, CategoriesState>(
            listener: (context, state) {
              if (state.listStatus.isError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.strings.generic_error_message))
                );
              }
            },
            builder: (context, state) {
              List<CategoryEntity> categories = state.categories;

              List<CategoryEntity> selectedCategories = [];

              return BlocConsumer<CreateNoteCubit, CreateNoteState>(
                  listener: (context, state){
                    if(state.note != null){
                      context.read<CreateNoteCubit>()
                          .onSelectedCategoriesChanged(state.note!.categories ?? []);
                    }
                  },
                  listenWhen: (previous, current) {
                    // Only listen for changes in the note
                    return previous.note != current.note;
                  },
                  builder: (context, state) {
                    selectedCategories = state.selectedCategories;

                    return MultiDropdown(
                      key: UniqueKey(),
                      enabled: true,
                      onSelectionChange: (values) =>
                          context.read<CreateNoteCubit>()
                              .onSelectedCategoriesChanged(values),
                      items: categories.map((category) {
                        return DropdownItem<CategoryEntity>(
                          value: category,
                          label: category.name,
                          selected: selectedCategories.contains(category),
                        );
                      }).toList(),
                    );
                  }
              );
            }
        )
    );
  }
}
