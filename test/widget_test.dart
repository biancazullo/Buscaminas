import 'package:buscaminas_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders splash and opens the main menu', (tester) async {
    await tester.pumpWidget(const BuscaminasApp());

    expect(find.byKey(const ValueKey('splash-logo')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash-title')), findsOneWidget);
    expect(find.text('Buscaminas Flutter'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('skip-splash-button')));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byKey(const ValueKey('main-menu')), findsOneWidget);
    expect(find.byKey(const ValueKey('play-menu-button')), findsOneWidget);
    expect(find.text('Jugar'), findsOneWidget);
    expect(find.text('Marcadores'), findsOneWidget);
    expect(find.text('Configuracion'), findsOneWidget);
    expect(find.text('Instrucciones'), findsOneWidget);
  });

  testWidgets('starts a game from the difficulty selector', (tester) async {
    await tester.pumpWidget(const BuscaminasApp());

    await tester.tap(find.byKey(const ValueKey('skip-splash-button')));
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Jugar'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('difficulty-title')), findsOneWidget);
    expect(find.text('Facil'), findsOneWidget);
    expect(find.text('Medio'), findsOneWidget);
    expect(find.text('Dificil'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('difficulty-hard-option')));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('start-selected-game-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('game-view')), findsOneWidget);
    expect(find.text('Partida Dificil'), findsOneWidget);
    expect(find.text('10x10'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
  });

  testWidgets('opens scores and settings from the main menu', (tester) async {
    await tester.pumpWidget(const BuscaminasApp());

    await tester.tap(find.byKey(const ValueKey('skip-splash-button')));
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byKey(const ValueKey('scores-menu-button')));
    await tester.pumpAndSettle();

    expect(find.text('Marcadores'), findsOneWidget);
    expect(find.byKey(const ValueKey('empty-scores-message')), findsOneWidget);

    Navigator.of(tester.element(find.byType(Scaffold))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('settings-menu-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('settings-list')), findsOneWidget);
    expect(find.text('Configuracion'), findsOneWidget);

    await tester.tap(find.text('Oscuro'));
    await tester.pump();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
  });
}
