import 'package:breathe/common/states/unknown_state_view.dart';
import 'package:breathe/core/architecture/control_aware_state.dart';
import 'package:breathe/features/exercise/domain/entity/excercise_settings_entity.dart';
import 'package:breathe/features/exercise/presentation/excercise_state_controller.dart';
import 'package:breathe/features/exercise/presentation/excercise_state_machine.dart';
import 'package:breathe/features/exercise/presentation/states/excercise_loaded_state_view.dart';
import 'package:breathe/features/exercise/presentation/states/excercise_loading_state_view.dart';
import 'package:flutter/material.dart';

class ExcerciseStateView extends StatefulWidget {
  const ExcerciseStateView({super.key, required this.settings});

  final ExcerciseSettingsEntity settings;

  @override
  State<ExcerciseStateView> createState() => _ExcerciseStateViewState();
}

class _ExcerciseStateViewState extends ControlAwareState<ExcerciseStateView> {
  _ExcerciseStateViewState() : super(ExcerciseStateController());

  @override
  Widget get desktopView {
    final controller = this.controller as ExcerciseStateController;
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case const (ExcerciseLoadingState):
        controller.initialize(settings: widget.settings);
        return ExcerciseLoadingStateView(
          state: controller.stateAs<ExcerciseLoadingState>(),
          controller: controller,
        );
      case const (ExcerciseLoadedState):
        return ExcerciseLoadedStateView(
          state: controller.stateAs<ExcerciseLoadedState>(),
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
