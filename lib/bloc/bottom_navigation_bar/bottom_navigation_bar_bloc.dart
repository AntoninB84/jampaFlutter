
import 'package:flutter_bloc/flutter_bloc.dart';

enum BottomNavigationBarEvent {
  notes,
  settings
}

class BottomNavigationBarBloc extends Bloc<BottomNavigationBarEvent, int> {
  BottomNavigationBarBloc() : super(0) {
    on<BottomNavigationBarEvent>((event, emit) {
      switch (event) {
        case BottomNavigationBarEvent.notes:
          emit(0);
          break;
        case BottomNavigationBarEvent.settings:
          emit(1);
          break;
      }
    });
  }
}