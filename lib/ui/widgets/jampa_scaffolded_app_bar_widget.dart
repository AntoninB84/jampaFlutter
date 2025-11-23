import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home/widgets/settings_menu.dart';
import 'buttons/buttons.dart';

class JampaScaffoldedAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? body;

  const JampaScaffoldedAppBarWidget({
    super.key,
    this.leading,
    this.actions,
    this.body,
  });

  @override
  State<JampaScaffoldedAppBarWidget> createState() => _JampaScaffoldedAppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _JampaScaffoldedAppBarWidgetState extends State<JampaScaffoldedAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png", height: 30,),
        centerTitle: true,
        leading: widget.leading ?? Buttons.backButtonIcon(
            context: context,
            onPressed: (){
              if(context.canPop()){
                context.pop();
              }
            }
        ),
        actions: widget.actions ?? [
          SettingsMenu().settingsMenu(context),
        ],
      ),
      body: widget.body,
    );
  }
}