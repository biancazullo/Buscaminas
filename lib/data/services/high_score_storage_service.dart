import '../../domain/models/difficulty.dart';
import '../../domain/models/score_entry.dart';

abstract class HighScoreStorageService {
  Future<List<ScoreEntry>> readScores(Difficulty difficulty);

  Future<void> writeScores(Difficulty difficulty, List<ScoreEntry> scores);

  Future<void> clearScores();
}

class InMemoryHighScoreStorageService implements HighScoreStorageService {
  final Map<Difficulty, List<ScoreEntry>> _scores = {
    for (final difficulty in Difficulty.values) difficulty: <ScoreEntry>[],
  };

  @override
  Future<List<ScoreEntry>> readScores(Difficulty difficulty) async {
    return List.unmodifiable(_scores[difficulty] ?? const <ScoreEntry>[]);
  }

  @override
  Future<void> writeScores(
    Difficulty difficulty,
    List<ScoreEntry> scores,
  ) async {
    _scores[difficulty] = List<ScoreEntry>.from(scores);
  }

  @override
  Future<void> clearScores() async {
    for (final difficulty in Difficulty.values) {
      _scores[difficulty] = <ScoreEntry>[];
    }
  }
}
