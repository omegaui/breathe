import 'package:breathe/core/architecture/interfaces/disposable.dart';
import 'package:breathe/core/architecture/state_machine.dart';
import 'package:breathe/core/architecture/state_presenter.dart';

class StateController<Presenter, Event, State> implements Disposable {
  final StateMachine<Event, State> _stateMachine;
  final Presenter _presenter;
  late final void Function() refreshUICallback;
  bool _initialized = false;

  Presenter get presenter => _presenter;
  bool get isInitialized => _initialized;

  StateController({
    required StateMachine<Event, State> stateMachine,
    required StatePresenter presenter,
  })  : _stateMachine = stateMachine,
        _presenter = presenter as Presenter;

  void markInitialized() {
    _initialized = true;
  }

  void onEvent(Event e) {
    _stateMachine.changeStateOnEvent(e);
    refreshUICallback.call();
  }

  State getCurrentState() {
    return _stateMachine.currentState;
  }

  @override
  void dispose() {
    _initialized = false;
    (_presenter as StatePresenter).dispose();
  }

  T stateAs<T>() {
    return getCurrentState() as T;
  }
}
