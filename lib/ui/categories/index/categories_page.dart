
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/categories/categories_bloc.dart';
import 'categories_layout.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  late final CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();
    _categoriesBloc = CategoriesBloc();

    // Defer data fetching to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _categoriesBloc.add(WatchCategoriesWithCount());
    });
  }

  @override
  void dispose() {
    _categoriesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesBloc>.value(
      value: _categoriesBloc,
      child: const CategoriesLayout(),
    );
  }
}