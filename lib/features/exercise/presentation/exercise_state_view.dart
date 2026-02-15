import 'package:breathe/common/states/unknown_state_view.dart';
import 'package:breathe/core/architecture/control_aware_state.dart';
import 'package:breathe/features/exercise/domain/entity/exercise_settings_entity.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_controller.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_machine.dart';
import 'package:breathe/features/exercise/presentation/states/exercise_loaded_state_view.dart';
import 'package:breathe/features/exercise/presentation/states/exercise_loading_state_view.dart';
import 'package:flutter/material.dart';

class ExerciseStateView extends StatefulWidget {
  const ExerciseStateView({super.key, required this.settings});

  final ExerciseSettingsEntity settings;

  @override
  State<ExerciseStateView> createState() => _ExerciseStateViewState();
}

class _ExerciseStateViewState extends ControlAwareState<ExerciseStateView> {
  _ExerciseStateViewState() : super(ExerciseStateController());

  @override
  Widget get desktopView {
    final controller = this.controller as ExerciseStateController;
    final currentState = controller.getCurrentState();
    controller.initialize(settings: widget.settings);
    switch (currentState) {
      case ExerciseLoadingState():
        return ExerciseLoadingStateView(
          state: controller.stateAs<ExerciseLoadingState>(),
          controller: controller,
        );
      case ExerciseLoadedState():
        return ExerciseLoadedStateView(
          state: controller.stateAs<ExerciseLoadedState>(),
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
