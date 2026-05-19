import 'dart:math';

import '../models/board_state.dart';
import '../models/cell.dart';
import '../models/difficulty.dart';
import '../models/game_status.dart';

class MinesweeperEngine {
  MinesweeperEngine({Random? random}) : _random = random ?? Random();

  final Random _random;

  BoardState createBoard(Difficulty difficulty) {
    return BoardState.empty(difficulty);
  }

  BoardState revealCell(
    BoardState board,
    int row,
    int column, {
    DateTime? now,
  }) {
    if (board.status.isFinished || !board.containsPosition(row, column)) {
      return board;
    }

    var preparedBoard = board;
    if (!preparedBoard.hasMines) {
      preparedBoard = _placeMines(preparedBoard, row, column);
    }

    final target = preparedBoard.cellAt(row, column);
    if (target.isRevealed || target.isFlagged) {
      return board;
    }

    final startedAt = preparedBoard.startedAt ?? now ?? DateTime.now();
    final attempts = preparedBoard.attempts + 1;

    if (target.isMine) {
      return preparedBoard.copyWith(
        cells: _revealMines(preparedBoard.cells, target),
        status: GameStatus.lost,
        attempts: attempts,
        startedAt: startedAt,
      );
    }

    final revealedCells = _revealSafeArea(preparedBoard, row, column);
    final updatedBoard = preparedBoard.copyWith(
      cells: revealedCells,
      status: GameStatus.playing,
      attempts: attempts,
      startedAt: startedAt,
    );

    if (updatedBoard.revealedSafeCells == updatedBoard.totalSafeCells) {
      return updatedBoard.copyWith(status: GameStatus.won);
    }

    return updatedBoard;
  }

  BoardState toggleFlag(BoardState board, int row, int column) {
    if (board.status.isFinished || !board.containsPosition(row, column)) {
      return board;
    }

    final cell = board.cellAt(row, column);
    if (cell.isRevealed) {
      return board;
    }

    final cells = [...board.cells];
    cells[board.indexOf(row, column)] = cell.copyWith(
      isFlagged: !cell.isFlagged,
    );

    return board.copyWith(cells: cells);
  }

  BoardState updateElapsedTime(BoardState board, DateTime now) {
    final startedAt = board.startedAt;
    if (startedAt == null || board.status != GameStatus.playing) {
      return board;
    }

    final elapsedSeconds = now.difference(startedAt).inSeconds;
    return board.copyWith(elapsedSeconds: max(0, elapsedSeconds));
  }

  BoardState _placeMines(BoardState board, int safeRow, int safeColumn) {
    final safeIndex = board.indexOf(safeRow, safeColumn);
    final candidates = <int>[
      for (var index = 0; index < board.cells.length; index += 1)
        if (index != safeIndex) index,
    ];

    candidates.shuffle(_random);
    final mineIndexes = candidates.take(board.difficulty.mineCount).toSet();
    final cells = <Cell>[];

    for (final cell in board.cells) {
      final index = board.indexOf(cell.row, cell.column);
      cells.add(cell.copyWith(isMine: mineIndexes.contains(index)));
    }

    final cellsWithCounts = _calculateAdjacentMines(
      board.copyWith(cells: cells, hasMines: true),
    );

    return board.copyWith(cells: cellsWithCounts, hasMines: true);
  }

  List<Cell> _calculateAdjacentMines(BoardState board) {
    return [
      for (final cell in board.cells)
        cell.copyWith(
          adjacentMines: _neighborsOf(
            board,
            cell,
          ).where((neighbor) => neighbor.isMine).length,
        ),
    ];
  }

  List<Cell> _revealSafeArea(BoardState board, int row, int column) {
    final cells = [...board.cells];
    final queue = <Cell>[board.cellAt(row, column)];
    final queuedIds = <String>{queue.first.id};

    while (queue.isNotEmpty) {
      final cell = queue.removeAt(0);
      final index = board.indexOf(cell.row, cell.column);
      final current = cells[index];

      if (current.isRevealed || current.isFlagged || current.isMine) {
        continue;
      }

      cells[index] = current.copyWith(isRevealed: true);

      if (current.adjacentMines != 0) {
        continue;
      }

      for (final neighbor in _neighborsOf(
        board.copyWith(cells: cells),
        current,
      )) {
        if (!queuedIds.contains(neighbor.id) &&
            !neighbor.isRevealed &&
            !neighbor.isFlagged &&
            !neighbor.isMine) {
          queuedIds.add(neighbor.id);
          queue.add(neighbor);
        }
      }
    }

    return cells;
  }

  List<Cell> _revealMines(List<Cell> cells, Cell selectedMine) {
    return [
      for (final cell in cells)
        if (cell.isMine || cell.id == selectedMine.id)
          cell.copyWith(isRevealed: true)
        else
          cell,
    ];
  }

  List<Cell> _neighborsOf(BoardState board, Cell cell) {
    final neighbors = <Cell>[];

    for (var rowOffset = -1; rowOffset <= 1; rowOffset += 1) {
      for (var columnOffset = -1; columnOffset <= 1; columnOffset += 1) {
        if (rowOffset == 0 && columnOffset == 0) {
          continue;
        }

        final row = cell.row + rowOffset;
        final column = cell.column + columnOffset;
        if (board.containsPosition(row, column)) {
          neighbors.add(board.cellAt(row, column));
        }
      }
    }

    return neighbors;
  }
}
