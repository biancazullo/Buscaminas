import 'package:flutter/material.dart';

void main() {
  runApp(const BuscaminasApp());
}

class BuscaminasApp extends StatelessWidget {
  const BuscaminasApp({super.key});

  static const String title = 'Buscaminas Flutter';
  static const Color seedColor = Color(0xFF1D6B7A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const ProjectShell(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(180, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class ProjectShell extends StatelessWidget {
  const ProjectShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(BuscaminasApp.title)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;
          final content = _WelcomePanel(isWide: isWide);

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
  const _WelcomePanel({required this.isWide});

  final bool isWide;

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
                BuscaminasApp.title,
                key: const ValueKey('app-title'),
                textAlign: isWide ? TextAlign.start : TextAlign.center,
                style: titleStyle?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              Text(
                'Base inicial lista para construir el juego completo.',
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
                children: const [
                  _StatusChip(icon: Icons.web_asset, label: 'Web PWA'),
                  _StatusChip(icon: Icons.phone_android, label: 'Mobile'),
                  _StatusChip(icon: Icons.palette, label: 'Material'),
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
