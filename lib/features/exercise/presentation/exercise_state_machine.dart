import 'package:breathe/core/architecture/state_machine.dart';
import 'package:breathe/features/exercise/domain/entity/exercise_settings_entity.dart';

class ExerciseEvent {}

class ExerciseLoadingEvent extends ExerciseEvent {}

class ExerciseLoadedEvent extends ExerciseEvent {
  final ExerciseSettingsEntity settings;

  ExerciseLoadedEvent({required this.settings});
}

class ExerciseState {}

class ExerciseLoadingState extends ExerciseState {}

class ExerciseLoadedState extends ExerciseState {
  final ExerciseSettingsEntity settings;

  ExerciseLoadedState({required this.settings});
}

class ExerciseStateMachine
    extends StateMachine<ExerciseEvent, ExerciseState> {
  ExerciseStateMachine() : super(ExerciseLoadingState());

  @override
  void changeStateOnEvent(ExerciseEvent e) {
    switch (e) {
      case ExerciseLoadingEvent():
        currentState = ExerciseLoadingState();
      case ExerciseLoadedEvent(:final settings):
        currentState = ExerciseLoadedState(settings: settings);
    }
  }
}
