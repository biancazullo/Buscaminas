import '../../domain/models/game_settings.dart';
import '../services/settings_storage_service.dart';

class SettingsRepository {
  const SettingsRepository({required this.storageService});

  final SettingsStorageService storageService;

  Future<GameSettings> loadSettings() {
    return storageService.readSettings();
  }

  Future<void> saveSettings(GameSettings settings) {
    return storageService.writeSettings(settings);
  }
}
