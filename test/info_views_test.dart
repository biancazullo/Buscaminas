import 'package:buscaminas_flutter/main.dart';
import 'package:buscaminas_flutter/ui/features/info/views/credits_view.dart';
import 'package:buscaminas_flutter/ui/features/info/views/instructions_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('instructions screen explains the game rules', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: InstructionsView()));

    expect(find.byKey(const ValueKey('instructions-view')), findsOneWidget);
    expect(find.text('Objetivo'), findsOneWidget);
    expect(
      find.text('Descubre todas las casillas sin tocar una mina.'),
      findsOneWidget,
    );
    expect(find.text('Como jugar'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Dificultades'), 320);

    expect(find.text('Dificultades'), findsOneWidget);
    expect(find.text('Facil'), findsOneWidget);
    expect(find.text('Medio'), findsOneWidget);
    expect(find.text('Dificil'), findsOneWidget);
  });

  testWidgets('credits screen shows generic project credits', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreditsView()));

    expect(find.byKey(const ValueKey('credits-view')), findsOneWidget);
    expect(find.text('Buscaminas Flutter'), findsOneWidget);
    expect(find.text('Micro-proyecto Flutter'), findsOneWidget);
    expect(find.text('Desarrollo'), findsOneWidget);
    expect(find.text('Periodo'), findsOneWidget);
    expect(find.text('2526-3'), findsOneWidget);
  });

  testWidgets('main menu opens instructions and credits screens', (
    tester,
  ) async {
    await tester.pumpWidget(const BuscaminasApp());

    await tester.tap(find.byKey(const ValueKey('skip-splash-button')));
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byKey(const ValueKey('instructions-menu-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('instructions-view')), findsOneWidget);
    expect(find.text('Como jugar'), findsOneWidget);

    Navigator.of(tester.element(find.byType(InstructionsView))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('credits-menu-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('credits-view')), findsOneWidget);
    expect(find.text('Micro-proyecto Flutter'), findsOneWidget);
  });
}
