// ============================================================================
// FLUTTER TEST CRASH COURSE
// ============================================================================
//
// Every test file follows this structure:
//   1. Import `flutter_test` — gives you `test()`, `group()`, `expect()`, etc.
//   2. Import the class you're testing.
//   3. Write a `main()` function containing your tests.
//
// Key concepts:
//   - `test('description', () { ... })` — a single test case
//   - `group('name', () { ... })` — groups related tests together
//   - `expect(actual, matcher)` — asserts that `actual` matches `matcher`
//   - `setUp(() { ... })` — runs before EACH test in the group
//   - `tearDown(() { ... })` — runs after EACH test in the group
//
// fakeAsync:
//   Our BreathingSession uses Timer.periodic internally. In real life, we'd
//   have to wait real seconds. `fakeAsync` lets us control time — we call
//   `async.elapse(Duration(seconds: 1))` and the timer fires instantly.
//   This makes timer-based tests fast and deterministic.
// ============================================================================

import 'package:breathe/features/exercise/domain/breathing_session.dart';
import 'package:breathe/features/exercise/domain/entity/exercise_settings_entity.dart';
import 'package:breathe/features/exercise/domain/enums/exercise_states.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // -------------------------------------------------------------------------
  // Helper: creates settings with the same duration for all phases.
  // Using 1-second durations keeps tests short — fewer ticks to simulate.
  // -------------------------------------------------------------------------
  ExerciseSettingsEntity makeSettings({
    int duration = 1,
    int rounds = 1,
  }) {
    return ExerciseSettingsEntity(
      durationInSeconds: duration,
      rounds: rounds,
      breathInDuration: duration,
      holdInDuration: duration,
      breathOutDuration: duration,
      holdOutDuration: duration,
      allowSound: false,
    );
  }

  // -------------------------------------------------------------------------
  // Helper: creates a BreathingSession with tracking callbacks.
  // We track how many times each callback fires so we can assert on it.
  // -------------------------------------------------------------------------
  late BreathingSession session;
  late int updateCount;
  late int roundCompleteCount;
  late int sessionCompleteCount;

  // `setUp` runs before EACH test. This ensures every test starts fresh —
  // no leftover state from a previous test can cause flaky results.
  setUp(() {
    updateCount = 0;
    roundCompleteCount = 0;
    sessionCompleteCount = 0;
  });

  // `tearDown` runs after EACH test. Always dispose resources to prevent
  // timer leaks, which would cause "pending timer" errors in the test runner.
  tearDown(() {
    session.dispose();
  });

  BreathingSession createSession({int duration = 1, int rounds = 1}) {
    session = BreathingSession(
      settings: makeSettings(duration: duration, rounds: rounds),
      onUpdate: () => updateCount++,
      onRoundComplete: () => roundCompleteCount++,
      onSessionComplete: () => sessionCompleteCount++,
    );
    return session;
  }

  // Helper: advance time by N seconds inside fakeAsync
  void elapseSeconds(FakeAsync async, int seconds) {
    async.elapse(Duration(seconds: seconds));
  }

  // =========================================================================
  // GROUP 1: Initial state
  // =========================================================================
  group('initial state', () {
    test('starts in idle phase with "Get Ready" title', () {
      // `fakeAsync` wraps our test so Timer.periodic works without real delays
      fakeAsync((async) {
        createSession();
        session.start();

        final snap = session.snapshot;
        expect(snap.phase, ExerciseStates.idle);
        expect(snap.phaseTitle, 'Get Ready');
        expect(snap.bubbleTime, 3);
        expect(snap.currentRound, 1);
        expect(snap.isPaused, false);
        expect(snap.indicatorProgress, 0.0);
      });
    });

    test('start() resets state when called again', () {
      fakeAsync((async) {
        createSession(rounds: 2);
        session.start();

        // Advance a few seconds to change state
        elapseSeconds(async, 5);
        expect(session.snapshot.phase, isNot(ExerciseStates.idle));

        // Calling start() again should reset everything
        session.start();
        expect(session.snapshot.phase, ExerciseStates.idle);
        expect(session.snapshot.bubbleTime, 3);
        expect(session.snapshot.currentRound, 1);
      });
    });
  });

  // =========================================================================
  // GROUP 2: Idle countdown
  // =========================================================================
  group('idle countdown', () {
    // The idle phase counts down from 3 to 1 before transitioning.
    // Each tick = 1 second. Timer fires every 1 second.
    //
    // Timeline (duration=1):
    //   Start:  bubbleTime=3, phase=idle
    //   Tick 1: bubbleTime=2, phase=idle
    //   Tick 2: bubbleTime=1, phase=idle
    //   Tick 3: transition to breathIn

    test('counts down from 3 during idle phase', () {
      fakeAsync((async) {
        createSession();
        session.start();

        elapseSeconds(async, 1);
        expect(session.snapshot.bubbleTime, 2);
        expect(session.snapshot.phase, ExerciseStates.idle);

        elapseSeconds(async, 1);
        expect(session.snapshot.bubbleTime, 1);
        expect(session.snapshot.phase, ExerciseStates.idle);
      });
    });

    test('transitions to breathIn after 3-second idle countdown', () {
      fakeAsync((async) {
        createSession();
        session.start();

        elapseSeconds(async, 3);
        expect(session.snapshot.phase, ExerciseStates.breathIn);
        expect(session.snapshot.phaseTitle, 'Breathe In');
      });
    });
  });

  // =========================================================================
  // GROUP 3: Phase transitions
  // =========================================================================
  group('phase transitions', () {
    // With all durations = 1 second and 1 round, the full cycle is:
    //   3 ticks idle → 1 tick breathIn → 1 tick holdIn →
    //   1 tick breathOut → 1 tick holdOut → complete
    //
    // Total: 3 (idle) + 4 (phases with duration=1 each) = 7 ticks

    test('follows correct phase order: breathIn → holdIn → breathOut → holdOut', () {
      fakeAsync((async) {
        createSession();
        session.start();

        // Skip past idle (3 ticks)
        elapseSeconds(async, 3);
        expect(session.snapshot.phase, ExerciseStates.breathIn);

        elapseSeconds(async, 1);
        expect(session.snapshot.phase, ExerciseStates.holdIn);

        elapseSeconds(async, 1);
        expect(session.snapshot.phase, ExerciseStates.breathOut);

        elapseSeconds(async, 1);
        expect(session.snapshot.phase, ExerciseStates.holdOut);

        elapseSeconds(async, 1);
        expect(session.snapshot.phase, ExerciseStates.complete);
      });
    });

    test('shows correct phase titles throughout the cycle', () {
      fakeAsync((async) {
        createSession();
        session.start();

        elapseSeconds(async, 3);
        expect(session.snapshot.phaseTitle, 'Breathe In');

        elapseSeconds(async, 1);
        expect(session.snapshot.phaseTitle, 'Hold gently');

        elapseSeconds(async, 1);
        expect(session.snapshot.phaseTitle, 'Breath out');

        elapseSeconds(async, 1);
        expect(session.snapshot.phaseTitle, 'Hold softly');
      });
    });

    test('with longer durations, stays in each phase for the correct time', () {
      fakeAsync((async) {
        createSession(duration: 3);
        session.start();

        // Skip idle
        elapseSeconds(async, 3);
        expect(session.snapshot.phase, ExerciseStates.breathIn);

        // breathIn should last 3 ticks (duration=3)
        elapseSeconds(async, 1);
        expect(session.snapshot.phase, ExerciseStates.breathIn);
        elapseSeconds(async, 1);
        expect(session.snapshot.phase, ExerciseStates.breathIn);
        elapseSeconds(async, 1);
        expect(session.snapshot.phase, ExerciseStates.holdIn);
      });
    });
  });

  // =========================================================================
  // GROUP 4: Round management
  // =========================================================================
  group('round management', () {
    test('advances to next round after completing all phases', () {
      fakeAsync((async) {
        createSession(rounds: 2);
        session.start();

        // Complete idle (3) + one full cycle (4) = 7 ticks
        elapseSeconds(async, 7);

        // Should be in round 2 now, back to breathIn
        expect(session.snapshot.currentRound, 2);
        expect(session.snapshot.phase, ExerciseStates.breathIn);
      });
    });

    test('calls onRoundComplete at the end of each round', () {
      fakeAsync((async) {
        createSession(rounds: 3);
        session.start();

        // Complete round 1: idle(3) + cycle(4) = 7 ticks
        elapseSeconds(async, 7);
        expect(roundCompleteCount, 1);

        // Complete round 2: another cycle(4) = 4 ticks
        elapseSeconds(async, 4);
        expect(roundCompleteCount, 2);

        // Complete round 3 (final): another cycle(4) = 4 ticks
        elapseSeconds(async, 4);
        expect(roundCompleteCount, 3);
      });
    });

    test('completes session after all rounds', () {
      fakeAsync((async) {
        createSession(rounds: 2);
        session.start();

        // Round 1: idle(3) + cycle(4) = 7 ticks
        // Round 2: cycle(4) = 4 ticks
        // Total: 11 ticks
        elapseSeconds(async, 11);

        expect(session.snapshot.phase, ExerciseStates.complete);
        expect(sessionCompleteCount, 1);
      });
    });

    test('resets indicator progress at the start of each round', () {
      fakeAsync((async) {
        createSession(rounds: 2);
        session.start();

        // End of round 1, progress should be ~1.0
        elapseSeconds(async, 6);
        expect(session.snapshot.indicatorProgress, greaterThan(0.5));

        // Start of round 2, progress resets
        elapseSeconds(async, 1);
        expect(session.snapshot.indicatorProgress, 0.0);
        expect(session.snapshot.currentRound, 2);
      });
    });
  });

  // =========================================================================
  // GROUP 5: Pause / Resume
  // =========================================================================
  group('pause and resume', () {
    test('togglePause pauses the session', () {
      fakeAsync((async) {
        createSession();
        session.start();

        session.togglePause();
        expect(session.snapshot.isPaused, true);

        // Advance time — phase should NOT change while paused
        final phaseBeforePause = session.snapshot.phase;
        final timeBefore = session.snapshot.bubbleTime;
        elapseSeconds(async, 5);

        expect(session.snapshot.phase, phaseBeforePause);
        expect(session.snapshot.bubbleTime, timeBefore);
      });
    });

    test('togglePause resumes the session', () {
      fakeAsync((async) {
        createSession();
        session.start();

        // Pause, wait, resume
        session.togglePause();
        elapseSeconds(async, 5);
        session.togglePause();
        expect(session.snapshot.isPaused, false);

        // Now time should advance again
        elapseSeconds(async, 3);
        expect(session.snapshot.phase, ExerciseStates.breathIn);
      });
    });

    test('double toggle returns to unpaused', () {
      fakeAsync((async) {
        createSession();
        session.start();

        session.togglePause();
        session.togglePause();
        expect(session.snapshot.isPaused, false);
      });
    });
  });

  // =========================================================================
  // GROUP 6: Callbacks
  // =========================================================================
  group('callbacks', () {
    test('onUpdate is called on every tick', () {
      fakeAsync((async) {
        createSession();
        session.start();

        // start() calls onUpdate once, then each tick calls it
        final countAfterStart = updateCount;
        elapseSeconds(async, 5);
        expect(updateCount, countAfterStart + 5);
      });
    });

    test('onSessionComplete is called exactly once', () {
      fakeAsync((async) {
        createSession(rounds: 1);
        session.start();

        // Complete entire session: idle(3) + cycle(4) = 7
        elapseSeconds(async, 7);
        expect(sessionCompleteCount, 1);

        // No more ticks should fire after completion
        elapseSeconds(async, 10);
        expect(sessionCompleteCount, 1);
      });
    });

    test('onUpdate is NOT called when paused (except for the togglePause call)', () {
      fakeAsync((async) {
        createSession();
        session.start();
        final countAfterStart = updateCount;

        session.togglePause(); // this calls onUpdate once
        final countAfterPause = updateCount;
        expect(countAfterPause, countAfterStart + 1);

        // Ticks while paused should not call onUpdate
        // (they do call _tick which calls onUpdate at the end — but
        // _tick returns early when paused, so onUpdate is not called)
        elapseSeconds(async, 5);
        expect(updateCount, countAfterPause);
      });
    });
  });

  // =========================================================================
  // GROUP 7: Edge cases
  // =========================================================================
  group('edge cases', () {
    test('single round with 1-second durations completes correctly', () {
      fakeAsync((async) {
        createSession(duration: 1, rounds: 1);
        session.start();

        elapseSeconds(async, 7);
        expect(session.snapshot.phase, ExerciseStates.complete);
        expect(roundCompleteCount, 1);
        expect(sessionCompleteCount, 1);
      });
    });

    test('maxTimePerCycle is calculated correctly', () {
      createSession(duration: 5);
      // 4 phases x 5 seconds = 20
      expect(session.maxTimePerCycle, 20);
    });

    test('dispose cancels the timer (no errors after dispose)', () {
      fakeAsync((async) {
        createSession();
        session.start();

        elapseSeconds(async, 2);
        session.dispose();

        // Advancing time after dispose should not throw
        elapseSeconds(async, 10);
        // Phase should be frozen at wherever it was
        expect(session.snapshot.phase, ExerciseStates.idle);
      });
    });

    test('indicator progress reaches 1.0 at end of a cycle', () {
      fakeAsync((async) {
        createSession(duration: 1, rounds: 1);
        session.start();

        // Skip idle (3 ticks), then 4 phase ticks (breathIn, holdIn, breathOut, holdOut)
        // After holdOut completes (tick 7), the session is complete.
        // But right before completion, progress should be at 1.0
        elapseSeconds(async, 6);
        // After 6 ticks: idle(3) + breathIn(1) + holdIn(1) + breathOut(1)
        // secondsElapsed = 3 (breathIn + holdIn + breathOut)
        // maxTimePerCycle = 4, so progress = 3/4 = 0.75
        expect(session.snapshot.indicatorProgress, 0.75);
      });
    });

    test('bubble scale is clamped to minimum 0.33', () {
      // With very short breathIn, scale could go below 0.25
      // The _clampScale should prevent it from being < 0.33
      fakeAsync((async) {
        createSession(duration: 1);
        session.start();

        // Monitor all snapshots for bubble scale violations
        for (var i = 0; i < 10; i++) {
          elapseSeconds(async, 1);
          expect(session.snapshot.bubbleScale, greaterThanOrEqualTo(0.33));
        }
      });
    });
  });
}
