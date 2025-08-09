
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jampa_flutter/ui/categories/widgets/categories_list_widget.dart';

class CategoriesLayout extends StatelessWidget {
  const CategoriesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: CategoriesListWidget())
      ],
    );
  }
}