import 'dart:async';

import 'package:breathe/common/styling/app_text_theme.dart';
import 'package:breathe/common/styling/app_theme.dart';
import 'package:breathe/config/app_assets.dart';
import 'package:breathe/features/exercise/domain/enums/excercise_states.dart';
import 'package:breathe/features/exercise/presentation/excercise_state_controller.dart';
import 'package:breathe/features/exercise/presentation/excercise_state_machine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

class ExcerciseLoadedStateView extends StatefulWidget {
  const ExcerciseLoadedStateView({
    super.key,
    required this.state,
    required this.controller,
  });

  final ExcerciseLoadedState state;
  final ExcerciseStateController controller;

  @override
  State<ExcerciseLoadedStateView> createState() =>
      _ExcerciseLoadedStateViewState();
}

class _ExcerciseLoadedStateViewState extends State<ExcerciseLoadedStateView> {
  final _soundPlayer = AudioPlayer();

  var _bubbleScale = 1.0;
  var _bubbleTime = 3;

  var _phaseEncouragementText = '';
  var _phaseTitle = 'Get Ready';
  var _phaseSubTitle = 'Get going on your breathing session';

  var _isPaused = false;
  var _currentState = ExcerciseStates.idle;
  var _currentRound = 1;
  var _indicatorProgress = 0.0;
  var _secondsElapsed = 0;

