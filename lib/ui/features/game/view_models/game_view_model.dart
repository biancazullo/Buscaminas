import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../domain/models/board_state.dart';
import '../../../../domain/models/difficulty.dart';
import '../../../../domain/models/game_settings.dart';
import '../../../../domain/models/game_status.dart';
import '../../../../domain/use_cases/minesweeper_engine.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel({
    GameSettings initialSettings = const GameSettings(),
    MinesweeperEngine? engine,
  }) : _engine = engine ?? MinesweeperEngine(),
       _board = BoardState.empty(initialSettings.difficulty);

  final MinesweeperEngine _engine;
  Timer? _timer;
  BoardState _board;

  BoardState get board => _board;

  void prepareNewGame(Difficulty difficulty) {
    _timer?.cancel();
    _timer = null;
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
