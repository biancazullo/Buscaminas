enum Difficulty { easy, medium, hard }

extension DifficultyDetails on Difficulty {
  String get label {
    return switch (this) {
      Difficulty.easy => 'Facil',
      Difficulty.medium => 'Medio',
      Difficulty.hard => 'Dificil',
    };
  }

  int get rows {
    return switch (this) {
      Difficulty.easy => 6,
      Difficulty.medium => 8,
      Difficulty.hard => 10,
    };
  }

  int get columns {
    return switch (this) {
      Difficulty.easy => 6,
      Difficulty.medium => 8,
      Difficulty.hard => 10,
    };
  }

  int get mineCount {
    return switch (this) {
      Difficulty.easy => 10,
      Difficulty.medium => 20,
      Difficulty.hard => 30,
    };
  }

  String get boardSizeLabel => '${rows}x$columns';

  String get summary => '$boardSizeLabel - $mineCount minas';

  static Difficulty fromName(String value) {
    for (final difficulty in Difficulty.values) {
      if (difficulty.name == value) {
        return difficulty;
      }
    }

    return Difficulty.easy;
  }
}
