import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/categories/widgets/category_name_text_field.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/ui/widgets/jampa_scaffolded_app_bar_widget.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../bloc/categories/save/save_category_cubit.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../../utils/enums/ui_status.dart';
import '../../widgets/buttons/buttons.dart';

class SaveCategoryLayout extends StatelessWidget {
  const SaveCategoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveCategoryCubit, SaveCategoryState>(
      listener: (context, state) {
        // Show feedback based on the saving state
        if (state.saveCategoryStatus.isFailure) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.saveCategoryStatus.isSuccess) {
          SnackBarX.showSuccess(
            context,
            state.category != null
                ? context.strings.edit_category_success_feedback
                : context.strings.create_category_success_feedback,
          );
          // Back to the previous screen after success
          context.pop();
        }
      },
      builder: (context, state) {
        return JampaScaffoldedAppBarWidget(
          actions: [
            Buttons.saveButtonIcon(
              context: context,
              onPressed: state.isValidName && !state.existsAlready && !state.saveCategoryStatus.isLoading
                  ? () => context.read<SaveCategoryCubit>().onSubmit()
                  : null,
            )
          ],
          body: Column(
            crossAxisAlignment: .start,
            children: [
              Headers.basicHeader(
                context: context,
                title: state.category != null
                    ? context.strings.edit_category_title
                    : context.strings.create_category_title,
              ),
              const SizedBox(height: kGap16),
              CategoryNameTextField(),
              const SizedBox(height: kGap16),
            ],
          ),
        );
      },
    );
  }
}