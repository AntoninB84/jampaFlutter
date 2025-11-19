import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/home/widgets/settings_menu.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';

import '../../../bloc/home/app_bar_cubit.dart';
import '../../../utils/service_locator.dart';

class JampaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const JampaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return
      BlocProvider<AppBarCubit>.value(
        value: serviceLocator<AppBarCubit>(),
        child: BlocBuilder<AppBarCubit, AppBarConfig>(
          builder: (context, state) {
            return AppBar(
              title: Image.asset("assets/images/logo.png", height: 30,),
              centerTitle: true,
              leading: state.leading ?? Buttons.backButtonIcon(
                context: context,
                onPressed: (){
                  if(context.canPop()){
                    context.pop();
                  }
                }
              ),
              actions: state.actions ?? [
                SettingsMenu().settingsMenu(context),
              ],
            );
          },
        ),
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}