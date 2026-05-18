import 'package:flutter/foundation.dart';

import '../../../../domain/models/board_state.dart';
import '../../../../domain/models/difficulty.dart';
import '../../../../domain/models/game_settings.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel({GameSettings initialSettings = const GameSettings()})
    : _board = BoardState.empty(initialSettings.difficulty);

  BoardState _board;

  BoardState get board => _board;

  void prepareNewGame(Difficulty difficulty) {
    _board = BoardState.empty(difficulty);
    notifyListeners();
  }
}
