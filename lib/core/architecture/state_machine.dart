abstract class StateMachine<Event, State> {
  State currentState;

  StateMachine(this.currentState);

  void changeStateOnEvent(Event e);
}
