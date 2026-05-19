import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

class SharedPreferencesHighScoreStorageService
    implements HighScoreStorageService {
  const SharedPreferencesHighScoreStorageService({required this.preferences});

  static const String _keyPrefix = 'highScores';

  final SharedPreferences preferences;

  @override
  Future<List<ScoreEntry>> readScores(Difficulty difficulty) async {
    final rawValue = preferences.getString(_keyFor(difficulty));
    if (rawValue == null || rawValue.isEmpty) {
      return const <ScoreEntry>[];
    }

    final decoded = jsonDecode(rawValue);
    if (decoded is! List) {
      return const <ScoreEntry>[];
    }

    return decoded
        .whereType<Map>()
        .map((json) => _scoreFromJson(Map<String, Object?>.from(json)))
        .where((score) => score.difficulty == difficulty)
        .toList(growable: false);
  }

  @override
  Future<void> writeScores(Difficulty difficulty, List<ScoreEntry> scores) {
    final encoded = jsonEncode(
      scores.map(_scoreToJson).toList(growable: false),
    );
    return preferences.setString(_keyFor(difficulty), encoded);
  }

  @override
  Future<void> clearScores() async {
    await Future.wait([
      for (final difficulty in Difficulty.values)
        preferences.remove(_keyFor(difficulty)),
    ]);
  }

  String _keyFor(Difficulty difficulty) {
    return '$_keyPrefix.${difficulty.name}';
  }

  Map<String, Object?> _scoreToJson(ScoreEntry score) {
    return {
      'difficulty': score.difficulty.name,
      'elapsedSeconds': score.elapsedSeconds,
      'attempts': score.attempts,
      'playedAt': score.playedAt.toIso8601String(),
    };
  }

  ScoreEntry _scoreFromJson(Map<String, Object?> json) {
    return ScoreEntry(
      difficulty: DifficultyDetails.fromName(
        json['difficulty'] as String? ?? '',
      ),
      elapsedSeconds: json['elapsedSeconds'] as int? ?? 0,
      attempts: json['attempts'] as int? ?? 0,
      playedAt:
          DateTime.tryParse(json['playedAt'] as String? ?? '') ??
          DateTime(1970),
    );
  }
}
