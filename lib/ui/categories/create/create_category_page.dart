
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/categories/create/create_category_cubit.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';
import 'package:jampa_flutter/ui/categories/create/create_category_layout.dart';

class CreateCategoryPage extends StatelessWidget {
  const CreateCategoryPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateCategoryCubit>(
      create: (context) => CreateCategoryCubit(
          categoriesRepository: context.read<CategoriesRepository>()
      )..fetchCategoryForUpdate(categoryId),
      child: const CreateCategoryLayout(),
    );
  }
}