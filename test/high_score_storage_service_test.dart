import 'package:buscaminas_flutter/data/services/high_score_storage_service.dart';
import 'package:buscaminas_flutter/domain/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesHighScoreStorageService', () {
    test('persists scores by difficulty', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final service = SharedPreferencesHighScoreStorageService(
        preferences: preferences,
      );
      final score = ScoreEntry(
        difficulty: Difficulty.medium,
        elapsedSeconds: 42,
        attempts: 8,
        playedAt: DateTime(2026, 5, 19),
      );

      await service.writeScores(Difficulty.medium, [score]);

      expect(await service.readScores(Difficulty.easy), isEmpty);
      expect(await service.readScores(Difficulty.medium), [score]);
    });

    test('clears every score bucket', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final service = SharedPreferencesHighScoreStorageService(
        preferences: preferences,
      );

      await service.writeScores(Difficulty.easy, [
        ScoreEntry(
          difficulty: Difficulty.easy,
          elapsedSeconds: 9,
          attempts: 1,
          playedAt: DateTime(2026, 5, 19),
        ),
      ]);
      await service.clearScores();

      expect(await service.readScores(Difficulty.easy), isEmpty);
    });

    test('ignores malformed and mismatched score data', () async {
      SharedPreferences.setMockInitialValues({
        'highScores.easy': 'not-json',
        'highScores.medium':
            '[{"difficulty":"easy","elapsedSeconds":12,"attempts":2,"playedAt":"2026-05-19T00:00:00.000"}]',
      });
      final preferences = await SharedPreferences.getInstance();
      final service = SharedPreferencesHighScoreStorageService(
        preferences: preferences,
      );

      expect(await service.readScores(Difficulty.easy), isEmpty);
      expect(await service.readScores(Difficulty.medium), isEmpty);
    });
  });
}
