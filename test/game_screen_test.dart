import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabu/data/word_loader.dart';
import 'package:tabu/main.dart';
import 'package:tabu/ui/game_screen.dart';

// The real word list, read straight from the project folder.
final words = parseWords(File(wordListAsset).readAsStringSync());

// pumpAndSettle would keep running the turn clock until the turn ends,
// so after each tap we only let the short animations finish.
Future<void> settle(WidgetTester tester) =>
    tester.pump(const Duration(milliseconds: 500));

void main() {
  testWidgets('Start turn, press Correct, score goes up', (tester) async {
    await tester.pumpWidget(MaterialApp(home: GameScreen(words: words)));

    expect(find.text('Start turn'), findsOneWidget);
    await tester.tap(find.text('Start turn'));
    await settle(tester);

    expect(find.text('Correct'), findsOneWidget);
    await tester.tap(find.text('Correct'));
    await settle(tester);

    // The active team's score is now 1 (either team can start).
    expect(find.text('1'), findsOneWidget);

    // Remove the screen so its periodic timer is cancelled.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Pass button shows remaining passes', (tester) async {
    await tester.pumpWidget(MaterialApp(home: GameScreen(words: words)));
    await tester.tap(find.text('Start turn'));
    await settle(tester);

    await tester.tap(find.text('Pass (3)'));
    await settle(tester);

    expect(find.text('Pass (2)'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Theme button switches between light and dark', (tester) async {
    await tester.pumpWidget(TabooApp(words: words));

    Brightness brightness() =>
        Theme.of(tester.element(find.byType(GameScreen))).brightness;

    // Tests run with a light "phone setting".
    expect(brightness(), Brightness.light);

    await tester.tap(find.byTooltip('Switch theme'));
    await tester.pumpAndSettle(); // no turn running, so nothing keeps ticking
    expect(brightness(), Brightness.dark);

    await tester.tap(find.byTooltip('Switch theme'));
    await tester.pumpAndSettle(); // no turn running, so nothing keeps ticking
    expect(brightness(), Brightness.light);
  });
}
