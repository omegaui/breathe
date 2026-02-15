import 'package:breathe/core/services/routing/routes.dart';
import 'package:breathe/features/exercise/domain/entity/exercise_settings_entity.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_view.dart';
import 'package:breathe/features/home/presentation/home_state_view.dart';
import 'package:breathe/features/init/presentation/init_state_view.dart';
import 'package:get/get.dart';

class RouteService {
  RouteService._();

  static final List<GetPage> pages = [
    GetPage(name: Routes.init, page: () => InitStateView()),
    GetPage(name: Routes.home, page: () => HomeStateView()),
    GetPage(
      name: Routes.exercise,
      page: () {
        return ExerciseStateView(
          settings: Get.arguments['settings'] as ExerciseSettingsEntity,
        );
      },
    ),
  ];

  static void goto(
    String page, {
    bool dropAll = false,
    dynamic arguments,
    Map<String, String>? parameter,
  }) {
    if (dropAll) {
      Get.offNamed(page, arguments: arguments, parameters: parameter);
    } else {
      Get.toNamed(page, arguments: arguments, parameters: parameter);
    }
  }
}
