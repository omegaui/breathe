import 'package:breathe/common/styling/app_text_theme.dart';
import 'package:breathe/common/styling/app_theme.dart';
import 'package:breathe/config/app_assets.dart';
import 'package:breathe/features/init/presentation/init_state_controller.dart';
import 'package:breathe/features/init/presentation/init_state_machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class InitStartedStateView extends StatelessWidget {
  const InitStartedStateView({
    super.key,
    required this.state,
    required this.controller,
  });

  final InitStartedState state;
  final InitStateController controller;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.instance.backgroundColor,
      body: Stack(
        children: [
          Align(
            child: Padding(
              padding: EdgeInsets.only(top: insets.top, bottom: insets.bottom),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  SizedBox(width: 196, child: Image.asset(AppAssets.logo))
                      .animate(onComplete: (e) => e.repeat())
                      .shimmer(delay: 400.ms, duration: 1000.ms),
                  Gap(4),
                  Text(
                    "Breathe",
                    style: ConfigurableTextStyle.create(FontSizes.large),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
