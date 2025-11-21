import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../data/models/category.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(const CategoriesState()) {
    on<WatchCategories>(_watchCategories);
    on<WatchCategoriesWithCount>(_watchCategoriesWithCount);
    on<DeleteCategory>(_deleteCategory);
  }
  final CategoriesRepository categoriesRepository =
        serviceLocator<CategoriesRepository>();

  void _watchCategories(WatchCategories event, Emitter<CategoriesState> emit) async {
    await emit.onEach(
        categoriesRepository.watchAllCategories(),
        onData: (data) {
          emit(
            state.copyWith(
              listStatus: CategoriesListStatus.success,
              categories: data
            )
          );
        },
      onError: (error, stackTrace) {
        debugPrint("Error listening to categories: $error");
        emit(state.copyWith(listStatus: CategoriesListStatus.error));
      }
    );
  }

  void _watchCategoriesWithCount(WatchCategoriesWithCount event, Emitter<CategoriesState> emit) async {
    await emit.onEach(
        categoriesRepository.watchCategoriesWithUseCount(),
        onData: (data) {
          emit(
              state.copyWith(
                  listStatus: CategoriesListStatus.success,
                  categoriesWithCount: data
              )
          );
        },
        onError: (error, stackTrace) {
          debugPrint("Error listening to categories with count: $error");
          emit(state.copyWith(listStatus: CategoriesListStatus.error));
        }
    );
  }

  void _deleteCategory(DeleteCategory event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(deletionError: false));
    try {
      String categoryId = event.selectedCategoryId;
      await categoriesRepository.deleteCategory(categoryId);
    } catch (error) {
      emit(state.copyWith(deletionError: true));
      debugPrint("Error deleting category: $error");
    }
  }
}