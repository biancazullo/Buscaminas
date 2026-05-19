import 'cell.dart';
import 'difficulty.dart';
import 'game_status.dart';

class BoardState {
  BoardState({
    required this.difficulty,
    required List<Cell> cells,
    this.status = GameStatus.ready,
    this.elapsedSeconds = 0,
    this.attempts = 0,
    this.startedAt,
    this.hasMines = false,
  }) : cells = List.unmodifiable(cells);

  factory BoardState.empty(Difficulty difficulty) {
    final cells = <Cell>[];

    for (var row = 0; row < difficulty.rows; row += 1) {
      for (var column = 0; column < difficulty.columns; column += 1) {
        cells.add(Cell(row: row, column: column));
      }
    }

    return BoardState(difficulty: difficulty, cells: cells);
  }

  final Difficulty difficulty;
  final List<Cell> cells;
  final GameStatus status;
  final int elapsedSeconds;
  final int attempts;
  final DateTime? startedAt;
  final bool hasMines;

  int get rows => difficulty.rows;

  int get columns => difficulty.columns;

  int get remainingMines {
    final flaggedCells = cells.where((cell) => cell.isFlagged).length;
    return difficulty.mineCount - flaggedCells;
  }

  int get revealedSafeCells {
    return cells.where((cell) => cell.isRevealed && !cell.isMine).length;
  }

  int get totalSafeCells {
    return (rows * columns) - difficulty.mineCount;
  }

  bool containsPosition(int row, int column) {
    return row >= 0 && row < rows && column >= 0 && column < columns;
  }

  int indexOf(int row, int column) {
    return (row * columns) + column;
  }

  Cell cellAt(int row, int column) {
    return cells[indexOf(row, column)];
  }

  BoardState copyWith({
    Difficulty? difficulty,
    List<Cell>? cells,
    GameStatus? status,
    int? elapsedSeconds,
    int? attempts,
    DateTime? startedAt,
    bool? hasMines,
  }) {
    return BoardState(
      difficulty: difficulty ?? this.difficulty,
      cells: cells ?? this.cells,
      status: status ?? this.status,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      attempts: attempts ?? this.attempts,
      startedAt: startedAt ?? this.startedAt,
      hasMines: hasMines ?? this.hasMines,
    );
  }
}
