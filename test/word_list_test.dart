import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabu/data/word_loader.dart';
import 'package:tabu/domain/model/word.dart';

// Guards the word list files so a bad edit is caught before anyone plays it.
void main() {
  var general = parseWords(File(wordListAsset).readAsStringSync());

  // The general list plus every mode file in assets/words/modes/.
  var files = {
    wordListAsset: general,
    for (var file in Directory('assets/words/modes').listSync())
      if (file.path.endsWith('.json'))
        file.path: parseWords(File(file.path).readAsStringSync()),
  };
  var all = [for (var words in files.values) ...words];

  test('the general list has at least 2000 cards', () {
    expect(general.length, greaterThanOrEqualTo(2000));
  });

  test('every card has 5 different forbidden words', () {
    for (var word in all) {
      var unique = word.forbiddenWords.map((f) => f.toLowerCase()).toSet();
      expect(unique.length, 5, reason: word.text);
    }
  });

  test('no card appears twice, not even across files', () {
    // "Paint brush" and "Paintbrush" count as the same card.
    String key(Word word) =>
        word.text.toLowerCase().replaceAll(RegExp(r'[\s-]+'), '');

    var seen = <String>{};
    for (var word in all) {
      expect(seen.add(key(word)), true, reason: word.text);
    }
  });

  test('no forbidden word contains a part of the card itself', () {
    List<String> parts(String text) =>
        text.toLowerCase().split(RegExp(r'[\s-]+'));

    for (var word in all) {
      var cardParts = parts(word.text).where((p) => p.length > 2);
      for (var forbidden in word.forbiddenWords) {
        var hit = parts(forbidden).any(cardParts.contains);
        expect(hit, false, reason: '${word.text} -> $forbidden');
      }
    }
  });

  test('difficulty is 1, 2 or 3', () {
    for (var word in all) {
      expect([1, 2, 3], contains(word.difficulty), reason: word.text);
    }
  });
}
