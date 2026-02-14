abstract class Observer<T> {
  void error(Error e);

  void complete();

  void emit(T? t);
}
