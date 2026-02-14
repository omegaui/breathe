import 'package:breathe/core/architecture/state_machine.dart';

class InitEvent {}

class InitStartedEvent extends InitEvent {}

class InitState {}

class InitStartedState extends InitState {}

class InitStateMachine extends StateMachine<InitEvent, InitState> {
  InitStateMachine() : super(InitStartedState());

  @override
  void changeStateOnEvent(InitEvent e) {
    switch (e.runtimeType) {
      case const (InitStartedEvent):
        currentState = InitStartedState();
        break;
    }
  }
}
