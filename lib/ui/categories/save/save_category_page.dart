
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/categories/save/save_category_cubit.dart';
import 'package:jampa_flutter/ui/categories/save/save_category_layout.dart';

class SaveCategoryPage extends StatelessWidget {
  const SaveCategoryPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaveCategoryCubit>(
      create: (context) => SaveCategoryCubit()
        ..fetchCategoryForUpdate(categoryId),
      child: const SaveCategoryLayout(),
    );
  }
}