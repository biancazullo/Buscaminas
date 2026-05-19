import 'package:buscaminas_flutter/data/repositories/high_score_repository.dart';
import 'package:buscaminas_flutter/data/services/high_score_storage_service.dart';
import 'package:buscaminas_flutter/domain/models/models.dart';
import 'package:buscaminas_flutter/ui/features/high_scores/view_models/high_scores_view_model.dart';
import 'package:buscaminas_flutter/ui/features/high_scores/views/high_scores_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows sorted scores and clears them with confirmation', (
    tester,
  ) async {
    final repository = HighScoreRepository(
      storageService: InMemoryHighScoreStorageService(),
    );
    await repository.recordScore(
      ScoreEntry(
        difficulty: Difficulty.easy,
        elapsedSeconds: 35,
        attempts: 8,
        playedAt: DateTime(2026, 5, 18),
      ),
    );
    await repository.recordScore(
      ScoreEntry(
        difficulty: Difficulty.easy,
        elapsedSeconds: 20,
        attempts: 5,
        playedAt: DateTime(2026, 5, 19),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: HighScoresView(
          viewModel: HighScoresViewModel(highScoreRepository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('scores-list-easy')), findsOneWidget);
    expect(find.text('Puesto #1'), findsOneWidget);
    expect(find.text('20s'), findsOneWidget);
    expect(find.text('35s'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('clear-scores-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-clear-scores-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('empty-scores-message')), findsOneWidget);
  });
}
