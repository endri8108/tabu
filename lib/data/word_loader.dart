import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tabu/domain/model/word.dart';

const wordListAsset = 'assets/words/en.json';

// Reads the bundled general word list (about 2,200 cards).
Future<List<Word>> loadWords() async {
  var json = await rootBundle.loadString(wordListAsset);
  return parseWords(json);
}

// Each card in the file looks like:
// {"word": "Sun", "forbidden": ["bright", "hot", ...], "difficulty": 1, "category": "mixed"}
List<Word> parseWords(String json) {
  var cards = jsonDecode(json) as List;

  return [
    for (var card in cards)
      Word(
        text: card['word'],
        forbiddenWords: List<String>.from(card['forbidden']),
        difficulty: card['difficulty'],
      ),
  ];
}
