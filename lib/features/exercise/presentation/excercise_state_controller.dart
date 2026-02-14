import 'package:breathe/config/app_assets.dart';
import 'package:breathe/core/architecture/state_controller.dart';
import 'package:breathe/features/exercise/domain/entity/excercise_settings_entity.dart';
import 'package:breathe/features/exercise/presentation/excercise_state_machine.dart';
import 'package:breathe/features/exercise/presentation/excercise_state_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExcerciseStateController extends StateController {
  ExcerciseStateController()
    : super(
        stateMachine: ExcerciseStateMachine(),
        presenter: Get.find<ExcerciseStatePresenter>(),
      );

  void initialize({required ExcerciseSettingsEntity settings}) async {
    await Future.wait([
      precacheImage(AppAssets.play, Get.context!),
      precacheImage(AppAssets.pause, Get.context!),
    ]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onEvent(ExcerciseLoadedEvent(settings: settings));
    });
  }
}
