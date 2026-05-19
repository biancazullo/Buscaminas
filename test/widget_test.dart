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
}
