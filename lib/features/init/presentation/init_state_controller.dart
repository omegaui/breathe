import 'package:breathe/common/styling/app_theme.dart';
import 'package:breathe/config/app_assets.dart';
import 'package:breathe/core/architecture/state_controller.dart';
import 'package:breathe/core/services/routing/routing.dart';
import 'package:breathe/core/services/storage/shared_storage.dart';
import 'package:breathe/features/init/presentation/ini_state_presenter.dart';
import 'package:breathe/features/init/presentation/init_state_machine.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class InitStateController extends StateController {
  InitStateController()
    : super(
        stateMachine: InitStateMachine(),
        presenter: Get.find<InitStatePresenter>(),
      );

  void initialize() async {
    // initialize storage
    final storage = Get.find<SharedStorage>();
    await storage.init();
    // initialize theme
    final theme = storage.get<String>('theme', fallback: 'light');
    AppTheme.init(theme == 'light');
    // precache assets
    await Future.wait([
      precacheImage(AppAssets.arrowDown, Get.context!),
      precacheImage(AppAssets.arrowUp, Get.context!),
      precacheImage(AppAssets.fastWind, Get.context!),
      precacheImage(AppAssets.darkMode, Get.context!),
      precacheImage(AppAssets.lightMode, Get.context!),
      precacheImage(AppAssets.lightBackground, Get.context!),
    ]);
    // show home
    RouteService.goto(Routes.home, dropAll: true);
  }
}
