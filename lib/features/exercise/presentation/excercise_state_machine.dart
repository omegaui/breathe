import 'package:breathe/core/architecture/state_machine.dart';
import 'package:breathe/features/exercise/domain/entity/excercise_settings_entity.dart';

class ExcerciseEvent {}

class ExcerciseLoadingEvent extends ExcerciseEvent {}

class ExcerciseLoadedEvent extends ExcerciseEvent {
  final ExcerciseSettingsEntity settings;

  ExcerciseLoadedEvent({required this.settings});
}

class ExcerciseState {}

class ExcerciseLoadingState extends ExcerciseState {}

class ExcerciseLoadedState extends ExcerciseState {
  final ExcerciseSettingsEntity settings;

  ExcerciseLoadedState({required this.settings});
}

class ExcerciseStateMachine
    extends StateMachine<ExcerciseEvent, ExcerciseState> {
  ExcerciseStateMachine() : super(ExcerciseLoadingState());

  @override
  void changeStateOnEvent(ExcerciseEvent e) {
    switch (e.runtimeType) {
      case const (ExcerciseLoadingEvent):
        currentState = ExcerciseLoadingState();
        break;
      case const (ExcerciseLoadedEvent):
        currentState = ExcerciseLoadedState(
          settings: (e as ExcerciseLoadedEvent).settings,
        );
        break;
    }
  }
}
