import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';
import 'package:uuid/uuid.dart';

part 'save_category_state.dart';

class SaveCategoryCubit extends Cubit<SaveCategoryState> {
  SaveCategoryCubit() : super(const SaveCategoryState());

  final CategoriesRepository categoriesRepository =
      serviceLocator<CategoriesRepository>();

  void fetchCategoryForUpdate(String? categoryId) {
    if(categoryId != null){
      try {
        // Fetch the category by ID and update the state
        categoriesRepository.getCategoryById(categoryId)
          .then((category) {
            if (category != null) {
              emit(state.copyWith(
                category: category,
                name: NameValidator.dirty(category.name),
                isValidName: Formz.validate([NameValidator.dirty(category.name)]),
              ));
            } else {
              emit(state.copyWith(isError: true));
            }
          }).catchError((error) {
            emit(state.copyWith(isError: true));
            debugPrint('Error fetching category for update: $error');
          });
      } catch (e) {
        emit(state.copyWith(isError: true));
        debugPrint('Error initializing fetchCategoryForUpdate: $e');
      }
    }
  }

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
          late CategoryEntity category;
          if(state.category != null){
            category = state.category!.copyWith(
              name: state.name.value,
              createdAt: state.category!.createdAt,
              updatedAt: DateTime.now()
            );
          }else{
            category = CategoryEntity(
                id: Uuid().v4(),
                name: state.name.value,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()
            );
          }

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