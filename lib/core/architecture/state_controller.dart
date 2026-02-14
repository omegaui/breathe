import 'package:breathe/core/architecture/interfaces/disposable.dart';
import 'package:breathe/core/architecture/state_machine.dart';
import 'package:breathe/core/architecture/state_presenter.dart';

class StateController<Presenter, Event, State> implements Disposable {
  final StateMachine<Event, State> _stateMachine;
  final Presenter _presenter;
  late final void Function() refreshUICallback;

  Presenter get presenter => _presenter;

  StateController({
    required StateMachine<Event, State> stateMachine,
    required StatePresenter presenter,
  })  : _stateMachine = stateMachine,
        _presenter = presenter as Presenter;

  void onEvent(Event e) {
    _stateMachine.changeStateOnEvent(e);
    refreshUICallback.call();
  }

  State getCurrentState() {
    return _stateMachine.currentState;
  }

  @override
  void dispose() {
    (_presenter as StatePresenter).dispose();
  }

  T stateAs<T>() {
    return getCurrentState() as T;
  }
}
