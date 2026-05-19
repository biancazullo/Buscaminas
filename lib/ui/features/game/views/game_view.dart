import 'package:flutter/material.dart';

import '../../../../domain/models/board_state.dart';
import '../../../../domain/models/cell.dart';
import '../../../../domain/models/difficulty.dart';
import '../../../../domain/models/game_settings.dart';
import '../../../../domain/models/game_status.dart';
import '../../../../domain/models/number_style.dart';
import '../view_models/game_view_model.dart';

class GameView extends StatefulWidget {
  const GameView({super.key, required this.viewModel, required this.settings});

  final GameViewModel viewModel;
  final GameSettings settings;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final board = widget.viewModel.board;

        return Scaffold(
          appBar: AppBar(title: Text('Partida ${board.difficulty.label}')),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 800;
                final summary = _GameSummary(
                  board: board,
                  onRestart: () {
                    widget.viewModel.prepareNewGame(board.difficulty);
                  },
                );
                final boardView = _InteractiveBoard(
                  board: board,
                  settings: widget.settings,
                  onReveal: widget.viewModel.revealCell,
                  onToggleFlag: widget.viewModel.toggleFlag,
                );

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 980),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 310, child: summary),
                                const SizedBox(width: 32),
                                Expanded(child: boardView),
                              ],
                            )
                          : Column(
                              children: [
                                summary,
                                const SizedBox(height: 24),
                                boardView,
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _GameSummary extends StatelessWidget {
  const _GameSummary({required this.board, required this.onRestart});

  final BoardState board;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      key: const ValueKey('game-view'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _titleFor(board.status),
          key: const ValueKey('game-title'),
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          _messageFor(board.status),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatTile(
              icon: Icons.grid_on_rounded,
              label: 'Tablero',
              value: board.difficulty.boardSizeLabel,
            ),
            _StatTile(
              icon: Icons.dangerous_rounded,
              label: 'Restantes',
              value: '${board.remainingMines}',
              valueKey: const ValueKey('remaining-mines-value'),
            ),
            _StatTile(
              icon: Icons.timer_rounded,
              label: 'Tiempo',
              value: '${board.elapsedSeconds}s',
              valueKey: const ValueKey('elapsed-time-value'),
            ),
            _StatTile(
              icon: Icons.touch_app_rounded,
              label: 'Intentos',
              value: '${board.attempts}',
              valueKey: const ValueKey('attempts-value'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          key: const ValueKey('restart-game-button'),
          onPressed: onRestart,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Reiniciar partida'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          key: const ValueKey('exit-game-button'),
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.home_rounded),
          label: const Text('Salir al menu'),
        ),
      ],
    );
  }

  String _titleFor(GameStatus status) {
    return switch (status) {
      GameStatus.ready => 'Partida lista',
      GameStatus.playing => 'Partida en curso',
      GameStatus.won => 'Victoria',
      GameStatus.lost => 'Derrota',
    };
  }

  String _messageFor(GameStatus status) {
    return switch (status) {
      GameStatus.ready => 'Revela una casilla para iniciar el cronometro.',
      GameStatus.playing =>
        'Marca sospechas y descubre todas las casillas seguras.',
      GameStatus.won => 'Todas las casillas seguras fueron descubiertas.',
      GameStatus.lost => 'Pisaste una mina. Puedes reiniciar la partida.',
    };
  }
}

class _InteractiveBoard extends StatelessWidget {
  const _InteractiveBoard({
    required this.board,
    required this.settings,
    required this.onReveal,
    required this.onToggleFlag,
  });

