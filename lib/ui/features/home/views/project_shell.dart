import 'package:flutter/material.dart';

import '../../../core/view_models/app_view_model.dart';

class ProjectShell extends StatelessWidget {
  const ProjectShell({super.key, required this.appViewModel});

  final AppViewModel appViewModel;

  static const String title = 'Buscaminas Flutter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(title)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;
          final content = _WelcomePanel(
            isWide: isWide,
            isLoadingSettings: appViewModel.isLoading,
          );

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: content,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({required this.isWide, required this.isLoadingSettings});

  final bool isWide;
  final bool isLoadingSettings;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final titleStyle = isWide
        ? textTheme.displaySmall
        : textTheme.headlineMedium;

    return Flex(
      direction: isWide ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: isWide ? 2 : 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Icon(
                Icons.grid_view_rounded,
                key: const ValueKey('app-logo'),
                size: isWide ? 132 : 96,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        SizedBox(width: isWide ? 32 : 0, height: isWide ? 0 : 28),
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: isWide
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ProjectShell.title,
                key: const ValueKey('app-title'),
                textAlign: isWide ? TextAlign.start : TextAlign.center,
                style: titleStyle?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              Text(
                'Arquitectura inicial lista para construir el juego completo.',
                key: const ValueKey('app-subtitle'),
                textAlign: isWide ? TextAlign.start : TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  const _StatusChip(icon: Icons.layers, label: 'MVVM'),
                  const _StatusChip(icon: Icons.storage, label: 'Repositorios'),
                  const _StatusChip(icon: Icons.grid_on, label: 'Dominio'),
                  if (isLoadingSettings)
                    const _StatusChip(
                      icon: Icons.sync,
                      label: 'Cargando ajustes',
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Chip(
      avatar: Icon(icon, size: 18, color: colorScheme.primary),
      label: Text(label),
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      side: BorderSide(color: colorScheme.outlineVariant),
    );
  }
}
