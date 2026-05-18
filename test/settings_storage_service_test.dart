import 'package:buscaminas_flutter/data/services/settings_storage_service.dart';
import 'package:buscaminas_flutter/domain/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesSettingsStorageService', () {
    test('returns default settings when storage is empty', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final service = SharedPreferencesSettingsStorageService(
        preferences: preferences,
      );

      final settings = await service.readSettings();

      expect(settings, const GameSettings());
    });

    test('persists every game setting', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final service = SharedPreferencesSettingsStorageService(
        preferences: preferences,
      );
      const savedSettings = GameSettings(
        difficulty: Difficulty.hard,
        themePreference: ThemePreference.dark,
        numberStyle: NumberStyle.retro,
        soundEnabled: true,
        animationsEnabled: false,
      );

      await service.writeSettings(savedSettings);
      final loadedSettings = await service.readSettings();

      expect(loadedSettings, savedSettings);
    });
  });
}