  final BoardState board;
  final GameSettings settings;
  final void Function(int row, int column) onReveal;
  final void Function(int row, int column) onToggleFlag;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: AspectRatio(
          aspectRatio: board.columns / board.rows,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                key: const ValueKey('game-board'),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: board.cells.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: board.columns,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final cell = board.cells[index];

                  return _BoardCell(
                    cell: cell,
                    boardStatus: board.status,
                    numberStyle: settings.numberStyle,
                    animationsEnabled: settings.animationsEnabled,
                    onReveal: () => onReveal(cell.row, cell.column),
                    onToggleFlag: () => onToggleFlag(cell.row, cell.column),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BoardCell extends StatefulWidget {
  const _BoardCell({
    required this.cell,
    required this.boardStatus,
    required this.numberStyle,
    required this.animationsEnabled,
    required this.onReveal,
    required this.onToggleFlag,
  });

  final Cell cell;
  final GameStatus boardStatus;
  final NumberStyle numberStyle;
  final bool animationsEnabled;
  final VoidCallback onReveal;
  final VoidCallback onToggleFlag;

  @override
  State<_BoardCell> createState() => _BoardCellState();
}

class _BoardCellState extends State<_BoardCell> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _isInteractive =>
      !widget.boardStatus.isFinished && !widget.cell.isRevealed;

  Duration get _duration => widget.animationsEnabled
      ? const Duration(milliseconds: 140)
      : Duration.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _isInteractive
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        key: ValueKey('cell-${widget.cell.row}-${widget.cell.column}'),
        behavior: HitTestBehavior.opaque,
        onTap: _isInteractive ? widget.onReveal : null,
        onLongPress: _isInteractive ? widget.onToggleFlag : null,
        onSecondaryTap: _isInteractive ? widget.onToggleFlag : null,
        onTapDown: _isInteractive
            ? (_) => setState(() => _isPressed = true)
            : null,
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.94 : 1,
          duration: _duration,
          child: AnimatedContainer(
            duration: _duration,
            decoration: _cellDecoration(context),
            child: Center(
              child: AnimatedSwitcher(
                duration: _duration,
                child: _cellContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cellDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cell = widget.cell;
    final isRevealed = cell.isRevealed;
    final hasExploded = widget.boardStatus == GameStatus.lost && cell.isMine;
    final backgroundColor = hasExploded
        ? colorScheme.errorContainer
        : isRevealed
        ? colorScheme.surface
        : _isHovered
        ? colorScheme.primaryContainer.withValues(alpha: 0.84)
        : colorScheme.primaryContainer;

    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(isRevealed ? 5 : 8),
      border: Border.all(
        color: isRevealed
            ? colorScheme.outlineVariant
            : colorScheme.primary.withValues(alpha: 0.36),
      ),
      boxShadow: isRevealed
          ? null
          : [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.10),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }

  Widget _cellContent(BuildContext context) {
    final cell = widget.cell;
    final colorScheme = Theme.of(context).colorScheme;

    if (cell.isFlagged && !cell.isRevealed) {
      return Icon(
        Icons.flag_rounded,
        key: ValueKey('flag-${cell.id}'),
        size: 20,
        color: colorScheme.tertiary,
      );
    }

    if (!cell.isRevealed) {
      return const SizedBox.shrink(key: ValueKey('hidden-cell'));
    }

    if (cell.isMine) {
      return Icon(
        Icons.local_fire_department_rounded,
        key: ValueKey('mine-${cell.id}'),
        size: 20,
        color: colorScheme.error,
      );
    }

    if (cell.adjacentMines == 0) {
      return const SizedBox.shrink(key: ValueKey('empty-cell'));
    }

    return Text(
      '${cell.adjacentMines}',
      key: ValueKey('number-${cell.id}'),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: _numberColor(context, cell.adjacentMines),
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      ),
    );
  }

  Color _numberColor(BuildContext context, int number) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.numberStyle == NumberStyle.minimalist) {
      return colorScheme.onSurface;
    }

    final index = (number - 1).clamp(0, 7);
    final classic = [
      Colors.blue.shade700,
      Colors.green.shade700,
      Colors.red.shade700,
      Colors.indigo.shade800,
      Colors.brown.shade700,
      Colors.teal.shade700,
      Colors.black87,
      Colors.grey.shade700,
    ];
    final colorful = [
      const Color(0xFF2364AA),
      const Color(0xFF2CA58D),
      const Color(0xFFE84855),
      const Color(0xFF7B2CBF),
      const Color(0xFFF77F00),
      const Color(0xFF00A6D6),
      const Color(0xFF2D3142),
      const Color(0xFF6C757D),
    ];
    final retro = [
      const Color(0xFF2F80ED),
      const Color(0xFF27AE60),
      const Color(0xFFEB5757),
      const Color(0xFF9B51E0),
      const Color(0xFFF2994A),
      const Color(0xFF56CCF2),
      const Color(0xFF333333),
      const Color(0xFF828282),
    ];

    return switch (widget.numberStyle) {
      NumberStyle.classic => classic[index],
      NumberStyle.colorful => colorful[index],
      NumberStyle.retro => retro[index],
      NumberStyle.minimalist => colorScheme.onSurface,
    };
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueKey,
  });

  final IconData icon;
  final String label;
  final String value;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 126),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                key: valueKey,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
