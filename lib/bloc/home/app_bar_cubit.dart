
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarConfig {
  final Widget? leading;
  final List<Widget>? actions;

  const AppBarConfig({this.leading, this.actions});

  static const empty = AppBarConfig();
}

class AppBarCubit extends Cubit<AppBarConfig> {
  AppBarCubit() : super(AppBarConfig.empty);

  void set(AppBarConfig config) {
    emit(config);
  }
  void clear() {
    emit(AppBarConfig.empty);
  }
}