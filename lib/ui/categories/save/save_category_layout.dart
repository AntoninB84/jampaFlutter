
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/ui/categories/widgets/category_name_text_field.dart';

import '../../../bloc/categories/save/save_category_cubit.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../widgets/cancel_button.dart';

class SaveCategoryLayout extends StatelessWidget {
  const SaveCategoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveCategoryCubit, SaveCategoryState>(
      listener: (context, state) {
        if (state.isError) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.isSuccess) {
          SnackBarX.showSuccess(context,
              state.category != null ?
                context.strings.edit_category_success_feedback
                  : context.strings.create_category_success_feedback);
          // Back to the previous screen after success
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headers.noActionHeader(
                  context: context,
                  title: state.category != null ?
                  context.strings.edit_category_title
                      : context.strings.create_category_title,
              ),
              const SizedBox(height: kGap16),
              CategoryNameTextField(),
              const SizedBox(height: kGap16),
              Row(
                children: [
                  CancelButton(),
                  Spacer(),
                  SubmitCategoryButton(),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}

class SubmitCategoryButton extends StatelessWidget {
  const SubmitCategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveCategoryCubit, SaveCategoryState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidName && !state.existsAlready && !state.isLoading
              ? () => context.read<SaveCategoryCubit>().onSubmit()
              : null,
          child: state.isLoading
              ? const CupertinoActivityIndicator()
              : Text(state.category != null ? context.strings.edit : context.strings.create),
        );
      },
    );
  }
}
