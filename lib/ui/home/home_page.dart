
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../bloc/bottom_navigation_bar/bottom_navigation_bar_bloc.dart';
import '../../repository/categories_repository.dart';
import '../../repository/note_types_repository.dart';
import '../../repository/notes_list_view_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CategoriesRepository(),
        ),
        RepositoryProvider(
          create: (context) => NoteTypesRepository(),
        ),
        RepositoryProvider(
          create: (context) => NotesListViewRepository(),
        ),
        RepositoryProvider(
          create: (context) => NotesRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => BottomNavigationBarBloc(),
        child: Scaffold(
          body: BlocListener<BottomNavigationBarBloc, int>(
            listener: (context, state) {
              navigationShell.goBranch(state);
            },
            child: SafeArea(child: navigationShell)
          ),
          bottomNavigationBar: BlocBuilder<BottomNavigationBarBloc, int>(
            builder: (context, currentIndex) {
              return BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  context.read<BottomNavigationBarBloc>().add(BottomNavigationBarEvent.values[index]);
                },
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.notes), label: context.strings.notes),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: context.strings.settings),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}