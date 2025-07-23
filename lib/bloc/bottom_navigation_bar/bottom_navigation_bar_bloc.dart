
import 'package:flutter_bloc/flutter_bloc.dart';

enum BottomNavigationBarEvent {
  home,
  search,
  notifications,
  profile,
}

class BottomNavigationBarBloc extends Bloc<BottomNavigationBarEvent, int> {
  BottomNavigationBarBloc() : super(0) {
    on<BottomNavigationBarEvent>((event, emit) {
      switch (event) {
        case BottomNavigationBarEvent.home:
          emit(0);
          break;
        case BottomNavigationBarEvent.search:
          emit(1);
          break;
        case BottomNavigationBarEvent.notifications:
          emit(2);
          break;
        case BottomNavigationBarEvent.profile:
          emit(3);
          break;
      }
    });
  }
}