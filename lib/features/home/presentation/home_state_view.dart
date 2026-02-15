import 'package:breathe/common/states/unknown_state_view.dart';
import 'package:breathe/core/architecture/control_aware_state.dart';
import 'package:breathe/features/home/presentation/home_state_controller.dart';
import 'package:breathe/features/home/presentation/home_state_machine.dart';
import 'package:breathe/features/home/presentation/states/home_loaded_state_view.dart';
import 'package:flutter/material.dart';

class HomeStateView extends StatefulWidget {
  const HomeStateView({super.key});

  @override
  State<HomeStateView> createState() => _HomeStateViewState();
}

class _HomeStateViewState extends ControlAwareState<HomeStateView> {
  _HomeStateViewState() : super(HomeStateController());

  @override
  Widget get desktopView {
    final controller = this.controller as HomeStateController;
    final currentState = controller.getCurrentState();
    controller.initialize();
    switch (currentState) {
      case HomeLoadedState():
        return HomeLoadedStateView(
          state: controller.stateAs<HomeLoadedState>(),
          controller: controller,
        );
      default:
        return UnknownStateView(state: currentState);
    }
  }

  @override
  Widget get mobileView => desktopView;

  @override
  Widget get tabletView => desktopView;
}
