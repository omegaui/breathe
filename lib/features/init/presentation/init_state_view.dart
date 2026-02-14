import 'package:breathe/common/states/unknown_state_view.dart';
import 'package:breathe/core/architecture/control_aware_state.dart';
import 'package:breathe/features/init/presentation/init_state_controller.dart';
import 'package:breathe/features/init/presentation/init_state_machine.dart';
import 'package:breathe/features/init/presentation/states/init_started_state_view.dart';
import 'package:flutter/material.dart';

class InitStateView extends StatefulWidget {
  const InitStateView({super.key});

  @override
  State<InitStateView> createState() => _InitStateViewState();
}

class _InitStateViewState extends ControlAwareState<InitStateView> {
  _InitStateViewState() : super(InitStateController());

  @override
  Widget get desktopView {
    final controller = this.controller as InitStateController;
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case const (InitStartedState):
        controller.initialize();
        return InitStartedStateView(
          state: controller.stateAs<InitStartedState>(),
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
