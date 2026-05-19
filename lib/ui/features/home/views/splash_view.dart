import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({
    super.key,
    required this.onFinished,
    required this.animationsEnabled,
  });

  final VoidCallback onFinished;
  final bool animationsEnabled;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2300), _finish);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _finish() {
    if (_finished) {
      return;
    }

    _finished = true;
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final logo = _SplashLogo(
      animationsEnabled: widget.animationsEnabled,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.primary, width: 3),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.16),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Icon(
            Icons.grid_view_rounded,
            key: const ValueKey('splash-logo'),
            size: 104,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.primaryContainer.withValues(alpha: 0.42),
            ],
          ),
        ),
        child: Stack(
          children: [
            const _PixelBackdrop(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    logo,
                    const SizedBox(height: 24),
                    _AnimatedEntrance(
                      animationsEnabled: widget.animationsEnabled,
                      delay: 180,
                      child: Text(
                        'Buscaminas Flutter',
                        key: const ValueKey('splash-title'),
                        textAlign: TextAlign.center,
                        style: textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _AnimatedEntrance(
                      animationsEnabled: widget.animationsEnabled,
                      delay: 320,
                      child: Text(
                        'Descubre, marca y sobrevive.',
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    key: const ValueKey('skip-splash-button'),
                    onPressed: _finish,
                    child: const Text('Saltar'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo({required this.animationsEnabled, required this.child});

  final bool animationsEnabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!animationsEnabled) {
      return child;
    }

    return Pulse(
      infinite: true,
      duration: const Duration(milliseconds: 1400),
      child: FadeInDown(
        duration: const Duration(milliseconds: 650),
        child: child,
      ),
    );
  }
}

class _AnimatedEntrance extends StatelessWidget {
  const _AnimatedEntrance({
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

    return FadeInUp(
      delay: Duration(milliseconds: delay),
      duration: const Duration(milliseconds: 550),
      child: child,
    );
  }
}

class _PixelBackdrop extends StatelessWidget {
  const _PixelBackdrop();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _PixelBackdropPainter(
            color: colorScheme.primary.withValues(alpha: 0.10),
            accentColor: colorScheme.tertiary.withValues(alpha: 0.14),
          ),
        ),
      ),
    );
  }
}

class _PixelBackdropPainter extends CustomPainter {
  const _PixelBackdropPainter({required this.color, required this.accentColor});

  final Color color;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    const block = 28.0;

    for (var index = 0; index < 18; index += 1) {
      final x = (index * 73) % (size.width + block) - block;
      final y = (index * 47) % (size.height + block) - block;
      paint.color = index.isEven ? color : accentColor;
      canvas.drawRect(Rect.fromLTWH(x, y, block, block), paint);
    }
  }

  @override
  bool shouldRepaint(_PixelBackdropPainter oldDelegate) {
    return color != oldDelegate.color || accentColor != oldDelegate.accentColor;
  }
}
