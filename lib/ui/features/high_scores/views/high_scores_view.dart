import 'package:flutter/material.dart';

import '../../../../domain/models/difficulty.dart';
import '../../../../domain/models/score_entry.dart';
import '../view_models/high_scores_view_model.dart';

class HighScoresView extends StatefulWidget {
  const HighScoresView({super.key, required this.viewModel});

  final HighScoresViewModel viewModel;

  @override
  State<HighScoresView> createState() => _HighScoresViewState();
}

class _HighScoresViewState extends State<HighScoresView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadAll();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _confirmClearScores() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Borrar marcadores'),
          content: const Text(
            'Esta accion elimina todos los registros locales.',
          ),
          actions: [
            TextButton(
              key: const ValueKey('cancel-clear-scores-button'),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              key: const ValueKey('confirm-clear-scores-button'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Borrar'),
            ),
          ],
        );
      },
    );

    if (shouldClear ?? false) {
      await widget.viewModel.clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return DefaultTabController(
          length: Difficulty.values.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Marcadores'),
              bottom: TabBar(
                tabs: [
                  for (final difficulty in Difficulty.values)
                    Tab(text: difficulty.label),
                ],
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        for (final difficulty in Difficulty.values)
                          _DifficultyScoresTab(
                            difficulty: difficulty,
                            scores: widget.viewModel.scoresFor(difficulty),
                            isLoading: widget.viewModel.isLoading,
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            key: const ValueKey('clear-scores-button'),
                            onPressed: widget.viewModel.hasAnyScores
                                ? _confirmClearScores
                                : null,
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text('Borrar marcadores'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DifficultyScoresTab extends StatelessWidget {
  const _DifficultyScoresTab({
    required this.difficulty,
    required this.scores,
    required this.isLoading,
  });

  final Difficulty difficulty;
  final List<ScoreEntry> scores;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (scores.isEmpty) {
      return const _EmptyScoresMessage();
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView.separated(
          key: ValueKey('scores-list-${difficulty.name}'),
          padding: const EdgeInsets.all(16),
          itemCount: scores.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return _ScoreTile(rank: index + 1, score: scores[index]);
          },
        ),
      ),
    );
  }
}

class _EmptyScoresMessage extends StatelessWidget {
  const _EmptyScoresMessage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 72,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Aun no tienes registros. Juega tu primera partida!',
                key: const ValueKey('empty-scores-message'),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  const _ScoreTile({required this.rank, required this.score});

  final int rank;
  final ScoreEntry score;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final medalColor = switch (rank) {
      1 => const Color(0xFFFFC107),
      2 => const Color(0xFFB0BEC5),
      3 => const Color(0xFFB87333),
      _ => colorScheme.primary,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: rank.isOdd
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: rank == 1 ? medalColor : colorScheme.outlineVariant,
          width: rank == 1 ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: medalColor.withValues(alpha: 0.18),
              foregroundColor: medalColor,
              child: Icon(rank <= 3 ? Icons.workspace_premium : Icons.tag),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Puesto #$rank',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(score.playedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            _Metric(label: 'Tiempo', value: '${score.elapsedSeconds}s'),
            const SizedBox(width: 14),
            _Metric(label: 'Intentos', value: '${score.attempts}'),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
