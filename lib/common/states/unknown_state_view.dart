import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UnknownStateView extends StatelessWidget {
  const UnknownStateView({super.key, this.state});

  final dynamic state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          kDebugMode
              ? "An Unknown State Encountered: ${state.runtimeType}, please implement this state first."
              : "Sorry, some error occurred, please try again, if the issue persist, please contact us.",
          textAlign: .center,
        ),
      ),
    );
  }
}
