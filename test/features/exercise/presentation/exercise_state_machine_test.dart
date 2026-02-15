// ============================================================================
// UNIT TESTING A STATE MACHINE
// ============================================================================
//
// State machine tests are the simplest kind of test — no timers, no UI,
// no async. You just:
//   1. Create the state machine
//   2. Fire an event
//   3. Assert the resulting state
//
// These are "pure logic" tests. If you can only write one kind of test,
// start here — they're the fastest to write and the most valuable per line.
// ============================================================================

import 'package:breathe/features/exercise/domain/entity/exercise_settings_entity.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_machine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ExerciseStateMachine machine;

  setUp(() {
    machine = ExerciseStateMachine();
  });

  group('ExerciseStateMachine', () {
    test('starts in ExerciseLoadingState', () {
      // The initial state is set in the constructor: super(ExerciseLoadingState())
      expect(machine.currentState, isA<ExerciseLoadingState>());
    });

    test('transitions to ExerciseLoadedState on ExerciseLoadedEvent', () {
      final settings = ExerciseSettingsEntity.initial();

      machine.changeStateOnEvent(ExerciseLoadedEvent(settings: settings));

      expect(machine.currentState, isA<ExerciseLoadedState>());
      // Verify the settings are passed through correctly
      final loadedState = machine.currentState as ExerciseLoadedState;
      expect(loadedState.settings.rounds, settings.rounds);
      expect(loadedState.settings.breathInDuration, settings.breathInDuration);
    });

    test('transitions back to ExerciseLoadingState on ExerciseLoadingEvent', () {
      final settings = ExerciseSettingsEntity.initial();

      // First go to loaded
      machine.changeStateOnEvent(ExerciseLoadedEvent(settings: settings));
      expect(machine.currentState, isA<ExerciseLoadedState>());

      // Then back to loading
      machine.changeStateOnEvent(ExerciseLoadingEvent());
      expect(machine.currentState, isA<ExerciseLoadingState>());
    });

    test('ExerciseLoadedState carries the correct settings', () {
      final settings = ExerciseSettingsEntity(
        durationInSeconds: 5,
        rounds: 3,
        breathInDuration: 5,
        holdInDuration: 4,
        breathOutDuration: 6,
        holdOutDuration: 3,
        allowSound: false,
      );

      machine.changeStateOnEvent(ExerciseLoadedEvent(settings: settings));

      final state = machine.currentState as ExerciseLoadedState;
      expect(state.settings.durationInSeconds, 5);
      expect(state.settings.rounds, 3);
      expect(state.settings.holdInDuration, 4);
      expect(state.settings.breathOutDuration, 6);
      expect(state.settings.holdOutDuration, 3);
      expect(state.settings.allowSound, false);
    });
  });
}
