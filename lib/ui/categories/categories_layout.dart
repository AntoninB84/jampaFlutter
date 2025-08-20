
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/categories/categories_bloc.dart';
import 'package:jampa_flutter/ui/categories/widgets/categories_list_widget.dart';

class CategoriesLayout extends StatelessWidget {
  const CategoriesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CategoriesListWidget(),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () async {
              final result = await context.pushNamed("CreateCategory");
              if (result != null && result is bool && result && context.mounted) {
                // Optionally, you can refresh the categories list here
                context.read<CategoriesBloc>().add(GetCategories());
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}