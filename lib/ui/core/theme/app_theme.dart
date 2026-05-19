import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color seedColor = Color(0xFF1D6B7A);

  static ThemeData light() {
    return _buildTheme(Brightness.light);
  }

  static ThemeData dark() {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    final colorScheme = baseScheme.copyWith(
      secondary: brightness == Brightness.light
          ? const Color(0xFF856404)
          : const Color(0xFFE8C66A),
      tertiary: brightness == Brightness.light
          ? const Color(0xFFC64E3A)
          : const Color(0xFFFFB4A6),
    );
    final baseTheme = ThemeData.from(colorScheme: colorScheme);

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: _zeroLetterSpacing(baseTheme.textTheme),
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(180, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(180, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: colorScheme.outline),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: baseTheme.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: colorScheme.outlineVariant),
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbIcon: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(Icons.check_rounded);
          }
          return null;
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
    );
  }

  static TextTheme _zeroLetterSpacing(TextTheme textTheme) {
    return textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(letterSpacing: 0),
      displayMedium: textTheme.displayMedium?.copyWith(letterSpacing: 0),
      displaySmall: textTheme.displaySmall?.copyWith(letterSpacing: 0),
      headlineLarge: textTheme.headlineLarge?.copyWith(letterSpacing: 0),
      headlineMedium: textTheme.headlineMedium?.copyWith(letterSpacing: 0),
      headlineSmall: textTheme.headlineSmall?.copyWith(letterSpacing: 0),
      titleLarge: textTheme.titleLarge?.copyWith(letterSpacing: 0),
      titleMedium: textTheme.titleMedium?.copyWith(letterSpacing: 0),
      titleSmall: textTheme.titleSmall?.copyWith(letterSpacing: 0),
      bodyLarge: textTheme.bodyLarge?.copyWith(letterSpacing: 0),
      bodyMedium: textTheme.bodyMedium?.copyWith(letterSpacing: 0),
      bodySmall: textTheme.bodySmall?.copyWith(letterSpacing: 0),
      labelLarge: textTheme.labelLarge?.copyWith(letterSpacing: 0),
      labelMedium: textTheme.labelMedium?.copyWith(letterSpacing: 0),
      labelSmall: textTheme.labelSmall?.copyWith(letterSpacing: 0),
    );
  }
}
