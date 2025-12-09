import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/categories/categories_bloc.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/ui/widgets/confirmation_dialog.dart';
import 'package:jampa_flutter/utils/constants/data/fake_skeleton_data.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/routers/routes.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../data/objects/category_with_count.dart';
import '../../../utils/enums/ui_status.dart';

/// A widget that displays a list of all categories with their usage counts.
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
            case .initial:
            case .loading:
            case .success:
              // Use fake skeleton data while loading
              List<CategoryWithCount> categoriesWithCount = state.listStatus.isLoading
                  ? List.filled(5, fakeSkeletonCategoryWithCount)
                  : state.categoriesWithCount;

              // Show no results found if the list is empty
              if(categoriesWithCount.isEmpty){
                return Center(child: Text(context.strings.no_results_found));
              }

              return Skeletonizer(
                enabled: state.listStatus.isLoading,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: categoriesWithCount.length,
                  itemBuilder: (context, index) {
                    // Retrieve category and its usage count based on index
                    final category = categoriesWithCount[index].category;
                    final usageCount = categoriesWithCount[index].noteCount;

                    return Material(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kGap4
                        ),
                        child: ListTile(
                          title: Text(
                            category.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary
                            )
                          ),
                          onTap: () {
                            // Navigate to edit category page with category ID as parameter
                            context.pushNamed(kAppRouteEditCategoryName,
                                extra: {'id': category.id.toString()}
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Buttons.deleteButtonIcon(
                                context: context,
                                onPressed: (usageCount > 0) ? null : () {
                                  showDialog(context: context, builder: (BuildContext dialogContext){
                                    return ConfirmationDialog(
                                        title: context.strings.delete_category_confirmation_title,
                                        content: context.strings.delete_category_confirmation_message(category.name),
                                        confirmButtonText: context.strings.delete,
                                        cancelButtonText: context.strings.cancel,
                                        onConfirm: (){
                                          // Dispatch delete category event to CategoriesBloc
                                          context.read<CategoriesBloc>().add(DeleteCategory(category.id));
                                          // Close the dialog
                                          dialogContext.pop();
                                        },
                                        onCancel: (){
                                          // Close the dialog
                                          dialogContext.pop();
                                        }
                                    );
                                  });
                                }
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            case .failure:
              return const Center(child: Text("Error loading categories"));
          }
        }
    );
  }
}