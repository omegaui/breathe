import 'package:breathe/core/architecture/state_controller.dart';
import 'package:breathe/core/services/routing/routing.dart';
import 'package:breathe/features/exercise/domain/entity/exercise_settings_entity.dart';
import 'package:breathe/features/home/presentation/home_state_machine.dart';
import 'package:breathe/features/home/presentation/home_state_presenter.dart';
import 'package:get/get.dart';

class HomeStateController extends StateController {
  HomeStateController()
    : super(
        stateMachine: HomeStateMachine(),
        presenter: Get.find<HomeStatePresenter>(),
      );

  void initialize() {
    if (isInitialized) return;
    markInitialized();
  }

  void start(ExerciseSettingsEntity settings) {
    RouteService.goto(Routes.exercise, arguments: {'settings': settings});
  }
}
