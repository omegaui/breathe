import 'package:breathe/core/architecture/interfaces/observer.dart';
import 'package:flutter/foundation.dart';

class UseCaseObserver<T> extends Observer<T> {
  final String name;
  final VoidCallback? onComplete;
  final VoidCallback? onError;
  final void Function(T? t) onEmit;

  UseCaseObserver({
    required this.name,
    this.onComplete,
    this.onError,
    required this.onEmit,
  });

  @override
  void complete() {
    onComplete?.call();
    debugPrint("[$name] UseCaseObserver completed");
  }

  @override
  void emit(T? t) {
    onEmit(t);
    debugPrint("[$name] UseCaseObserver emitted: $t");
  }

  @override
  void error(Error e) {
    onError?.call();
    debugPrint("[$name] ran into some error.");
  }
}
