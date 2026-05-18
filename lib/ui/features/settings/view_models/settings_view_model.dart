import 'package:flutter/foundation.dart';

import '../../../../data/repositories/settings_repository.dart';
import '../../../../domain/models/game_settings.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required this.settingsRepository});

  final SettingsRepository settingsRepository;

  GameSettings _settings = const GameSettings();
  bool _isLoading = false;

  GameSettings get settings => _settings;

  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _settings = await settingsRepository.loadSettings();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> save(GameSettings settings) async {
    _settings = settings;
    notifyListeners();
    await settingsRepository.saveSettings(settings);
  }
}
