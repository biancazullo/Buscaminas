import 'package:buscaminas_flutter/data/repositories/high_score_repository.dart';
import 'package:buscaminas_flutter/data/services/high_score_storage_service.dart';
import 'package:buscaminas_flutter/domain/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HighScoreRepository', () {
    test('sorts by fastest time and then by attempts', () async {
      final repository = HighScoreRepository(
        storageService: InMemoryHighScoreStorageService(),
      );

      expect(
        await repository.recordScore(_score(elapsedSeconds: 30, attempts: 7)),
        isTrue,
      );
      expect(
        await repository.recordScore(_score(elapsedSeconds: 40, attempts: 2)),
        isFalse,
      );
      expect(
        await repository.recordScore(_score(elapsedSeconds: 30, attempts: 4)),
        isTrue,
      );
      await repository.recordScore(_score(elapsedSeconds: 20, attempts: 9));

      final scores = await repository.loadScores(Difficulty.easy);

      expect(scores.map((score) => (score.elapsedSeconds, score.attempts)), [
        (20, 9),
        (30, 4),
        (30, 7),
        (40, 2),
      ]);
    });

    test('keeps only the top ten scores per difficulty', () async {
      final repository = HighScoreRepository(
        storageService: InMemoryHighScoreStorageService(),
      );

      for (var index = 0; index < 12; index += 1) {
        await repository.recordScore(
          _score(elapsedSeconds: 10 + index, attempts: index + 1),
        );
      }
      await repository.recordScore(
        _score(difficulty: Difficulty.medium, elapsedSeconds: 1, attempts: 1),
      );

      final easyScores = await repository.loadScores(Difficulty.easy);
      final mediumScores = await repository.loadScores(Difficulty.medium);

      expect(easyScores, hasLength(HighScoreRepository.maxScoresPerDifficulty));
      expect(easyScores.first.elapsedSeconds, 10);
      expect(easyScores.last.elapsedSeconds, 19);
      expect(mediumScores, hasLength(1));
      expect(mediumScores.single.difficulty, Difficulty.medium);
    });
  });
}

ScoreEntry _score({
  Difficulty difficulty = Difficulty.easy,
  required int elapsedSeconds,
  required int attempts,
}) {
  return ScoreEntry(
    difficulty: difficulty,
    elapsedSeconds: elapsedSeconds,
    attempts: attempts,
    playedAt: DateTime(2026, 5, 19),
  );
}
