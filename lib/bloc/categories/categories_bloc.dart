import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';
import 'package:jampa_flutter/utils/enums/ui_status.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../data/models/category.dart';

part 'categories_event.dart';
part 'categories_state.dart';

/// Bloc to manage categories list state and events
/// Handles watching categories, watching categories with use count, and deleting categories
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(const CategoriesState()) {
    on<WatchCategories>(_watchCategories);
    on<WatchCategoriesWithCount>(_watchCategoriesWithCount);
    on<DeleteCategory>(_deleteCategory);
  }
  final CategoriesRepository categoriesRepository =
        serviceLocator<CategoriesRepository>();

  /// Watches all categories and updates the state accordingly
  /// Handles errors by updating the state to reflect an error status
  void _watchCategories(WatchCategories event, Emitter<CategoriesState> emit) async {
    await emit.onEach(
        categoriesRepository.watchAllCategories(),
        onData: (data) {
          emit(
            state.copyWith(
              listStatus: .success,
              categories: data
            )
          );
        },
      onError: (error, stackTrace) {
        debugPrint("Error listening to categories: $error");
        emit(state.copyWith(listStatus: .failure));
      }
    );
  }

  /// Watches categories along with their usage count and updates the state accordingly
  /// Handles errors by updating the state to reflect an error status
  void _watchCategoriesWithCount(WatchCategoriesWithCount event, Emitter<CategoriesState> emit) async {
    await emit.onEach(
        categoriesRepository.watchCategoriesWithUseCount(),
        onData: (data) {
          emit(
              state.copyWith(
                  listStatus: .success,
                  categoriesWithCount: data
              )
          );
        },
        onError: (error, stackTrace) {
          debugPrint("Error listening to categories with count: $error");
          emit(state.copyWith(listStatus: .failure));
        }
    );
  }

  /// Deletes a category based on the provided event
  /// Updates the state to reflect any deletion errors
  void _deleteCategory(DeleteCategory event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(categoryDeletionStatus: .initial));
    try {
      String categoryId = event.selectedCategoryId;
      // Perform deletion
      await categoriesRepository.deleteCategory(categoryId);
      emit(state.copyWith(categoryDeletionStatus: .success));
    } catch (error) {
      emit(state.copyWith(categoryDeletionStatus: .failure));
      debugPrint("Error deleting category: $error");
    }
  }
}