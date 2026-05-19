import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../data/repositories/high_score_repository.dart';
import '../../../../domain/models/board_state.dart';
import '../../../../domain/models/difficulty.dart';
import '../../../../domain/models/game_settings.dart';
import '../../../../domain/models/game_status.dart';
import '../../../../domain/models/score_entry.dart';
import '../../../../domain/use_cases/minesweeper_engine.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel({
    GameSettings initialSettings = const GameSettings(),
    MinesweeperEngine? engine,
    this.highScoreRepository,
    DateTime Function()? now,
  }) : _engine = engine ?? MinesweeperEngine(),
       _now = now ?? DateTime.now,
       _board = BoardState.empty(initialSettings.difficulty);

  final MinesweeperEngine _engine;
  final HighScoreRepository? highScoreRepository;
  final DateTime Function() _now;
  Timer? _timer;
  BoardState _board;
  bool _isNewRecord = false;
  bool _scoreRecorded = false;
  bool _isDisposed = false;

  BoardState get board => _board;

  bool get isNewRecord => _isNewRecord;

  void prepareNewGame(Difficulty difficulty) {
    _timer?.cancel();
    _timer = null;
    _isNewRecord = false;
    _scoreRecorded = false;
    _board = _engine.createBoard(difficulty);
    notifyListeners();
  }

  void revealCell(int row, int column) {
    final updatedBoard = _engine.revealCell(_board, row, column);
    if (identical(updatedBoard, _board)) {
      return;
    }

    _board = updatedBoard;
    _syncTimer();
    notifyListeners();
    _recordVictoryIfNeeded(updatedBoard);
  }

  void toggleFlag(int row, int column) {
    final updatedBoard = _engine.toggleFlag(_board, row, column);
    if (identical(updatedBoard, _board)) {
      return;
    }

    _board = updatedBoard;
    notifyListeners();
  }

  void _syncTimer() {
    if (_board.status == GameStatus.playing && _timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }

    if (_board.status != GameStatus.playing) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _tick() {
    _board = _engine.updateElapsedTime(_board, DateTime.now());
    _syncTimer();
    notifyListeners();
  }

  void _recordVictoryIfNeeded(BoardState board) {
    final repository = highScoreRepository;
    if (repository == null ||
        board.status != GameStatus.won ||
        _scoreRecorded) {
      return;
    }

    _scoreRecorded = true;
    unawaited(_recordScore(repository, board));
  }

  Future<void> _recordScore(
    HighScoreRepository repository,
    BoardState board,
  ) async {
    final score = ScoreEntry(
      difficulty: board.difficulty,
      elapsedSeconds: board.elapsedSeconds,
      attempts: board.attempts,
      playedAt: _now(),
    );
    final isNewRecord = await repository.recordScore(score);
    if (_isDisposed) {
      return;
    }

    _isNewRecord = isNewRecord;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
