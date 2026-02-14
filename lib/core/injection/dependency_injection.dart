import 'package:breathe/core/services/storage/shared_storage.dart';
import 'package:breathe/core/services/storage/shared_storage_impl.dart';
import 'package:breathe/features/exercise/presentation/excercise_state_presenter.dart';
import 'package:breathe/features/home/presentation/home_state_presenter.dart';
import 'package:breathe/features/init/presentation/ini_state_presenter.dart';
import 'package:get/get.dart';

class DependencyInjection {
  DependencyInjection._();

  static void init() async {
    Get.put<SharedStorage>(SharedStorageImpl(), permanent: true);
    Get.put<InitStatePresenter>(InitStatePresenter());
    Get.put<HomeStatePresenter>(HomeStatePresenter());
    Get.put<ExcerciseStatePresenter>(ExcerciseStatePresenter());
  }
}
