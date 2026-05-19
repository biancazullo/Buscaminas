import 'package:flutter/material.dart';

import '../../../../app/app_dependencies.dart';
import '../../../../domain/models/difficulty.dart';
import '../../../core/view_models/app_view_model.dart';
import 'game_view.dart';

class DifficultySelectionView extends StatefulWidget {
  const DifficultySelectionView({super.key, required this.appViewModel});

  final AppViewModel appViewModel;

  @override
  State<DifficultySelectionView> createState() =>
      _DifficultySelectionViewState();
}

class _DifficultySelectionViewState extends State<DifficultySelectionView> {
  late Difficulty _selectedDifficulty;
  bool _isStarting = false;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.appViewModel.settings.difficulty;
  }

  Future<void> _startGame() async {
    if (_isStarting) {
      return;
    }

    setState(() => _isStarting = true);

    final settings = widget.appViewModel.settings.copyWith(
      difficulty: _selectedDifficulty,
    );
    await widget.appViewModel.updateSettings(settings);

    if (!mounted) {
      return;
    }

    final gameViewModel = AppDependenciesScope.of(
      context,
    ).createGameViewModel(initialSettings: settings);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => GameView(viewModel: gameViewModel, settings: settings),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar dificultad')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Elige tu reto',
                        key: const ValueKey('difficulty-title'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Se usara como dificultad por defecto para la proxima partida.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Difficulty.values.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isWide ? 3 : 1,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          mainAxisExtent: 210,
                        ),
                        itemBuilder: (context, index) {
                          final difficulty = Difficulty.values[index];
                          return _DifficultyOption(
                            difficulty: difficulty,
                            selected: _selectedDifficulty == difficulty,
                            onSelected: () {
                              setState(() => _selectedDifficulty = difficulty);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.center,
                        child: FilledButton.icon(
                          key: const ValueKey('start-selected-game-button'),
                          onPressed: _isStarting ? null : _startGame,
                          icon: _isStarting
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.play_arrow_rounded),
                          label: Text(
                            _isStarting
                                ? 'Preparando'
                                : 'Jugar ${_selectedDifficulty.label}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  const _DifficultyOption({
    required this.difficulty,
    required this.selected,
    required this.onSelected,
  });

  final Difficulty difficulty;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = selected
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final foregroundColor = selected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        key: ValueKey('difficulty-${difficulty.name}-option'),
        onTap: onSelected,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: selected ? 3 : 1,
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: foregroundColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      difficulty.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: foregroundColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                difficulty.summary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _descriptionFor(difficulty),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: foregroundColor.withValues(alpha: 0.82),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _descriptionFor(Difficulty difficulty) {
    return switch (difficulty) {
      Difficulty.easy => 'Ideal para empezar y aprender patrones.',
      Difficulty.medium => 'Un tablero mas amplio con riesgo constante.',
      Difficulty.hard => 'Partidas rapidas, densas y exigentes.',
    };
  }
}
