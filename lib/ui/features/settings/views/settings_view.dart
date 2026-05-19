import 'package:flutter/material.dart';

import '../../../../domain/models/difficulty.dart';
import '../../../../domain/models/number_style.dart';
import '../../../../domain/models/theme_preference.dart';
import '../../../core/view_models/app_view_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.appViewModel});

  final AppViewModel appViewModel;

  Future<void> _updateSettings(GameSettingsUpdate update) {
    final settings = appViewModel.settings;

    return appViewModel.updateSettings(
      settings.copyWith(
        difficulty: update.difficulty,
        themePreference: update.themePreference,
        numberStyle: update.numberStyle,
        soundEnabled: update.soundEnabled,
        animationsEnabled: update.animationsEnabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appViewModel,
      builder: (context, _) {
        final settings = appViewModel.settings;

        return Scaffold(
          appBar: AppBar(title: const Text('Configuracion')),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  key: const ValueKey('settings-list'),
                  padding: const EdgeInsets.all(16),
                  children: [
                    _SettingsHeader(isLoading: appViewModel.isLoading),
                    const SizedBox(height: 16),
                    _SettingsSection(
                      title: 'Dificultad por defecto',
                      subtitle: 'Se usa al iniciar nuevas partidas.',
                      child: _DifficultyPicker(
                        value: settings.difficulty,
                        onChanged: (difficulty) {
                          _updateSettings(
                            GameSettingsUpdate(difficulty: difficulty),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SettingsSection(
                      title: 'Tema',
                      subtitle:
                          'Automatico respeta la configuracion del sistema.',
                      child: _ThemePicker(
                        value: settings.themePreference,
                        onChanged: (themePreference) {
                          _updateSettings(
                            GameSettingsUpdate(
                              themePreference: themePreference,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SettingsSection(
                      title: 'Visualizacion de numeros',
                      subtitle:
                          'Cambia los colores de los numeros del tablero.',
                      child: _NumberStylePicker(
                        value: settings.numberStyle,
                        onChanged: (numberStyle) {
                          _updateSettings(
                            GameSettingsUpdate(numberStyle: numberStyle),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SettingsSection(
                      title: 'Experiencia',
                      subtitle: 'Ajustes de feedback visual y sonido.',
                      child: Column(
                        children: [
                          _SettingsSwitch(
                            switchKey: const ValueKey('animations-switch'),
                            value: settings.animationsEnabled,
                            onChanged: (animationsEnabled) {
                              _updateSettings(
                                GameSettingsUpdate(
                                  animationsEnabled: animationsEnabled,
                                ),
                              );
                            },
                            icon: Icons.auto_awesome_rounded,
                            title: const Text('Animaciones'),
                            subtitle: const Text(
                              'Activar transiciones y efectos.',
                            ),
                          ),
                          const Divider(height: 16),
                          _SettingsSwitch(
                            switchKey: const ValueKey('sound-switch'),
                            value: settings.soundEnabled,
                            onChanged: (soundEnabled) {
                              _updateSettings(
                                GameSettingsUpdate(soundEnabled: soundEnabled),
                              );
                            },
                            icon: Icons.volume_up_rounded,
                            title: const Text('Efectos de sonido'),
                            subtitle: const Text('Sin musica de fondo.'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    required this.switchKey,
    required this.value,
    required this.onChanged,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Key switchKey;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;
  final Widget title;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle.merge(
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  child: title,
                ),
                DefaultTextStyle.merge(
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                  child: subtitle,
                ),
              ],
            ),
          ),
          Switch(key: switchKey, value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class GameSettingsUpdate {
  const GameSettingsUpdate({
    this.difficulty,
    this.themePreference,
    this.numberStyle,
    this.soundEnabled,
    this.animationsEnabled,
  });

  final Difficulty? difficulty;
  final ThemePreference? themePreference;
  final NumberStyle? numberStyle;
  final bool? soundEnabled;
  final bool? animationsEnabled;
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              Icons.tune_rounded,
              size: 42,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ajustes del juego',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isLoading
                        ? 'Cargando preferencias locales.'
                        : 'Los cambios se aplican inmediatamente.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _DifficultyPicker extends StatelessWidget {
  const _DifficultyPicker({required this.value, required this.onChanged});

  final Difficulty value;
  final ValueChanged<Difficulty> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Difficulty>(
      key: const ValueKey('difficulty-setting-control'),
      selected: {value},
      onSelectionChanged: (values) => onChanged(values.single),
      segments: [
        for (final difficulty in Difficulty.values)
          ButtonSegment<Difficulty>(
            value: difficulty,
            label: Text(difficulty.label),
            icon: const Icon(Icons.grid_on_rounded),
          ),
      ],
    );
  }
}

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({required this.value, required this.onChanged});

  final ThemePreference value;
  final ValueChanged<ThemePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemePreference>(
      key: const ValueKey('theme-setting-control'),
      selected: {value},
      onSelectionChanged: (values) => onChanged(values.single),
      segments: [
        for (final themePreference in ThemePreference.values)
          ButtonSegment<ThemePreference>(
            value: themePreference,
            label: Text(themePreference.label),
            icon: Icon(_iconFor(themePreference)),
          ),
      ],
    );
  }

  IconData _iconFor(ThemePreference themePreference) {
    return switch (themePreference) {
      ThemePreference.system => Icons.brightness_auto_rounded,
      ThemePreference.light => Icons.light_mode_rounded,
      ThemePreference.dark => Icons.dark_mode_rounded,
    };
  }
}

class _NumberStylePicker extends StatelessWidget {
  const _NumberStylePicker({required this.value, required this.onChanged});

  final NumberStyle value;
  final ValueChanged<NumberStyle> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final style in NumberStyle.values)
          ChoiceChip(
            key: ValueKey('number-style-${style.name}'),
            selected: value == style,
            onSelected: (_) => onChanged(style),
            label: Text(style.label),
            avatar: Icon(_iconFor(style), size: 18),
          ),
      ],
    );
  }

  IconData _iconFor(NumberStyle style) {
    return switch (style) {
      NumberStyle.classic => Icons.filter_1_rounded,
      NumberStyle.colorful => Icons.palette_rounded,
      NumberStyle.retro => Icons.videogame_asset_rounded,
      NumberStyle.minimalist => Icons.minimize_rounded,
    };
  }
}
