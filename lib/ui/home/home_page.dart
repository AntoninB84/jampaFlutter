
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/bottom_navigation_bar/bottom_navigation_bar_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationBarBloc(),
      child: Scaffold(
        body: BlocListener<BottomNavigationBarBloc, int>(
          listener: (context, state) {
            navigationShell.goBranch(state);
          },
          child: navigationShell
        ),
        bottomNavigationBar: BlocBuilder<BottomNavigationBarBloc, int>(
          builder: (context, currentIndex) {
            return BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                context.read<BottomNavigationBarBloc>().add(BottomNavigationBarEvent.values[index]);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            );
          },
        ),
      ),
    );
  }
}