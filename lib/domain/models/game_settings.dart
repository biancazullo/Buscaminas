import 'difficulty.dart';
import 'number_style.dart';
import 'theme_preference.dart';

class GameSettings {
  const GameSettings({
    this.difficulty = Difficulty.easy,
    this.themePreference = ThemePreference.system,
    this.numberStyle = NumberStyle.classic,
    this.soundEnabled = false,
    this.animationsEnabled = true,
  });

  final Difficulty difficulty;
  final ThemePreference themePreference;
  final NumberStyle numberStyle;
  final bool soundEnabled;
  final bool animationsEnabled;

  GameSettings copyWith({
    Difficulty? difficulty,
    ThemePreference? themePreference,
    NumberStyle? numberStyle,
    bool? soundEnabled,
    bool? animationsEnabled,
  }) {
    return GameSettings(
      difficulty: difficulty ?? this.difficulty,
      themePreference: themePreference ?? this.themePreference,
      numberStyle: numberStyle ?? this.numberStyle,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GameSettings &&
        other.difficulty == difficulty &&
        other.themePreference == themePreference &&
        other.numberStyle == numberStyle &&
        other.soundEnabled == soundEnabled &&
        other.animationsEnabled == animationsEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      difficulty,
      themePreference,
      numberStyle,
      soundEnabled,
      animationsEnabled,
    );
  }
}
