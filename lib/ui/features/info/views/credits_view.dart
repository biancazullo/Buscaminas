import 'package:flutter/material.dart';

class CreditsView extends StatelessWidget {
  const CreditsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creditos')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            key: const ValueKey('credits-view'),
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CreditsHero(),
                  SizedBox(height: 16),
                  _CreditTile(
                    icon: Icons.school_rounded,
                    title: 'Micro-proyecto Flutter',
                    subtitle:
                        'Juego de Buscaminas con persistencia local y despliegue web.',
                  ),
                  SizedBox(height: 10),
                  _CreditTile(
                    icon: Icons.code_rounded,
                    title: 'Integrantes',
                    subtitle: 'Bianca Zullo y Corina Vera.',
                  ),
                  SizedBox(height: 10),
                  _CreditTile(
                    icon: Icons.developer_mode_rounded,
                    title: 'Desarrollo',
                    subtitle:
                        'Proyecto academico implementado en Flutter con Material.',
                  ),
                  SizedBox(height: 10),
                  _CreditTile(
                    icon: Icons.calendar_month_rounded,
                    title: 'Periodo',
                    subtitle: '2526-3',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CreditsHero extends StatelessWidget {
  const _CreditsHero();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Icon(
              Icons.grid_view_rounded,
              size: 72,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 14),
            Text(
              'Buscaminas Flutter',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Construido como experiencia jugable completa.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditTile extends StatelessWidget {
  const _CreditTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
