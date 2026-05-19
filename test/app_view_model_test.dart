import 'package:buscaminas_flutter/data/repositories/settings_repository.dart';
import 'package:buscaminas_flutter/data/services/settings_storage_service.dart';
import 'package:buscaminas_flutter/domain/models/models.dart';
import 'package:buscaminas_flutter/ui/core/view_models/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppViewModel', () {
    test('loads, exposes theme mode, and persists updates', () async {
      final storageService = InMemorySettingsStorageService();
      await storageService.writeSettings(
        const GameSettings(
          difficulty: Difficulty.medium,
          themePreference: ThemePreference.dark,
          numberStyle: NumberStyle.colorful,
          animationsEnabled: false,
        ),
      );
      final viewModel = AppViewModel(
        settingsRepository: SettingsRepository(storageService: storageService),
      );
      var notifications = 0;
      viewModel.addListener(() => notifications += 1);

      final loadFuture = viewModel.load();

      expect(viewModel.isLoading, isTrue);
      await loadFuture;

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.settings.difficulty, Difficulty.medium);
      expect(viewModel.settings.numberStyle, NumberStyle.colorful);
      expect(viewModel.themeMode, ThemeMode.dark);
      expect(notifications, greaterThanOrEqualTo(2));

      const updatedSettings = GameSettings(
        difficulty: Difficulty.hard,
        themePreference: ThemePreference.light,
        soundEnabled: true,
      );

      await viewModel.updateSettings(updatedSettings);

      expect(viewModel.settings, updatedSettings);
      expect(viewModel.themeMode, ThemeMode.light);
      expect(await storageService.readSettings(), updatedSettings);
    });
  });
}
