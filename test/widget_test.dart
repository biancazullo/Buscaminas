import 'package:buscaminas_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the initial Buscaminas shell', (tester) async {
    await tester.pumpWidget(const BuscaminasApp());

    expect(find.byKey(const ValueKey('app-logo')), findsOneWidget);
    expect(find.byKey(const ValueKey('app-title')), findsOneWidget);
    expect(find.text('Buscaminas Flutter'), findsWidgets);
    expect(find.text('MVVM'), findsOneWidget);
    expect(find.text('Repositorios'), findsOneWidget);
    expect(find.text('Dominio'), findsOneWidget);
  });
}
