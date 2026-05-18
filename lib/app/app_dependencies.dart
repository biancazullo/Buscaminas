import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/high_score_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/services/high_score_storage_service.dart';
import '../data/services/settings_storage_service.dart';
import '../ui/core/view_models/app_view_model.dart';
import '../ui/features/game/view_models/game_view_model.dart';
import '../ui/features/high_scores/view_models/high_scores_view_model.dart';
import '../ui/features/settings/view_models/settings_view_model.dart';

class AppDependencies {
  AppDependencies({
    required this.settingsRepository,
    required this.highScoreRepository,
  });

  factory AppDependencies.memory() {
    final settingsStorageService = InMemorySettingsStorageService();
    final highScoreStorageService = InMemoryHighScoreStorageService();

    return AppDependencies(
      settingsRepository: SettingsRepository(
        storageService: settingsStorageService,
      ),
      highScoreRepository: HighScoreRepository(
        storageService: highScoreStorageService,
      ),
    );
  }

  static Future<AppDependencies> persistent() async {
    final preferences = await SharedPreferences.getInstance();
    final settingsStorageService = SharedPreferencesSettingsStorageService(
      preferences: preferences,
    );
    final highScoreStorageService = InMemoryHighScoreStorageService();

    return AppDependencies(
      settingsRepository: SettingsRepository(
        storageService: settingsStorageService,
      ),
      highScoreRepository: HighScoreRepository(
        storageService: highScoreStorageService,
      ),
    );
  }

  final SettingsRepository settingsRepository;
  final HighScoreRepository highScoreRepository;

  AppViewModel createAppViewModel() {
    return AppViewModel(settingsRepository: settingsRepository);
  }

  SettingsViewModel createSettingsViewModel() {
    return SettingsViewModel(settingsRepository: settingsRepository);
  }

  GameViewModel createGameViewModel() {
    return GameViewModel();
  }

  HighScoresViewModel createHighScoresViewModel() {
    return HighScoresViewModel(highScoreRepository: highScoreRepository);
  }
}

class AppDependenciesScope extends InheritedWidget {
  const AppDependenciesScope({
    super.key,
    required this.dependencies,
    required super.child,
  });

  final AppDependencies dependencies;

  static AppDependencies of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppDependenciesScope>();

    assert(scope != null, 'AppDependenciesScope was not found in the tree.');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(AppDependenciesScope oldWidget) {
    return dependencies != oldWidget.dependencies;
  }
}
