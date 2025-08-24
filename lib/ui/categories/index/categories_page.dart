
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/categories/categories_bloc.dart';
import '../../../repository/categories_repository.dart';
import 'categories_layout.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesBloc>(
      create: (context) => CategoriesBloc(
          categoriesRepository: context.read<CategoriesRepository>()
      )..add(WatchCategories()),

      child: const CategoriesLayout(),
    );
  }
}