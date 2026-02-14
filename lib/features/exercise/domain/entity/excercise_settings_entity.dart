class ExcerciseSettingsEntity {
  final int durationInSeconds;
  final int rounds;
  final int breathInDuration;
  final int holdInDuration;
  final int breathOutDuration;
  final int holdOutDuration;
  final bool allowSound;

  ExcerciseSettingsEntity({
    required this.durationInSeconds,
    required this.rounds,
    required this.breathInDuration,
    required this.holdInDuration,
    required this.breathOutDuration,
    required this.holdOutDuration,
    required this.allowSound,
  });

  factory ExcerciseSettingsEntity.initial() {
    return ExcerciseSettingsEntity(
      durationInSeconds: 4,
      rounds: 4,
      breathInDuration: 4,
      holdInDuration: 4,
      breathOutDuration: 4,
      holdOutDuration: 4,
      allowSound: true,
    );
  }
}
