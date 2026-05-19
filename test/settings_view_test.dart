import 'package:buscaminas_flutter/data/repositories/settings_repository.dart';
import 'package:buscaminas_flutter/data/services/settings_storage_service.dart';
import 'package:buscaminas_flutter/domain/models/models.dart';
import 'package:buscaminas_flutter/ui/core/view_models/app_view_model.dart';
import 'package:buscaminas_flutter/ui/features/settings/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('updates settings immediately from the settings screen', (
    tester,
  ) async {
    final appViewModel = AppViewModel(
      settingsRepository: SettingsRepository(
        storageService: InMemorySettingsStorageService(),
      ),
    );
    await appViewModel.load();

    await tester.pumpWidget(
      MaterialApp(home: SettingsView(appViewModel: appViewModel)),
    );

    expect(find.byKey(const ValueKey('settings-list')), findsOneWidget);
    expect(appViewModel.settings.difficulty, Difficulty.easy);
    expect(appViewModel.settings.themePreference, ThemePreference.system);
    expect(appViewModel.settings.numberStyle, NumberStyle.classic);
    expect(appViewModel.settings.animationsEnabled, isTrue);
    expect(appViewModel.settings.soundEnabled, isFalse);

    await tester.tap(find.text('Dificil'));
    await tester.pump();
    expect(appViewModel.settings.difficulty, Difficulty.hard);

    await tester.tap(find.text('Oscuro'));
    await tester.pump();
    expect(appViewModel.settings.themePreference, ThemePreference.dark);

    await tester.tap(find.byKey(const ValueKey('number-style-retro')));
    await tester.pump();
    expect(appViewModel.settings.numberStyle, NumberStyle.retro);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('animations-switch')),
      280,
    );
    await tester.tap(find.byKey(const ValueKey('animations-switch')));
    await tester.pump();
    expect(appViewModel.settings.animationsEnabled, isFalse);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('sound-switch')),
      120,
    );
    await tester.tap(find.byKey(const ValueKey('sound-switch')));
    await tester.pump();
    expect(appViewModel.settings.soundEnabled, isTrue);
  });
}
