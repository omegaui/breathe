import 'dart:async';

import 'package:breathe/core/architecture/interfaces/observer.dart';
import 'package:breathe/core/architecture/interfaces/use_case.dart';

abstract class CompletableUseCase<A, R> extends UseCase<A, R> {
  StreamSubscription<R>? subscription;

  @override
  Future<StreamSubscription<R>?> execute(A params, Observer<R> observer) async {
    Stream<R> stream = await buildStream(params);
    subscription = stream.listen((event) {
      observer.emit(event);
    });
    subscription!.onError((e) async {
      observer.error(e);
      await subscription!.cancel();
    });
    subscription!.onDone(() async {
      observer.complete();
    });

    return subscription;
  }

  void dispose() {
    subscription?.cancel();
  }
}
