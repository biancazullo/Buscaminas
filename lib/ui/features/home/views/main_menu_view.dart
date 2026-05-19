import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_dependencies.dart';
import '../../../core/view_models/app_view_model.dart';
import '../../game/views/difficulty_selection_view.dart';
import '../../high_scores/views/high_scores_view.dart';

class MainMenuView extends StatelessWidget {
  const MainMenuView({
    super.key,
    required this.animationsEnabled,
    required this.appViewModel,
  });

  final bool animationsEnabled;
  final AppViewModel appViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
        child: Stack(
          children: [
            const _MenuBackdrop(),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 760;
                  final menu = _MenuActions(
                    animationsEnabled: animationsEnabled,
                    appViewModel: appViewModel,
                  );

                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 980),
                        child: isWide
                            ? Row(
                                children: [
                                  const Expanded(child: _MenuHero()),
                                  const SizedBox(width: 40),
                                  SizedBox(width: 340, child: menu),
                                ],
                              )
                            : Column(
                                children: [
                                  const _MenuHero(),
                                  const SizedBox(height: 28),
                                  menu,
                                ],
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuHero extends StatelessWidget {
  const _MenuHero();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          key: const ValueKey('app-logo'),
          width: 146,
          height: 146,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: colorScheme.primary, width: 3),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.14),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(
            Icons.grid_view_rounded,
            size: 94,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Buscaminas Flutter',
          key: const ValueKey('app-title'),
          textAlign: TextAlign.center,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Evita las minas. Rompe tu record.',
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MenuActions extends StatelessWidget {
  const _MenuActions({
    required this.animationsEnabled,
    required this.appViewModel,
  });

  final bool animationsEnabled;
  final AppViewModel appViewModel;

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItem(
        key: const ValueKey('play-menu-button'),
        icon: Icons.play_arrow_rounded,
        label: 'Jugar',
        onPressed: () => _openDifficultySelection(context),
      ),
      _MenuItem(
        key: const ValueKey('scores-menu-button'),
        icon: Icons.emoji_events_rounded,
        label: 'Marcadores',
        onPressed: () => _openHighScores(context),
      ),
      _MenuItem(
        key: const ValueKey('settings-menu-button'),
        icon: Icons.tune_rounded,
        label: 'Configuracion',
        onPressed: () => _openPlaceholder(context, 'Configuracion'),
      ),
      _MenuItem(
        key: const ValueKey('instructions-menu-button'),
        icon: Icons.menu_book_rounded,
        label: 'Instrucciones',
        onPressed: () => _openPlaceholder(context, 'Instrucciones'),
      ),
      _MenuItem(
        key: const ValueKey('credits-menu-button'),
        icon: Icons.info_rounded,
        label: 'Creditos',
        onPressed: () => _openPlaceholder(context, 'Creditos'),
      ),
    ];

    return Column(
      key: const ValueKey('main-menu'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < items.length; index += 1) ...[
          _AnimatedMenuItem(
            animationsEnabled: animationsEnabled,
            delay: 90 * index,
            child: items[index],
          ),
          if (index != items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  void _openDifficultySelection(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DifficultySelectionView(appViewModel: appViewModel),
      ),
    );
  }

  void _openHighScores(BuildContext context) {
    final viewModel = AppDependenciesScope.of(
      context,
    ).createHighScoresViewModel();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HighScoresView(viewModel: viewModel),
      ),
    );
  }

  void _openPlaceholder(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlaceholderFeatureView(title: title),
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  const _MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 90),
      child: FilledButton.icon(
        onPressed: widget.onPressed,
        onHover: (isHovered) {
          if (!mounted) {
            return;
          }
          setState(() => _isPressed = isHovered);
        },
        onFocusChange: (isFocused) {
          if (!mounted) {
            return;
          }
          setState(() => _isPressed = isFocused);
        },
        icon: Icon(widget.icon),
        label: Text(widget.label),
      ),
    );
  }
}

class _AnimatedMenuItem extends StatelessWidget {
  const _AnimatedMenuItem({
    required this.animationsEnabled,
    required this.delay,
    required this.child,
  });

  final bool animationsEnabled;
  final int delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!animationsEnabled) {
      return child;
    }

    return FadeInRight(
      delay: Duration(milliseconds: delay),
      duration: const Duration(milliseconds: 420),
      child: child,
    );
  }
}

class PlaceholderFeatureView extends StatelessWidget {
  const PlaceholderFeatureView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.construction_rounded,
                  size: 72,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Esta seccion se completa en un siguiente tramo.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  key: const ValueKey('back-to-menu-button'),
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuBackdrop extends StatelessWidget {
  const _MenuBackdrop();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _MenuBackdropPainter(
            blockColor: colorScheme.primaryContainer.withValues(alpha: 0.28),
            cloudColor: colorScheme.secondaryContainer.withValues(alpha: 0.36),
          ),
        ),
      ),
    );
  }
}

class _MenuBackdropPainter extends CustomPainter {
  const _MenuBackdropPainter({
    required this.blockColor,
    required this.cloudColor,
  });

  final Color blockColor;
  final Color cloudColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = cloudColor;
    for (final offset in [
      Offset(size.width * 0.12, size.height * 0.16),
      Offset(size.width * 0.74, size.height * 0.20),
      Offset(size.width * 0.22, size.height * 0.78),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(offset.dx, offset.dy, 112, 34),
          const Radius.circular(10),
        ),
        paint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(offset.dx + 30, offset.dy - 18, 58, 34),
          const Radius.circular(10),
        ),
        paint,
      );
    }

    paint.color = blockColor;
    const block = 34.0;
    final bottom = size.height - block;
    for (var x = -block; x < size.width + block; x += block) {
      canvas.drawRect(Rect.fromLTWH(x, bottom, block - 2, block - 2), paint);
    }
  }

  @override
  bool shouldRepaint(_MenuBackdropPainter oldDelegate) {
    return blockColor != oldDelegate.blockColor ||
        cloudColor != oldDelegate.cloudColor;
  }
}
