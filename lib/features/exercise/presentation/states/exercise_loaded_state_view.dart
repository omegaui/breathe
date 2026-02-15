import 'package:breathe/common/styling/app_text_theme.dart';
import 'package:breathe/common/styling/app_theme.dart';
import 'package:breathe/config/app_assets.dart';
import 'package:breathe/features/exercise/domain/breathing_session.dart';
import 'package:breathe/features/exercise/domain/enums/exercise_states.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_controller.dart';
import 'package:breathe/features/exercise/presentation/exercise_state_machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

class ExerciseLoadedStateView extends StatefulWidget {
  const ExerciseLoadedStateView({
    super.key,
    required this.state,
    required this.controller,
  });

  final ExerciseLoadedState state;
  final ExerciseStateController controller;

  @override
  State<ExerciseLoadedStateView> createState() =>
      _ExerciseLoadedStateViewState();
}

class _ExerciseLoadedStateViewState extends State<ExerciseLoadedStateView> {
  late final AudioPlayer _soundPlayer;
  late final BreathingSession _session;

  @override
  void initState() {
    super.initState();
    _soundPlayer = AudioPlayer();
    if (widget.state.settings.allowSound) {
      _soundPlayer.setAudioSource(
        AudioSource.asset(AppAssets.chimeSound),
      );
    }
    _session = BreathingSession(
      settings: widget.state.settings,
      onUpdate: () {
        if (mounted) setState(() {});
      },
      onRoundComplete: () {
        if (widget.state.settings.allowSound) {
          _soundPlayer.seek(Duration.zero).then((_) => _soundPlayer.play());
        }
      },
      onSessionComplete: () {},
    );
    _session.start();
  }

  @override
  Widget build(BuildContext context) {
    final snap = _session.snapshot;
    final insets = MediaQuery.paddingOf(context);
    final colors = context.colors;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: colors.backgroundColor,
      primary: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: colors.homePageBackgroundDecoration,
            ),
          ),
          if (snap.phase != ExerciseStates.complete) ...[
            Align(
              child: Padding(
                padding: EdgeInsets.only(
                  top: insets.top,
                  bottom: insets.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snap.encouragementText,
                      style: ConfigurableTextStyle.create(FontSizes.small)
                          .makeItalic()
                          .useLato()
                          .withColor(colors.textSubtitle),
                    ),
                    const Gap(91),
                    SizedBox.square(
                      dimension: 196,
                      child: Center(
                        child: AnimatedContainer(
                          duration: 1000.ms,
                          width: 196 * snap.bubbleScale,
                          height: 196 * snap.bubbleScale,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                colors.bubbleColor.withAlpha(
                                  (0.20 * 255).round(),
                                ),
                                colors.bubbleColor.withAlpha(
                                  (0.05 * 255).round(),
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: colors.bubbleBorderColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${snap.bubbleTime}',
                              style: ConfigurableTextStyle.create(
                                FontSizes.xlarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(53),
                    Text(
                      snap.phaseTitle,
                      style: ConfigurableTextStyle.create(
                        FontSizes.large,
                      ).withColor(colors.textTitle).makeBold(),
                    ),
                    const Gap(6),
                    Text(
                      snap.phaseSubTitle,
                      style: ConfigurableTextStyle.create(
                        FontSizes.small,
                      ).withColor(colors.textSubtitle),
                    ),
                    const Gap(36),
                    SizedBox(
                      width: 240,
                      height: 8,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: snap.indicatorProgress),
                        duration: 250.ms,
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            key: ValueKey(value),
                            color: colors.primary,
                            backgroundColor: colors.indicatorBackground,
                            value: value,
                            borderRadius: BorderRadius.circular(20),
                          );
                        },
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Cycles ${snap.currentRound} of ${widget.state.settings.rounds}',
                      style: ConfigurableTextStyle.create(
                        FontSizes.small,
                      ).withColor(colors.primary),
                    ),
                    const Gap(40),
                    FilledButton.tonal(
                      onPressed: () => _session.togglePause(),
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.indicatorBackground,
                        fixedSize: const Size(131, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(
                            image: snap.isPaused
                                ? AppAssets.play
                                : AppAssets.pause,
                            width: 24,
                          ),
                          const Gap(8),
                          Text(
                            snap.isPaused ? 'Resume' : 'Pause',
                            style: ConfigurableTextStyle.create(
                              FontSizes.regular,
                            ).makeBold().withColor(
                                  colors.buttonTextColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Align(
              child: Padding(
                padding: EdgeInsets.only(
                  top: insets.top,
                  bottom: insets.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.square(
                      dimension: 150,
                      child: Lottie.asset(
                        AppAssets.completionAnimation,
                        repeat: false,
                      ),
                    ),
                    const Gap(24),
                    Text(
                      'You did it! \u{1F389}',
                      style: ConfigurableTextStyle.create(
                        FontSizes.large,
                      ).makeBold().withColor(colors.textTitle),
                    ),
                    const Gap(16),
                    Text(
                      'Great rounds of calm, just like that. Your\nmind thanks you.',
                      textAlign: TextAlign.center,
                      style: ConfigurableTextStyle.create(
                        FontSizes.small,
                      ).withColor(colors.textSubtitle),
                    ),
                    const Gap(24),
                    FilledButton(
                      onPressed: () => _session.start(),
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        fixedSize: const Size(271, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Start again",
                            style:
                                ConfigurableTextStyle.create(FontSizes.base)
                                    .withColor(colors.backgroundColor)
                                    .useLato()
                                    .makeBold(),
                          ),
                          const Gap(8),
                          Image(
                            image: AppAssets.fastWind,
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                    OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: colors.backgroundColor,
                        fixedSize: const Size(131, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        side: BorderSide.none,
                      ),
                      child: Text(
                        'Back to set up',
                        style: ConfigurableTextStyle.create(
                          FontSizes.regular,
                        ).makeBold().withColor(colors.textTitle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: insets.top, bottom: insets.bottom),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, top: 18),
                child: IconButton(
                  onPressed: () => Get.back(),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.borderColor,
                  ),
                  icon: Icon(
                    Icons.close,
                    color: colors.textSubtitle,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: insets.top, bottom: insets.bottom),
              child: Padding(
                padding: const EdgeInsets.only(right: 35, top: 18),
                child: IconButton(
                  onPressed: () => AppTheme.toggle(),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.borderColor,
                  ),
                  icon: Image(
                    image: context.isLightMode
                        ? AppAssets.darkMode
                        : AppAssets.lightMode,
                    width: 20.07,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _session.dispose();
    _soundPlayer.dispose();
    super.dispose();
  }
}
