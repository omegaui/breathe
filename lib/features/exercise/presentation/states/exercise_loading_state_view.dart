import 'package:breathe/common/styling/app_theme.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_controller.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_machine.dart';
import 'package:flutter/material.dart';

class ExerciseLoadingStateView extends StatefulWidget {
  const ExerciseLoadingStateView({
    super.key,
    required this.state,
    required this.controller,
  });

  final ExerciseLoadingState state;
  final ExerciseStateController controller;

  @override
  State<ExerciseLoadingStateView> createState() =>
      _ExerciseLoadingStateViewState();
}

class _ExerciseLoadingStateViewState extends State<ExerciseLoadingStateView> {
  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: context.colors.backgroundColor,
      primary: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: context.colors.homePageBackgroundDecoration,
            ),
          ),
          Align(
            child: Padding(
              padding: EdgeInsets.only(top: insets.top, bottom: insets.bottom),
              child: Center(
                child: CircularProgressIndicator(
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