  int get maxTimePerCycle =>
      widget.state.settings.breathInDuration +
      widget.state.settings.holdInDuration +
      widget.state.settings.breathOutDuration +
      widget.state.settings.holdOutDuration;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.state.settings.allowSound) {
      _soundPlayer.setAudioSource(
        AudioSource.asset(AppAssets.chimeSound),
      ); // no need to await file is small
    }
    _startTimer();
    AppTheme.watchToggle(watchThemeChanges);
  }

  void watchThemeChanges() {
    // refresh state on theme changes
    widget.controller.refreshUICallback();
  }

  void _startTimer() {
    setState(() {
      _currentRound = 1;
      _secondsElapsed = 0;
      _bubbleTime = 3;
      _indicatorProgress = 0;
      _bubbleScale = 1.0;
      _currentState = ExcerciseStates.idle;
      _phaseEncouragementText = '';
      _phaseTitle = 'Get Ready';
      _phaseSubTitle = 'Get going on your breathing session';
    });
    _timer = Timer.periodic(1000.ms, (timer) {
      _handleState();
    });
  }

  void _handleState() {
    if (_isPaused) {
      // ignore updates
      return;
    }
    if (_currentState == ExcerciseStates.idle) {
      if (_bubbleTime > 1) {
        setState(() {
          _bubbleTime--;
          // No need to update bubble scale when not yet started
          // _bubbleScale = (_bubbleTime / 3);
        });
      } else {
        setState(() {
          _currentState = ExcerciseStates.breathIn;
          _bubbleTime = widget.state.settings.breathInDuration;
          _bubbleScale = 1;
          _phaseTitle = 'Breathe In';
          _phaseSubTitle = 'nice and slow';
          _phaseEncouragementText = "You're a natural";
        });
      }
    } else {
      // every update which does not involves the idle state
      // we update the indicator progress
      _secondsElapsed++;
      _indicatorProgress = (_secondsElapsed / maxTimePerCycle).toDouble();
      if (_currentState == ExcerciseStates.breathIn) {
        if (_bubbleTime > 1) {
          setState(() {
            _bubbleTime--;
            _bubbleScale =
                (_bubbleTime / widget.state.settings.breathInDuration);
          });
        } else {
          setState(() {
            _currentState = ExcerciseStates.holdIn;
            _bubbleTime = widget.state.settings.holdInDuration;
            _phaseTitle = 'Hold gently';
            _phaseSubTitle = 'nice and slow';
            _phaseEncouragementText = "So peaceful right now";
          });
        }
      } else if (_currentState == ExcerciseStates.holdIn) {
        if (_bubbleTime > 1) {
          setState(() {
            _bubbleTime--;
          });
        } else {
          setState(() {
            _currentState = ExcerciseStates.breathOut;
            _bubbleTime = widget.state.settings.breathOutDuration;
            _phaseTitle = 'Breath out';
            _phaseSubTitle = 'nice and slow';
            _phaseEncouragementText = "Look at you go";
          });
        }
      } else if (_currentState == ExcerciseStates.breathOut) {
        if (_bubbleTime > 1) {
          setState(() {
            _bubbleTime--;
            var nextScale =
                1 - (_bubbleTime / widget.state.settings.breathOutDuration);
            if (nextScale < _bubbleScale) {
              nextScale += 0.4;
            }
            _bubbleScale = nextScale;
          });
        } else {
          setState(() {
            _currentState = ExcerciseStates.holdOut;
            _bubbleTime = widget.state.settings.holdOutDuration;
            _phaseTitle = 'Hold softly';
            _phaseSubTitle = 'just be here';
            _phaseEncouragementText = "Nothing to fix, just hold";
            _bubbleScale = 1.0;
          });
        }
      } else if (_currentState == ExcerciseStates.holdOut) {
        if (_bubbleTime > 1) {
          setState(() {
            _bubbleTime--;
            _bubbleScale = 1;
          });
        } else {
          if (widget.state.settings.allowSound) {
            Future(() async {
              await _soundPlayer.seek(Duration.zero);
              await _soundPlayer.play();
            });
          }
          if (_currentRound == widget.state.settings.rounds) {
            _timer?.cancel();
            setState(() {
              _currentState = ExcerciseStates.complete;
            });
          } else {
            setState(() {
              _currentState = ExcerciseStates.breathIn;
              _bubbleTime = widget.state.settings.breathInDuration;
              _phaseTitle = 'Breathe In';
              _phaseSubTitle = 'nice and slow';
              _currentRound++;
              _secondsElapsed = 0;
              _indicatorProgress = 0;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint(
        "[Bubble State] phase: $_phaseTitle time: $_bubbleTime, scale: $_bubbleScale, round: $_currentRound, progress: ${_secondsElapsed}s, max: $maxTimePerCycle, progress: $_indicatorProgress",
      );
    }
    if (_bubbleScale <= 0.25) {
      _bubbleScale = 0.33;
    }
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
          if (_currentState != ExcerciseStates.complete) ...[
            Align(
              child: Padding(
                padding: EdgeInsets.only(
                  top: insets.top,
                  bottom: insets.bottom,
                ),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      _phaseEncouragementText,
                      style: ConfigurableTextStyle.create(FontSizes.small)
                          .makeItalic()
                          .useLato()
                          .withColor(AppTheme.instance.textSubtitle),
                    ),
                    Gap(91),
                    SizedBox.square(
                      dimension: 196,
                      child: Center(
                        child: AnimatedContainer(
                          duration: 1000.ms,
                          width: 196 * _bubbleScale,
                          height: 196 * _bubbleScale,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.instance.bubbleColor.withAlpha(
                                  (0.20 * 255).round(),
                                ),
                                AppTheme.instance.bubbleColor.withAlpha(
                                  (0.05 * 255).round(),
                                ),
                              ],
                            ),
                            borderRadius: .circular(100),
                            border: Border.all(
                              color: AppTheme.instance.bubbleBorderColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$_bubbleTime',
                              style: ConfigurableTextStyle.create(
                                FontSizes.xlarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(53),
                    Text(
                      _phaseTitle,
                      style: ConfigurableTextStyle.create(
                        FontSizes.large,
                      ).withColor(AppTheme.instance.textTitle).makeBold(),
                    ),
                    Gap(6),
                    Text(
                      _phaseSubTitle,
                      style: ConfigurableTextStyle.create(
                        FontSizes.small,
                      ).withColor(AppTheme.instance.textSubtitle),
                    ),
                    Gap(36),
                    SizedBox(
                      width: 240,
                      height: 8,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: _indicatorProgress),
                        duration: 250.ms,
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            key: ValueKey(value),
                            color: AppTheme.instance.primary,
                            backgroundColor:
                                AppTheme.instance.indicatorBackground,
                            value: value,
                            borderRadius: .circular(20),
                          );
                        },
                      ),
                    ),
                    Gap(8),
                    Text(
                      'Cycles $_currentRound of ${widget.state.settings.rounds}',
                      style: ConfigurableTextStyle.create(
                        FontSizes.small,
                      ).withColor(AppTheme.instance.primary),
                    ),
                    Gap(40),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPaused = !_isPaused;
                        });
                      },
                      child: Container(
                        width: 131,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.instance.indicatorBackground,
                          borderRadius: .circular(32),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: .min,
                            children: [
                              Image(
                                image: _isPaused
                                    ? AppAssets.play
                                    : AppAssets.pause,
                                width: 24,
                              ),
                              Gap(8),
                              Text(
                                _isPaused ? 'Resume' : 'Pause',
                                style:
                                    ConfigurableTextStyle.create(
                                      FontSizes.regular,
                                    ).makeBold().withColor(
                                      AppTheme.instance.buttonTextColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
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
                  mainAxisAlignment: .center,
                  children: [
                    SizedBox.square(
                      dimension: 150,
                      child: Lottie.asset(
                        AppAssets.completionAnimation,
                        repeat: false,
                      ),
                    ),
                    Gap(24),
                    Text(
                      'You did it! 🎉',
                      style: ConfigurableTextStyle.create(
                        FontSizes.large,
                      ).makeBold().withColor(AppTheme.instance.textTitle),
                    ),
                    Gap(16),
                    Text(
                      'Great rounds of calm, just like that. Your\nmind thanks you.',
                      textAlign: .center,
                      style: ConfigurableTextStyle.create(
                        FontSizes.small,
                      ).withColor(AppTheme.instance.textSubtitle),
                    ),
                    Gap(24),
                    GestureDetector(
                      onTap: () {
                        _startTimer();
                      },
                      child: Container(
                        width: 271,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.instance.primary,
                          borderRadius: .circular(32),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: .min,
                            children: [
                              Text(
                                "Start again",
                                style:
                                    ConfigurableTextStyle.create(FontSizes.base)
                                        .withColor(
                                          AppTheme.instance.backgroundColor,
                                        )
                                        .useLato()
                                        .makeBold(),
                              ),
                              Gap(8),
                              Image(
                                image: AppAssets.fastWind,
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(24),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: 131,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.instance.backgroundColor,
                          borderRadius: .circular(32),
                        ),
                        child: Center(
                          child: Text(
                            'Back to set up',
                            style: ConfigurableTextStyle.create(
                              FontSizes.regular,
                            ).makeBold().withColor(AppTheme.instance.textTitle),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          Align(
            alignment: .topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: insets.top, bottom: insets.bottom),
              child: Padding(
                padding: .only(left: 24, top: 18),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.instance.borderColor,
                  ),
                  icon: Icon(
                    Icons.close,
                    color: AppTheme.instance.textSubtitle,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: .topRight,
            child: Padding(
              padding: EdgeInsets.only(top: insets.top, bottom: insets.bottom),
              child: Padding(
                padding: .only(right: 35, top: 18),
                child: IconButton(
                  onPressed: () => AppTheme.toggle(),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.instance.borderColor,
                  ),
                  icon: Image(
                    image: AppTheme.isLight
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
    _timer?.cancel();
    _soundPlayer.dispose();
    AppTheme.unwatchToggle(watchThemeChanges);
    super.dispose();
  }
}
