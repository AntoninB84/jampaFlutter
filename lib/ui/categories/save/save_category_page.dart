
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/categories/save/save_category_cubit.dart';
import 'package:jampa_flutter/ui/categories/save/save_category_layout.dart';

class SaveCategoryPage extends StatefulWidget {
  const SaveCategoryPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  State<SaveCategoryPage> createState() => _SaveCategoryPageState();
}

class _SaveCategoryPageState extends State<SaveCategoryPage> {

  late final SaveCategoryCubit _saveCategoryCubit;

  @override
  void initState() {
    super.initState();

    _saveCategoryCubit = SaveCategoryCubit();

    // Defer data fetching to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveCategoryCubit.fetchCategoryForUpdate(widget.categoryId);
    });
  }

  @override
  void dispose() {
    _saveCategoryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaveCategoryCubit>.value(
      value: _saveCategoryCubit,
      child: const SaveCategoryLayout(),
    );
  }
}