
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/categories/categories_bloc.dart';
import 'package:jampa_flutter/ui/categories/widgets/categories_list_widget.dart';
import 'package:jampa_flutter/ui/widgets/jampa_scaffolded_app_bar_widget.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/enums/ui_status.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/routers/routes.dart';

import '../../widgets/headers.dart';

class CategoriesLayout extends StatelessWidget {
  const CategoriesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return JampaScaffoldedAppBarWidget(
      body: BlocConsumer<CategoriesBloc, CategoriesState>(
        bloc: context.read<CategoriesBloc>(),
        listener: (context, state) {
          // Show feedback snackbars based on deletion outcome
          if (state.categoryDeletionStatus.isFailure) {
            SnackBarX.showError(context, context.strings.delete_category_error_message);
          } else if (state.categoryDeletionStatus.isSuccess) {
            SnackBarX.showSuccess(context, context.strings.delete_category_success_feedback);
          }
        },
        builder: (context, asyncSnapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen header with add button
              Headers.listHeader(
                context: context,
                title: context.strings.categories,
                onAddPressed: (){
                  context.pushNamed(kAppRouteCreateCategoryName);
                },
              ),
              // Categories list
              Expanded(
                child: CategoriesListWidget()
              ),
            ],
          );
        }
      ),
    );
  }
}