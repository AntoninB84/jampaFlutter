
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/widgets/custom_text_field.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/utils/extensions/AppContextExtension.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';

import '../../../bloc/categories/create/create_category_cubit.dart';

class CreateCategoryLayout extends StatelessWidget {
  const CreateCategoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCategoryCubit, CreateCategoryState>(
      listener: (context, state) {
        if (state.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.strings.generic_error_message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.strings.create_category_success_feedback),
              backgroundColor: Colors.green,
            ),
          );
          // Pop the context with a success result
          context.pop(true);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.strings.create_category_title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              CategoryNameTextField(),
              const SizedBox(height: 16),
              SubmitCategoryButton(),
              const SizedBox(height: 16),
              CancelButton(),
            ],
          ),
        ),
      )
    );
  }
}

class CategoryNameTextField extends StatelessWidget {
  const CategoryNameTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
      builder: (context, state) {
        return CustomTextField(
            onChanged: (value) => context.read<CreateCategoryCubit>().onNameChanged(value),
            hintText: context.strings.create_category_name_field_hint,
            errorWidget: (!state.isValidName || state.existsAlready) ? ErrorText(
                errorText: (){
                  if (state.name.displayError == NameValidationError.empty || state.name.displayError == NameValidationError.invalidLength) {
                    return context.strings.create_category_name_invalid_length;
                  }else if (state.existsAlready) {
                    return context.strings.create_category_name_exists_already;
                  }
                  return context.strings.generic_error_message;
                }()
            ) : null
        );
      },
    );
  }
}

class SubmitCategoryButton extends StatelessWidget {
  const SubmitCategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidName && !state.existsAlready && !state.isLoading
              ? () => context.read<CreateCategoryCubit>().onSubmit()
              : null,
          child: state.isLoading
              ? const CupertinoActivityIndicator()
              : Text(context.strings.create_category_create_button_label),
        );
      },
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.pop(),
      child: Text(context.strings.create_category_cancel_button_label),
    );
  }
}

