import 'package:flutter/foundation.dart';

import '../../../../data/repositories/high_score_repository.dart';
import '../../../../domain/models/difficulty.dart';
import '../../../../domain/models/score_entry.dart';

class HighScoresViewModel extends ChangeNotifier {
  HighScoresViewModel({required this.highScoreRepository});

  final HighScoreRepository highScoreRepository;

  final Map<Difficulty, List<ScoreEntry>> _scores = {
    for (final difficulty in Difficulty.values)
      difficulty: const <ScoreEntry>[],
  };
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get hasAnyScores {
    return _scores.values.any((scores) => scores.isNotEmpty);
  }

  List<ScoreEntry> scoresFor(Difficulty difficulty) {
    return List.unmodifiable(_scores[difficulty] ?? const <ScoreEntry>[]);
  }

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();

    for (final difficulty in Difficulty.values) {
      _scores[difficulty] = await highScoreRepository.loadScores(difficulty);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearAll() async {
    await highScoreRepository.clearScores();

    for (final difficulty in Difficulty.values) {
      _scores[difficulty] = const <ScoreEntry>[];
    }

    notifyListeners();
  }
}
