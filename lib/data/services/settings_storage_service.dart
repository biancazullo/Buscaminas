import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/difficulty.dart';
import '../../domain/models/game_settings.dart';
import '../../domain/models/number_style.dart';
import '../../domain/models/theme_preference.dart';

abstract class SettingsStorageService {
  Future<GameSettings> readSettings();

  Future<void> writeSettings(GameSettings settings);
}

class InMemorySettingsStorageService implements SettingsStorageService {
  GameSettings _settings = const GameSettings();

  @override
  Future<GameSettings> readSettings() async {
    return _settings;
  }

  @override
  Future<void> writeSettings(GameSettings settings) async {
    _settings = settings;
  }
}

class SharedPreferencesSettingsStorageService
    implements SettingsStorageService {
  const SharedPreferencesSettingsStorageService({required this.preferences});

  static const String _difficultyKey = 'settings.difficulty';
  static const String _themePreferenceKey = 'settings.themePreference';
  static const String _numberStyleKey = 'settings.numberStyle';
  static const String _soundEnabledKey = 'settings.soundEnabled';
  static const String _animationsEnabledKey = 'settings.animationsEnabled';

  final SharedPreferences preferences;

  @override
  Future<GameSettings> readSettings() async {
    const defaults = GameSettings();

    return GameSettings(
      difficulty: DifficultyDetails.fromName(
        preferences.getString(_difficultyKey) ?? defaults.difficulty.name,
      ),
      themePreference: ThemePreferenceDetails.fromName(
        preferences.getString(_themePreferenceKey) ??
            defaults.themePreference.name,
      ),
      numberStyle: NumberStyleDetails.fromName(
        preferences.getString(_numberStyleKey) ?? defaults.numberStyle.name,
      ),
      soundEnabled:
          preferences.getBool(_soundEnabledKey) ?? defaults.soundEnabled,
      animationsEnabled:
          preferences.getBool(_animationsEnabledKey) ??
          defaults.animationsEnabled,
    );
  }

  @override
  Future<void> writeSettings(GameSettings settings) async {
    await Future.wait([
      preferences.setString(_difficultyKey, settings.difficulty.name),
      preferences.setString(_themePreferenceKey, settings.themePreference.name),
      preferences.setString(_numberStyleKey, settings.numberStyle.name),
      preferences.setBool(_soundEnabledKey, settings.soundEnabled),
      preferences.setBool(_animationsEnabledKey, settings.animationsEnabled),
    ]);
  }
}
