class Cell {
  const Cell({
    required this.row,
    required this.column,
    this.isMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.adjacentMines = 0,
  });

  final int row;
  final int column;
  final bool isMine;
  final bool isRevealed;
  final bool isFlagged;
  final int adjacentMines;

  String get id => '$row:$column';

  bool get isEmptySafeCell => !isMine && adjacentMines == 0;

  Cell copyWith({
    bool? isMine,
    bool? isRevealed,
    bool? isFlagged,
    int? adjacentMines,
  }) {
    return Cell(
      row: row,
      column: column,
      isMine: isMine ?? this.isMine,
      isRevealed: isRevealed ?? this.isRevealed,
      isFlagged: isFlagged ?? this.isFlagged,
      adjacentMines: adjacentMines ?? this.adjacentMines,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Cell &&
        other.row == row &&
        other.column == column &&
        other.isMine == isMine &&
        other.isRevealed == isRevealed &&
        other.isFlagged == isFlagged &&
        other.adjacentMines == adjacentMines;
  }

  @override
  int get hashCode {
    return Object.hash(
      row,
      column,
      isMine,
      isRevealed,
      isFlagged,
      adjacentMines,
    );
  }
}
