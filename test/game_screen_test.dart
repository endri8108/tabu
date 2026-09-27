import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabu/ui/game_screen.dart';

// pumpAndSettle would keep running the turn clock until the turn ends,
// so after each tap we only let the short animations finish.
Future<void> settle(WidgetTester tester) =>
    tester.pump(const Duration(milliseconds: 500));

void main() {
  testWidgets('Start turn, press Correct, score goes up', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: GameScreen()));

    expect(find.text('Start turn'), findsOneWidget);
    await tester.tap(find.text('Start turn'));
    await settle(tester);

    expect(find.text('Correct'), findsOneWidget);
    await tester.tap(find.text('Correct'));
    await settle(tester);

    // Jedi's score (the active team) is now 1.
    expect(find.text('1'), findsOneWidget);

    // Remove the screen so its periodic timer is cancelled.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Pass button shows remaining passes', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: GameScreen()));
    await tester.tap(find.text('Start turn'));
    await settle(tester);

    await tester.tap(find.text('Pass (3)'));
    await settle(tester);

    expect(find.text('Pass (2)'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
