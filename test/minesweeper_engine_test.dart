import 'dart:math';

import 'package:buscaminas_flutter/domain/models/models.dart';
import 'package:buscaminas_flutter/domain/use_cases/minesweeper_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MinesweeperEngine', () {
    test('places mines after first reveal and keeps first cell safe', () {
      final engine = MinesweeperEngine(random: Random(7));
      final board = engine.createBoard(Difficulty.easy);

      final revealed = engine.revealCell(board, 0, 0, now: DateTime(2026));

      expect(revealed.hasMines, isTrue);
      expect(revealed.status, isNot(GameStatus.lost));
      expect(revealed.cellAt(0, 0).isMine, isFalse);
      expect(revealed.cellAt(0, 0).isRevealed, isTrue);
      expect(revealed.cells.where((cell) => cell.isMine), hasLength(10));
      expect(revealed.attempts, 1);
    });

    test('does not count flags or repeated reveals as attempts', () {
      final engine = MinesweeperEngine(random: Random(3));
      var board = engine.createBoard(Difficulty.easy);

      board = engine.toggleFlag(board, 0, 0);
      expect(board.cellAt(0, 0).isFlagged, isTrue);
      expect(board.attempts, 0);

      final flaggedReveal = engine.revealCell(board, 0, 0);
      expect(flaggedReveal.attempts, 0);

      board = engine.toggleFlag(board, 0, 0);
      board = engine.revealCell(board, 0, 0, now: DateTime(2026));
      final repeatedReveal = engine.revealCell(board, 0, 0);

      expect(board.attempts, 1);
      expect(repeatedReveal.attempts, 1);
    });

    test('ignores moves outside the board or after the game is finished', () {
      final engine = MinesweeperEngine(random: Random(3));
      final board = engine.createBoard(Difficulty.easy);

      expect(identical(engine.revealCell(board, -1, 0), board), isTrue);
      expect(identical(engine.toggleFlag(board, 0, 99), board), isTrue);

      final finishedBoard = board.copyWith(status: GameStatus.won);

      expect(
        identical(engine.revealCell(finishedBoard, 0, 0), finishedBoard),
        isTrue,
      );
      expect(
        identical(engine.toggleFlag(finishedBoard, 0, 0), finishedBoard),
        isTrue,
      );
    });

    test('does not flag revealed safe cells', () {
      final engine = MinesweeperEngine(random: Random(9));
      final board = engine.createBoard(Difficulty.easy);
      final revealed = engine.revealCell(board, 0, 0, now: DateTime(2026));

      final afterFlagAttempt = engine.toggleFlag(revealed, 0, 0);

      expect(identical(afterFlagAttempt, revealed), isTrue);
      expect(afterFlagAttempt.cellAt(0, 0).isFlagged, isFalse);
      expect(afterFlagAttempt.cellAt(0, 0).isRevealed, isTrue);
    });

    test('reveals every mine after losing', () {
      final engine = MinesweeperEngine(random: Random(1));
      final board = _boardWithMines(Difficulty.easy, _clusteredMines);

      final lostBoard = engine.revealCell(board, 5, 5);

      expect(lostBoard.status, GameStatus.lost);
      expect(lostBoard.cellAt(5, 5).isMine, isTrue);
      expect(lostBoard.cellAt(5, 5).isRevealed, isTrue);
      expect(
        lostBoard.cells.where((cell) => cell.isMine && cell.isRevealed),
        hasLength(Difficulty.easy.mineCount),
      );
    });

    test('flood fill reveals connected empty cells and boundary numbers', () {
      final engine = MinesweeperEngine(random: Random(1));
      final board = _boardWithMines(Difficulty.easy, _clusteredMines);

      final revealed = engine.revealCell(board, 0, 0);

      expect(revealed.status, isNot(GameStatus.lost));
      expect(revealed.cellAt(0, 0).isEmptySafeCell, isTrue);
      expect(revealed.cellAt(0, 0).isRevealed, isTrue);
      expect(revealed.cellAt(2, 3).adjacentMines, greaterThan(0));
      expect(revealed.cellAt(2, 3).isRevealed, isTrue);
      expect(revealed.revealedSafeCells, greaterThan(1));
    });

    test('wins after every safe cell is revealed', () {
      final engine = MinesweeperEngine(random: Random(1));
      var board = _boardWithMines(Difficulty.easy, _clusteredMines);

      for (final cell in board.cells.where((cell) => !cell.isMine).toList()) {
        board = engine.revealCell(board, cell.row, cell.column);
        if (board.status == GameStatus.won) {
          break;
        }
      }

      expect(board.status, GameStatus.won);
      expect(board.revealedSafeCells, board.totalSafeCells);
    });

    test('updates elapsed time only while playing', () {
      final engine = MinesweeperEngine(random: Random(5));
      final startedAt = DateTime(2026);
      var board = engine.createBoard(Difficulty.easy);

      board = engine.revealCell(board, 0, 0, now: startedAt);
      final ticked = engine.updateElapsedTime(
        board,
        startedAt.add(const Duration(seconds: 12)),
      );

      expect(ticked.elapsedSeconds, 12);

      final wonBoard = ticked.copyWith(status: GameStatus.won);
      final afterWin = engine.updateElapsedTime(
        wonBoard,
        startedAt.add(const Duration(seconds: 20)),
      );

      expect(afterWin.elapsedSeconds, 12);
    });
  });
}

const Set<(int, int)> _clusteredMines = {
  (2, 5),
  (3, 4),
  (3, 5),
  (4, 3),
  (4, 4),
  (4, 5),
  (5, 2),
  (5, 3),
  (5, 4),
  (5, 5),
};

BoardState _boardWithMines(Difficulty difficulty, Set<(int, int)> mines) {
  final cells = <Cell>[];

  for (var row = 0; row < difficulty.rows; row += 1) {
    for (var column = 0; column < difficulty.columns; column += 1) {
      cells.add(
        Cell(
          row: row,
          column: column,
          isMine: mines.contains((row, column)),
          adjacentMines: _adjacentMineCount(difficulty, mines, row, column),
        ),
      );
    }
  }

  return BoardState(difficulty: difficulty, cells: cells, hasMines: true);
}

int _adjacentMineCount(
  Difficulty difficulty,
  Set<(int, int)> mines,
  int row,
  int column,
) {
  var count = 0;

  for (var rowOffset = -1; rowOffset <= 1; rowOffset += 1) {
    for (var columnOffset = -1; columnOffset <= 1; columnOffset += 1) {
      if (rowOffset == 0 && columnOffset == 0) {
        continue;
      }

      final neighborRow = row + rowOffset;
      final neighborColumn = column + columnOffset;
      final isInsideBoard =
          neighborRow >= 0 &&
          neighborRow < difficulty.rows &&
          neighborColumn >= 0 &&
          neighborColumn < difficulty.columns;

      if (isInsideBoard && mines.contains((neighborRow, neighborColumn))) {
        count += 1;
      }
    }
  }

  return count;
}
