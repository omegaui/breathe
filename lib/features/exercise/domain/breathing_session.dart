import 'dart:async';

import 'package:breathe/features/exercise/domain/entity/exercise_settings_entity.dart';
import 'package:breathe/features/exercise/domain/enums/exercise_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BreathingSessionSnapshot {
  final ExerciseStates phase;
  final int bubbleTime;
  final double bubbleScale;
  final String phaseTitle;
  final String phaseSubTitle;
  final String encouragementText;
  final bool isPaused;
  final int currentRound;
  final double indicatorProgress;

  const BreathingSessionSnapshot({
    required this.phase,
    required this.bubbleTime,
    required this.bubbleScale,
    required this.phaseTitle,
    required this.phaseSubTitle,
    required this.encouragementText,
    required this.isPaused,
    required this.currentRound,
    required this.indicatorProgress,
  });
}

class BreathingSession {
  final ExerciseSettingsEntity settings;
  final VoidCallback onUpdate;
  final VoidCallback onRoundComplete;
  final VoidCallback onSessionComplete;

  Timer? _timer;
  var _bubbleScale = 1.0;
  var _bubbleTime = 3;
  var _phaseEncouragementText = '';
  var _phaseTitle = 'Get Ready';
  var _phaseSubTitle = 'Get going on your breathing session';
  var _isPaused = false;
  var _currentState = ExerciseStates.idle;
  var _currentRound = 1;
  var _indicatorProgress = 0.0;
  var _secondsElapsed = 0;

  BreathingSession({
    required this.settings,
    required this.onUpdate,
    required this.onRoundComplete,
    required this.onSessionComplete,
  });

  int get maxTimePerCycle =>
      settings.breathInDuration +
      settings.holdInDuration +
      settings.breathOutDuration +
      settings.holdOutDuration;

  BreathingSessionSnapshot get snapshot => BreathingSessionSnapshot(
        phase: _currentState,
        bubbleTime: _bubbleTime,
        bubbleScale: _bubbleScale,
        phaseTitle: _phaseTitle,
        phaseSubTitle: _phaseSubTitle,
        encouragementText: _phaseEncouragementText,
        isPaused: _isPaused,
        currentRound: _currentRound,
        indicatorProgress: _indicatorProgress,
      );

  void start() {
    _timer?.cancel();
    _currentRound = 1;
    _secondsElapsed = 0;
    _bubbleTime = 3;
    _indicatorProgress = 0;
    _bubbleScale = 1.0;
    _currentState = ExerciseStates.idle;
    _phaseEncouragementText = '';
    _phaseTitle = 'Get Ready';
    _phaseSubTitle = 'Get going on your breathing session';
    _isPaused = false;
    onUpdate();
    _timer = Timer.periodic(1000.ms, (_) => _tick());
  }

  void togglePause() {
    _isPaused = !_isPaused;
    onUpdate();
  }

  double _clampScale(double scale) => scale <= 0.25 ? 0.33 : scale;

  void _tick() {
    if (_isPaused) return;
    switch (_currentState) {
      case ExerciseStates.idle:
        if (_bubbleTime > 1) {
          _bubbleTime--;
        } else {
          _currentState = ExerciseStates.breathIn;
          _bubbleTime = settings.breathInDuration;
          _bubbleScale = 1;
          _phaseTitle = 'Breathe In';
          _phaseSubTitle = 'nice and slow';
          _phaseEncouragementText = "You're a natural";
        }
      case ExerciseStates.breathIn:
        _secondsElapsed++;
        _indicatorProgress = _secondsElapsed / maxTimePerCycle;
        if (_bubbleTime > 1) {
          _bubbleTime--;
          _bubbleScale = _clampScale(
            _bubbleTime / settings.breathInDuration,
          );
        } else {
          _currentState = ExerciseStates.holdIn;
          _bubbleTime = settings.holdInDuration;
          _phaseTitle = 'Hold gently';
          _phaseSubTitle = 'nice and slow';
          _phaseEncouragementText = "So peaceful right now";
        }
      case ExerciseStates.holdIn:
        _secondsElapsed++;
        _indicatorProgress = _secondsElapsed / maxTimePerCycle;
        if (_bubbleTime > 1) {
          _bubbleTime--;
        } else {
          _currentState = ExerciseStates.breathOut;
          _bubbleTime = settings.breathOutDuration;
          _phaseTitle = 'Breath out';
          _phaseSubTitle = 'nice and slow';
          _phaseEncouragementText = "Look at you go";
        }
      case ExerciseStates.breathOut:
        _secondsElapsed++;
        _indicatorProgress = _secondsElapsed / maxTimePerCycle;
        if (_bubbleTime > 1) {
          _bubbleTime--;
          var nextScale = 1 - (_bubbleTime / settings.breathOutDuration);
          if (nextScale < _bubbleScale) {
            nextScale += 0.4;
          }
          _bubbleScale = _clampScale(nextScale);
        } else {
          _currentState = ExerciseStates.holdOut;
          _bubbleTime = settings.holdOutDuration;
          _phaseTitle = 'Hold softly';
          _phaseSubTitle = 'just be here';
          _phaseEncouragementText = "Nothing to fix, just hold";
          _bubbleScale = 1.0;
        }
      case ExerciseStates.holdOut:
        _secondsElapsed++;
        _indicatorProgress = _secondsElapsed / maxTimePerCycle;
        if (_bubbleTime > 1) {
          _bubbleTime--;
          _bubbleScale = 1;
        } else {
          onRoundComplete();
          if (_currentRound == settings.rounds) {
            _timer?.cancel();
            _currentState = ExerciseStates.complete;
            onSessionComplete();
          } else {
            _currentState = ExerciseStates.breathIn;
            _bubbleTime = settings.breathInDuration;
            _phaseTitle = 'Breathe In';
            _phaseSubTitle = 'nice and slow';
            _currentRound++;
            _secondsElapsed = 0;
            _indicatorProgress = 0;
          }
        }
      case ExerciseStates.complete:
        break;
    }
    if (kDebugMode) {
      debugPrint(
        "[BreathingSession] phase: $_phaseTitle time: $_bubbleTime, "
        "scale: $_bubbleScale, round: $_currentRound, "
        "elapsed: ${_secondsElapsed}s, max: $maxTimePerCycle, "
        "progress: $_indicatorProgress",
      );
    }
    onUpdate();
  }

  void dispose() {
    _timer?.cancel();
  }
}
