import 'package:breathe/core/services/storage/shared_storage.dart';
import 'package:breathe/core/services/storage/shared_storage_impl.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_presenter.dart';
import 'package:breathe/features/home/presentation/home_state_presenter.dart';
import 'package:breathe/features/init/presentation/init_state_presenter.dart';
import 'package:get/get.dart';

class DependencyInjection {
  DependencyInjection._();

  static void init() {
    Get.put<SharedStorage>(SharedStorageImpl(), permanent: true);
    Get.put<InitStatePresenter>(InitStatePresenter());
    Get.put<HomeStatePresenter>(HomeStatePresenter());
    Get.put<ExerciseStatePresenter>(ExerciseStatePresenter());
  }
}
