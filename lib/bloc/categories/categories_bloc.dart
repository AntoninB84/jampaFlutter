import 'package:equatable/equatable.dart';
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
  }
  final CategoriesRepository categoriesRepository;
  
  void _mapGetCategoriesEventToState(GetCategories event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    try{
      final categories = await categoriesRepository.getCategories();
      emit(
        state.copyWith(
            status: CategoriesStatus.success,
            categories: categories
        )
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: CategoriesStatus.error));
    }
  }
}