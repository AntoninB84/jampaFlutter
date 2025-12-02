import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/utils/enums/ui_status.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';
import 'package:uuid/uuid.dart';

part 'save_category_state.dart';

/// Cubit to manage the state of saving a category
/// Handles both creating a new category and updating an existing one
class SaveCategoryCubit extends Cubit<SaveCategoryState> {
  SaveCategoryCubit() : super(const SaveCategoryState());

  final CategoriesRepository categoriesRepository =
      serviceLocator<CategoriesRepository>();

  /// Fetches a category by its ID for updating
  /// If the category is found, updates the state with its details
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
              emit(state.copyWith(saveCategoryStatus: .failure));
            }
          }).catchError((error) {
            emit(state.copyWith(saveCategoryStatus: .failure));
            debugPrint('Error fetching category for update: $error');
          });
      } catch (e) {
        emit(state.copyWith(saveCategoryStatus: .failure));
        debugPrint('Error initializing fetchCategoryForUpdate: $e');
      }
    }
  }

  /// Handles changes to the category name input field
  void onNameChanged(String value) {
    final name = NameValidator.dirty(value);
    emit(
        state.copyWith(
          name: name,
          isValidName: Formz.validate([name]),
          existsAlready: false, // Reset existence check on name change
          saveCategoryStatus: .initial
        )
    );
  }

  /// Submits the category form
  /// Validates the input and either creates a new category or updates an existing one
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
            saveCategoryStatus: .loading,
          )
      );
      // Check if the category already exists
      categoriesRepository.getCategoryByName(name.value).then((category) {
        if (category != null) {
          // If the category already exists, emit a state indicating it
          emit(state.copyWith(existsAlready: true, saveCategoryStatus: .initial));
        } else {
          late CategoryEntity category;
          if(state.category != null){
            // If updating an existing category, copy its details with the new name
            category = state.category!.copyWith(
              name: state.name.value,
              createdAt: state.category!.createdAt,
              updatedAt: DateTime.now()
            );
          }else{
            // If creating a new category, create a new entity
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
                emit(state.copyWith(saveCategoryStatus: .success));
              })
              .catchError((error){
                // If an error occurs while saving, emit a state indicating an error
                emit(state.copyWith(saveCategoryStatus: .failure));
                debugPrint('Error saving category: $error');
              });

        }
      }).catchError((error){
        // If an error occurs, emit a state indicating an error
        emit(state.copyWith(saveCategoryStatus: .failure));
        debugPrint('Error checking category existence: $error');
      });
    }
  }
}