import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';

import '../../data/models/category.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({
    required this.categoriesRepository
  }) : super(const CategoriesState()) {
    on<GetCategories>(_mapGetCategoriesEventToState);
    on<WatchCategories>(_watchCategories);
    on<DeleteCategory>(_deleteCategory);
  }
  final CategoriesRepository categoriesRepository;
  
  void _mapGetCategoriesEventToState(GetCategories event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(listStatus: CategoriesListStatus.loading));
    try{
      final categories = await categoriesRepository.getCategories();
      emit(
        state.copyWith(
            listStatus: CategoriesListStatus.success,
            categories: categories
        )
      );
    } catch (error, stacktrace) {
      debugPrintStack(stackTrace: stacktrace);
      emit(state.copyWith(listStatus: CategoriesListStatus.error));
    }
  }

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

  void _deleteCategory(DeleteCategory event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(deletionError: false));
    try {
      int categoryId = event.selectedCategoryId;
      await categoriesRepository.deleteCategory(categoryId);
    } catch (error) {
      emit(state.copyWith(deletionError: true));
      debugPrint("Error deleting category: $error");
    }
  }
}