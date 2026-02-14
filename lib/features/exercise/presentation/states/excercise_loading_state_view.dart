import 'package:breathe/common/styling/app_theme.dart';
import 'package:breathe/features/exercise/presentation/excercise_state_controller.dart';
import 'package:breathe/features/exercise/presentation/excercise_state_machine.dart';
import 'package:flutter/material.dart';

class ExcerciseLoadingStateView extends StatefulWidget {
  const ExcerciseLoadingStateView({
    super.key,
    required this.state,
    required this.controller,
  });

  final ExcerciseLoadingState state;
  final ExcerciseStateController controller;

  @override
  State<ExcerciseLoadingStateView> createState() =>
      _ExcerciseLoadingStateViewState();
}

class _ExcerciseLoadingStateViewState extends State<ExcerciseLoadingStateView> {
  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.instance.backgroundColor,
      primary: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: AppTheme.instance.homePageBackgroundDecoration,
            ),
          ),
          Align(
            child: Padding(
              padding: EdgeInsets.only(top: insets.top, bottom: insets.bottom),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.instance.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
