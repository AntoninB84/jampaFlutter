
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/categories/categories_bloc.dart';
import 'package:jampa_flutter/ui/categories/widgets/categories_list_widget.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

class CategoriesLayout extends StatelessWidget {
  const CategoriesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      bloc: context.read<CategoriesBloc>(),
      listener: (context, state) {
        if (state.status == CategoriesListStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.strings.generic_error_message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, asyncSnapshot) {
        return Stack(
          children: [
            CategoriesListWidget(),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  context.pushNamed("CreateCategory");
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      }
    );
  }
}