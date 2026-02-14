import 'package:breathe/core/architecture/state_controller.dart';
import 'package:breathe/core/services/routing/routing.dart';
import 'package:breathe/features/exercise/domain/entity/excercise_settings_entity.dart';
import 'package:breathe/features/home/presentation/home_state_machine.dart';
import 'package:breathe/features/home/presentation/home_state_presenter.dart';
import 'package:get/get.dart';

class HomeStateController extends StateController {
  HomeStateController()
    : super(
        stateMachine: HomeStateMachine(),
        presenter: Get.find<HomeStatePresenter>(),
      );

  void initialize() async {
    // nothing to do in here yet :)
  }

  void start(ExcerciseSettingsEntity settings) {
    RouteService.goto(Routes.excercise, arguments: {'settings': settings});
  }
}
