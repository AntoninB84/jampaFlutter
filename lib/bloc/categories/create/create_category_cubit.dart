import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';

part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  CreateCategoryCubit({
    required this.categoriesRepository,
  }) : super(const CreateCategoryState());

  final CategoriesRepository categoriesRepository;

  void onNameChanged(String value) {
    final name = NameValidator.dirty(value);
    emit(
        state.copyWith(
          name: name,
          isValidName: Formz.validate([name]),
          existsAlready: false, // Reset existence check on name change
          isError: false, // Reset error state on name change
          isSuccess: false, // Reset success state on name change
        )
    );
  }

  void onSubmit() {
    final name = NameValidator.dirty(state.name.value);
    emit(
      state.copyWith(
        name: name,
        isValidName: Formz.validate([name]),
      )
    );

    if (state.isValidName) {
      // If the name is valid, start loading
      emit(
          state.copyWith(
              isLoading: true,
              isError: false,
              isSuccess: false
          )
      );
      // Check if the category already exists
      categoriesRepository.getCategoryByName(name.value).then((category) {
        if (category != null) {
          // If the category already exists, emit a state indicating it
          emit(state.copyWith(existsAlready: true, isLoading: false));
        } else {
          CategoryEntity category = CategoryEntity(
              name: state.name.value,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now()
          );
          // If the category does not exist, save it
          categoriesRepository
              .saveCategory(category)
              .then((_) {
                // If the category is saved successfully, emit a success state
                emit(state.copyWith(isSuccess: true, isLoading: false));
              })
              .catchError((error){
                // If an error occurs while saving, emit a state indicating an error
                emit(state.copyWith(isError: true, isLoading: false));
                debugPrint('Error saving category: $error');
              });

        }
      }).catchError((error){
        // If an error occurs, emit a state indicating an error
        emit(state.copyWith(isError: true, isLoading: false));
        debugPrint('Error checking category existence: $error');
      });
    }
  }
}