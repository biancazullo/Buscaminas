enum GameStatus { ready, playing, won, lost }

extension GameStatusDetails on GameStatus {
  bool get isFinished => this == GameStatus.won || this == GameStatus.lost;
}
