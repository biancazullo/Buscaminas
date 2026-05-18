enum ThemePreference { system, light, dark }

extension ThemePreferenceDetails on ThemePreference {
  String get label {
    return switch (this) {
      ThemePreference.system => 'Automatico',
      ThemePreference.light => 'Claro',
      ThemePreference.dark => 'Oscuro',
    };
  }

  static ThemePreference fromName(String value) {
    for (final theme in ThemePreference.values) {
      if (theme.name == value) {
        return theme;
      }
    }

    return ThemePreference.system;
  }
}
