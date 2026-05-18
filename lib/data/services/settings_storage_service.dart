import '../../domain/models/game_settings.dart';

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
