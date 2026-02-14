import 'package:breathe/core/architecture/state_machine.dart';

class HomeEvent {}

class HomeLoadedEvent extends HomeEvent {}

class HomeState {}

class HomeLoadedState extends HomeState {}

class HomeStateMachine extends StateMachine<HomeEvent, HomeState> {
  HomeStateMachine() : super(HomeLoadedState());

  @override
  void changeStateOnEvent(HomeEvent e) {
    switch (e.runtimeType) {
      case const (HomeLoadedEvent):
        currentState = HomeLoadedState();
        break;
    }
  }
}
