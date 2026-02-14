import 'package:breathe/core/architecture/responsive_breakpoints.dart';
import 'package:breathe/core/architecture/state_controller.dart';
import 'package:flutter/material.dart' hide View;

abstract class ControlAwareState<View extends StatefulWidget>
    extends State<View> {
  final StateController controller;

  ControlAwareState(this.controller) {
    controller.refreshUICallback = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  Widget get desktopView;

  Widget get tabletView;

  Widget get mobileView;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        if (maxWidth <= ResponsiveBreakpoints.mobileBreakpoint) {
          return mobileView;
        } else if (maxWidth <= ResponsiveBreakpoints.tabletBreakpoint) {
          return tabletView;
        } else {
          return desktopView;
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
