import 'difficulty.dart';

class ScoreEntry {
  const ScoreEntry({
    required this.difficulty,
    required this.elapsedSeconds,
    required this.attempts,
    required this.playedAt,
  });

  final Difficulty difficulty;
  final int elapsedSeconds;
  final int attempts;
  final DateTime playedAt;

  bool isBetterThan(ScoreEntry other) {
    if (elapsedSeconds != other.elapsedSeconds) {
      return elapsedSeconds < other.elapsedSeconds;
    }

    return attempts < other.attempts;
  }

  @override
  bool operator ==(Object other) {
    return other is ScoreEntry &&
        other.difficulty == difficulty &&
        other.elapsedSeconds == elapsedSeconds &&
        other.attempts == attempts &&
        other.playedAt == playedAt;
  }

  @override
  int get hashCode {
    return Object.hash(difficulty, elapsedSeconds, attempts, playedAt);
  }
}
