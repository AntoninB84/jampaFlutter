import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/constants/styles/sizes.dart';
import '../home/widgets/settings_menu.dart';
import 'buttons/buttons.dart';

/// A Scaffolded AppBar widget with a logo in the center.
///
/// If no leading or actions widgets are provided, it defaults to
/// a back button on the left, and a settings menu on the right.
///
/// The body of the Scaffold can be customized by passing a widget to the [body] parameter.
class JampaScaffoldedAppBarWidget extends StatefulWidget implements PreferredSizeWidget {

  /// The leading widget to display on the left side of the AppBar.
  final Widget? leading;

  /// The actions widgets to display on the right side of the AppBar.
  final List<Widget>? actions;

  /// The body of the Scaffold.
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
      body: SafeArea(
        minimum: EdgeInsets.symmetric(
            horizontal: kGap16,
            vertical: kGap4
        ),
        child: widget.body ?? kEmptyWidget
      ),
    );
  }
}