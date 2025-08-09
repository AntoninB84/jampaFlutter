import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/categories/categories_bloc.dart';

class CategoriesListWidget extends StatefulWidget {
  const CategoriesListWidget({super.key});

  @override
  State<CategoriesListWidget> createState() => _CategoriesListWidgetState();
}

class _CategoriesListWidgetState extends State<CategoriesListWidget> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          switch(state.status){
            case CategoriesStatus.initial:
            case CategoriesStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CategoriesStatus.success:
              return ListView.builder(
                controller: scrollController,
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return ListTile(
                    title: Text(category.name),
                    onTap: () {
                      // context.read<CategoriesBloc>().add(
                      //   SelectCategory(category.id)
                      // );
                    },
                  );
                },
              );
            case CategoriesStatus.error:
              return const Center(child: Text("Error loading categories"));
          }
        }
    );
  }
}