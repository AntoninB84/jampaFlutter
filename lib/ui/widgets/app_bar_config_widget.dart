import 'package:flutter/widgets.dart';
import 'package:jampa_flutter/utils/service_locator.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../bloc/home/app_bar_cubit.dart';

class AppBarConfigWidget extends StatefulWidget {
  final AppBarConfig config;
  final Widget child;
  final bool resetOnDispose;

  const AppBarConfigWidget({
    super.key,
    required this.config,
    required this.child,
    this.resetOnDispose = true,
  });

  @override
  State<AppBarConfigWidget> createState() => _AppBarConfigWidgetState();
}

class _AppBarConfigWidgetState extends State<AppBarConfigWidget> {
  late final AppBarCubit _cubit;
  final UniqueKey _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<AppBarCubit>();
    // Wait for first frame to avoid interfering with navigation during route transition
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _cubit.set(widget.config);
      }
    });
  }

  @override
  void didUpdateWidget(covariant AppBarConfigWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _cubit.set(widget.config);
    }
  }

  @override
  void dispose() {
    if (widget.resetOnDispose) {
      _cubit.clear();
    }
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    // visible fraction > 0 means it's visible on screen
    if (info.visibleFraction > 0) {
      _cubit.set(widget.config);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: _onVisibilityChanged,
      child: widget.child
    );
  }
}