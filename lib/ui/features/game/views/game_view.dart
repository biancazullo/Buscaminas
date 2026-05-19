import 'package:flutter/material.dart';

import '../../../../domain/models/board_state.dart';
import '../../../../domain/models/difficulty.dart';
import '../../../../domain/models/game_settings.dart';
import '../../../../domain/models/game_status.dart';
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
                final preview = _BoardPreview(board: board);

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 980),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: summary),
                                const SizedBox(width: 32),
                                Expanded(child: preview),
                              ],
                            )
                          : Column(
                              children: [
                                summary,
                                const SizedBox(height: 24),
                                preview,
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
          'Partida lista',
          key: const ValueKey('game-title'),
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          'El tablero interactivo se completa en el siguiente tramo.',
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
              label: 'Minas',
              value: '${board.difficulty.mineCount}',
            ),
            _StatTile(
              icon: Icons.timer_rounded,
              label: 'Tiempo',
              value: '${board.elapsedSeconds}s',
            ),
            _StatTile(
              icon: Icons.touch_app_rounded,
              label: 'Intentos',
              value: '${board.attempts}',
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
}

class _BoardPreview extends StatelessWidget {
  const _BoardPreview({required this.board});

  final BoardState board;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: board.columns / board.rows,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            key: const ValueKey('game-board-preview'),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: board.cells.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: board.columns,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: board.status == GameStatus.ready
                      ? colorScheme.primaryContainer
                      : colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

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
