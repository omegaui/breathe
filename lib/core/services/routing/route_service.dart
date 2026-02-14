import 'package:breathe/core/services/routing/routes.dart';
import 'package:breathe/features/exercise/domain/entity/excercise_settings_entity.dart';
import 'package:breathe/features/exercise/presentation/excercise_state_view.dart';
import 'package:breathe/features/home/presentation/home_state_view.dart';
import 'package:breathe/features/init/presentation/init_state_view.dart';
import 'package:get/get.dart';

class RouteService {
  RouteService._();

  static final List<GetPage> pages = [
    GetPage(name: Routes.init, page: () => InitStateView()),
    GetPage(name: Routes.home, page: () => HomeStateView()),
    GetPage(
      name: Routes.excercise,
      page: () {
        return ExcerciseStateView(
          settings: Get.arguments['settings'] as ExcerciseSettingsEntity,
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
