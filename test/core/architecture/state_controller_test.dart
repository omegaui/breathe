// ============================================================================
// TESTING WITH FAKES
// ============================================================================
//
// StateController depends on a StateMachine and a StatePresenter.
// In unit tests, we don't want to use real implementations — we want
// to isolate the code under test.
//
// Solution: create minimal "fake" implementations right here in the test file.
// These are NOT mocks (no mocking library needed). They're simple classes
// that implement the interface with the minimum behavior we need.
//
// This is the simplest form of test doubles — no external packages required.
// ============================================================================

import 'package:breathe/core/architecture/state_controller.dart';
import 'package:breathe/core/architecture/state_machine.dart';
import 'package:breathe/core/architecture/state_presenter.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fakes: minimal implementations for testing
// ---------------------------------------------------------------------------

class FakeEvent {}

class FakeState {}

class FakeStateMachine extends StateMachine<FakeEvent, FakeState> {
  int changeStateCallCount = 0;

  FakeStateMachine() : super(FakeState());

  @override
  void changeStateOnEvent(FakeEvent e) {
    changeStateCallCount++;
  }
}

class FakePresenter extends StatePresenter {
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
  }
}

void main() {
  late StateController controller;
  late FakeStateMachine machine;
  late FakePresenter presenter;
  int refreshCallCount = 0;

  setUp(() {
    machine = FakeStateMachine();
    presenter = FakePresenter();
    refreshCallCount = 0;
    controller = StateController(
      stateMachine: machine,
      presenter: presenter,
    );
    // The controller needs a refreshUICallback — in real code this is set
    // by ControlAwareState. In tests, we provide a simple counter.
    controller.refreshUICallback = () => refreshCallCount++;
  });

  group('initialization guard', () {
    test('isInitialized is false by default', () {
      expect(controller.isInitialized, false);
    });

    test('markInitialized sets isInitialized to true', () {
      controller.markInitialized();
      expect(controller.isInitialized, true);
    });

    test('dispose resets isInitialized to false', () {
      controller.markInitialized();
      controller.dispose();
      expect(controller.isInitialized, false);
    });
  });

  group('event handling', () {
    test('onEvent delegates to state machine', () {
      controller.onEvent(FakeEvent());
      expect(machine.changeStateCallCount, 1);
    });

    test('onEvent triggers refreshUICallback', () {
      controller.onEvent(FakeEvent());
      expect(refreshCallCount, 1);
    });

    test('multiple events all reach the state machine', () {
      controller.onEvent(FakeEvent());
      controller.onEvent(FakeEvent());
      controller.onEvent(FakeEvent());
      expect(machine.changeStateCallCount, 3);
      expect(refreshCallCount, 3);
    });
  });

  group('dispose', () {
    test('dispose calls presenter.dispose()', () {
      controller.dispose();
      expect(presenter.disposed, true);
    });
  });

  group('state access', () {
    test('getCurrentState returns the state machine current state', () {
      final state = controller.getCurrentState();
      expect(state, isA<FakeState>());
    });

    test('stateAs casts to the requested type', () {
      final state = controller.stateAs<FakeState>();
      expect(state, isA<FakeState>());
    });
  });
}
