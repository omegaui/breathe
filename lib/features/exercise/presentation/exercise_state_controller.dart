import 'package:breathe/config/app_assets.dart';
import 'package:breathe/core/architecture/state_controller.dart';
import 'package:breathe/features/exercise/domain/entity/exercise_settings_entity.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_machine.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseStateController extends StateController {
  ExerciseStateController()
    : super(
        stateMachine: ExerciseStateMachine(),
        presenter: Get.find<ExerciseStatePresenter>(),
      );

  void initialize({required ExerciseSettingsEntity settings}) async {
    if (isInitialized) return;
    markInitialized();
    await Future.wait([
      precacheImage(AppAssets.play, Get.context!),
      precacheImage(AppAssets.pause, Get.context!),
    ]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onEvent(ExerciseLoadedEvent(settings: settings));
    });
  }
}
