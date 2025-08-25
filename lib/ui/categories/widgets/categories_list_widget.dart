import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/categories/categories_bloc.dart';
import 'package:jampa_flutter/ui/widgets/confirmation_dialog.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

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
          switch(state.listStatus){
            case CategoriesListStatus.initial:
            case CategoriesListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CategoriesListStatus.success:

              if(state.categoriesWithCount.isEmpty){
                return Center(child: Text(context.strings.no_results_found));
              }
              return ListView.builder(
                controller: scrollController,
                itemCount: state.categoriesWithCount.length,
                itemBuilder: (context, index) {
                  final category = state.categoriesWithCount[index].category;
                  final usageCount = state.categoriesWithCount[index].noteCount;

                  return ListTile(
                    title: Text(category.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            context.pushNamed("EditCategory", pathParameters: {'id': category.id.toString()});
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: (usageCount > 0) ? null : () {
                            showDialog(context: context, builder: (BuildContext dialogContext){
                              return ConfirmationDialog(
                                  title: context.strings.delete_category_confirmation_title,
                                  content: context.strings.delete_category_confirmation_message(category.name),
                                  confirmButtonText: context.strings.delete,
                                  cancelButtonText: context.strings.cancel,
                                  onConfirm: (){
                                    context.read<CategoriesBloc>().add(DeleteCategory(category.id!));
                                    dialogContext.pop();
                                  },
                                  onCancel: (){dialogContext.pop();}
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            case CategoriesListStatus.error:
              return const Center(child: Text("Error loading categories"));
          }
        }
    );
  }
}