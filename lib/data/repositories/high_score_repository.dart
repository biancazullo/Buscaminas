import '../../domain/models/difficulty.dart';
import '../../domain/models/score_entry.dart';
import '../services/high_score_storage_service.dart';

class HighScoreRepository {
  const HighScoreRepository({required this.storageService});

  static const int maxScoresPerDifficulty = 10;

  final HighScoreStorageService storageService;

  Future<List<ScoreEntry>> loadScores(Difficulty difficulty) async {
    final scores = await storageService.readScores(difficulty);
    return _sorted(scores);
  }

  Future<bool> recordScore(ScoreEntry score) async {
    final currentScores = await loadScores(score.difficulty);
    final isNewRecord =
        currentScores.isEmpty || score.isBetterThan(currentScores.first);
    final updatedScores = _sorted([
      ...currentScores,
      score,
    ]).take(maxScoresPerDifficulty).toList(growable: false);

    await storageService.writeScores(score.difficulty, updatedScores);
    return isNewRecord;
  }

  Future<void> clearScores() {
    return storageService.clearScores();
  }

  List<ScoreEntry> _sorted(List<ScoreEntry> scores) {
    return [...scores]..sort((a, b) {
      final timeComparison = a.elapsedSeconds.compareTo(b.elapsedSeconds);
      if (timeComparison != 0) {
        return timeComparison;
      }

      return a.attempts.compareTo(b.attempts);
    });
  }
}
