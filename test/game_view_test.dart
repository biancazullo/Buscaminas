import 'dart:math';

import 'package:buscaminas_flutter/data/repositories/high_score_repository.dart';
import 'package:buscaminas_flutter/data/services/high_score_storage_service.dart';
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

  testWidgets('shows victory overlay and continues to the finished board', (
    tester,
  ) async {
    const settings = GameSettings(
      difficulty: Difficulty.easy,
      animationsEnabled: false,
    );
    final viewModel = GameViewModel(
      initialSettings: settings,
      engine: _ScriptedResultEngine(GameStatus.won),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: GameView(viewModel: viewModel, settings: settings),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('cell-0-0')));
    await tester.pump();

    expect(find.byKey(const ValueKey('result-overlay')), findsOneWidget);
    expect(find.text('Ganaste'), findsOneWidget);
    expect(find.text('9s'), findsWidgets);
    expect(find.text('1'), findsWidgets);
    expect(find.text('Facil'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('continue-result-button')));
    await tester.pump();

    expect(find.byKey(const ValueKey('result-overlay')), findsNothing);
    expect(find.text('Victoria'), findsOneWidget);
  });

  testWidgets('records a victory as a new high score', (tester) async {
    const settings = GameSettings(
      difficulty: Difficulty.easy,
      animationsEnabled: false,
    );
    final repository = HighScoreRepository(
      storageService: InMemoryHighScoreStorageService(),
    );
    final viewModel = GameViewModel(
      initialSettings: settings,
      engine: _ScriptedResultEngine(GameStatus.won),
      highScoreRepository: repository,
      now: () => DateTime(2026, 5, 19),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: GameView(viewModel: viewModel, settings: settings),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('cell-0-0')));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const ValueKey('new-record-label')), findsOneWidget);

    final scores = await repository.loadScores(Difficulty.easy);
    expect(scores, hasLength(1));
    expect(scores.single.elapsedSeconds, 9);
    expect(scores.single.attempts, 1);
  });

  testWidgets('shows defeat overlay and retries the same difficulty', (
    tester,
  ) async {
    const settings = GameSettings(
      difficulty: Difficulty.easy,
      animationsEnabled: false,
    );
    final viewModel = GameViewModel(
      initialSettings: settings,
      engine: _ScriptedResultEngine(GameStatus.lost),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: GameView(viewModel: viewModel, settings: settings),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('cell-0-0')));
    await tester.pump();

    expect(find.byKey(const ValueKey('result-overlay')), findsOneWidget);
    expect(find.text('Perdiste'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('retry-result-button')));
    await tester.pump();

    expect(find.byKey(const ValueKey('result-overlay')), findsNothing);
    expect(find.text('Partida lista'), findsOneWidget);
    expect(_textForKey(tester, const ValueKey('attempts-value')), '0');
  });
}

String _textForKey(WidgetTester tester, Key key) {
  final text = tester.widget<Text>(find.byKey(key));
  return text.data ?? '';
}

class _ScriptedResultEngine extends MinesweeperEngine {
  _ScriptedResultEngine(this.result);

  final GameStatus result;

  @override
  BoardState revealCell(
    BoardState board,
    int row,
    int column, {
    DateTime? now,
  }) {
    return board.copyWith(
      status: result,
      attempts: board.attempts + 1,
      elapsedSeconds: 9,
      startedAt: now ?? DateTime(2026),
    );
  }
}
