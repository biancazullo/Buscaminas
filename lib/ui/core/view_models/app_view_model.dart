import 'package:flutter/material.dart';

import '../../../data/repositories/settings_repository.dart';
import '../../../domain/models/game_settings.dart';
import '../../../domain/models/theme_preference.dart';

class AppViewModel extends ChangeNotifier {
  AppViewModel({required this.settingsRepository});

  final SettingsRepository settingsRepository;

  GameSettings _settings = const GameSettings();
  bool _isLoading = false;

  GameSettings get settings => _settings;

  bool get isLoading => _isLoading;

  ThemeMode get themeMode {
    return switch (_settings.themePreference) {
      ThemePreference.system => ThemeMode.system,
      ThemePreference.light => ThemeMode.light,
      ThemePreference.dark => ThemeMode.dark,
    };
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _settings = await settingsRepository.loadSettings();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSettings(GameSettings settings) async {
    _settings = settings;
    notifyListeners();
    await settingsRepository.saveSettings(settings);
  }
}
