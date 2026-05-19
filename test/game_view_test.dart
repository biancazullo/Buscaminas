import 'dart:math';

import 'package:buscaminas_flutter/domain/models/models.dart';
import 'package:buscaminas_flutter/domain/use_cases/minesweeper_engine.dart';
import 'package:buscaminas_flutter/ui/features/game/view_models/game_view_model.dart';
import 'package:buscaminas_flutter/ui/features/game/views/game_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('flags cells and reveals safe cells from the board', (
    tester,
  ) async {
    const settings = GameSettings(
      difficulty: Difficulty.easy,
      animationsEnabled: false,
    );
    final viewModel = GameViewModel(
      initialSettings: settings,
      engine: MinesweeperEngine(random: Random(7)),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: GameView(viewModel: viewModel, settings: settings),
      ),
    );

    expect(find.byKey(const ValueKey('game-board')), findsOneWidget);
    expect(find.byKey(const ValueKey('cell-0-0')), findsOneWidget);
    expect(find.text('0s'), findsOneWidget);
    expect(find.byKey(const ValueKey('remaining-mines-value')), findsOneWidget);
    expect(_textForKey(tester, const ValueKey('remaining-mines-value')), '10');
    expect(_textForKey(tester, const ValueKey('attempts-value')), '0');

    await tester.longPress(find.byKey(const ValueKey('cell-0-0')));
    await tester.pump();

    expect(find.byIcon(Icons.flag_rounded), findsOneWidget);
    expect(_textForKey(tester, const ValueKey('remaining-mines-value')), '9');

    await tester.longPress(find.byKey(const ValueKey('cell-0-0')));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('cell-0-0')));
    await tester.pump();

    expect(find.byIcon(Icons.flag_rounded), findsNothing);
    expect(_textForKey(tester, const ValueKey('attempts-value')), '1');
    expect(_textForKey(tester, const ValueKey('remaining-mines-value')), '10');
  });
}

String _textForKey(WidgetTester tester, Key key) {
  final text = tester.widget<Text>(find.byKey(key));
  return text.data ?? '';
}
