import 'package:flutter/foundation.dart';

class ErrorTracker {
  ErrorTracker._();

  static void track(Object error, StackTrace trace) {
    if (kDebugMode) {
      debugPrint("An error occurred: $error\n$trace");
    } else {
      // TODO: Implement Sentry or any other error tracker
    }
  }
}
