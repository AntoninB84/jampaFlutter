import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/categories/save/save_category_cubit.dart';
import 'package:jampa_flutter/ui/widgets/inputs/custom_text_field.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';

class CategoryNameTextField extends StatefulWidget {
  const CategoryNameTextField({super.key});

  @override
  State<CategoryNameTextField> createState() => _CategoryNameTextFieldState();
}

class _CategoryNameTextFieldState extends State<CategoryNameTextField> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveCategoryCubit, SaveCategoryState>(
      listener: (context, state){
        if(state.category != null){
          _textEditingController.text = state.category!.name;
        }
      },
      listenWhen: (previous, current) {
        // Only listen for changes in the category
        return previous.category != current.category;
      },
      builder: (context, state) {
        return CustomTextField(
            controller: _textEditingController,
            onChanged: (value) => context.read<SaveCategoryCubit>().onNameChanged(value),
            hintText: context.strings.create_category_name_field_hint,
            errorWidget: (!state.isValidName || state.existsAlready) ? ErrorText(
                errorText: (){
                  if ((state.name.displayError?.isEmpty ?? false) || (state.name.displayError?.isInvalidLength ?? false)) {
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