import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/domain/model/team.dart';
import 'package:tabu/domain/model/player.dart';
import 'package:tabu/domain/model/word.dart';
import 'package:tabu/domain/model/game_config.dart';

// Hard-coded game until the setup screen exists.
GameState sampleGame() {
  var anakin = Player(name: 'Anakin', id: 1);
  var obiwan = Player(name: 'Obi Wan Kenobi', id: 2);

  var maul = Player(name: 'Darth Maul', id: 3);
  var sidious = Player(name: 'Darth Sidious', id: 4);

  var jedi = Team(name: 'Jedi', players: [anakin, obiwan], score: 0);
  var sith = Team(name: 'Sith', players: [maul, sidious], score: 0);

  var war = Word(
    text: 'War',
    forbiddenWords: ['light', 'dark', 'saber'],
    difficulty: 2,
  );
  var force = Word(
    text: 'Force',
    forbiddenWords: ['jedi', 'sith', 'push'],
    difficulty: 3,
  );

  var darkside = Word(
    text: 'darkside',
    forbiddenWords: ['lightside', 'side', 'jedi'],
    difficulty: 3,
  );

  var holocron = Word(
    text: 'holocron',
    forbiddenWords: ['jedi', 'younglings', 'archive'],
    difficulty: 4,
  );

  var lightsaber = Word(
    text: 'lightsaber',
    forbiddenWords: ['jedi', 'sith', 'darth vader'],
    difficulty: 2,
  );

  var config = GameConfig(
    roundSeconds: 60,
    targetScore: 10,
    passLimit: 3,
    teams: [jedi, sith],
  );

  var words = [force, war, darkside, holocron, lightsaber, ..._extraWords]
    ..shuffle();

  return GameState.initial(config, words);
}

Word _word(String text, List<String> forbidden) =>
    Word(text: text, forbiddenWords: forbidden, difficulty: 2);

final _extraWords = [
  _word('Coffee', ['drink', 'morning', 'bean', 'cup', 'caffeine']),
  _word('Beach', ['sand', 'sea', 'summer', 'sun', 'swim']),
  _word('Guitar', ['music', 'strings', 'play', 'rock', 'instrument']),
  _word('Passport', ['travel', 'border', 'country', 'photo', 'visa']),
  _word('Volcano', ['lava', 'eruption', 'mountain', 'hot', 'ash']),
  _word('Library', ['books', 'read', 'quiet', 'borrow', 'shelf']),
  _word('Snowman', ['winter', 'cold', 'carrot', 'build', 'white']),
  _word('Rainbow', ['colors', 'rain', 'sky', 'sun', 'arc']),
  _word('Keyboard', ['type', 'keys', 'computer', 'letters', 'piano']),
  _word('Pizza', ['italy', 'cheese', 'slice', 'oven', 'dough']),
  _word('Astronaut', ['space', 'rocket', 'moon', 'nasa', 'suit']),
  _word('Umbrella', ['rain', 'wet', 'open', 'weather', 'cover']),
  _word('Birthday', ['cake', 'candles', 'party', 'gift', 'age']),
  _word('Elevator', ['floor', 'up', 'down', 'button', 'building']),
  _word('Penguin', ['bird', 'ice', 'antarctica', 'black', 'waddle']),
  _word('Chess', ['king', 'queen', 'board', 'checkmate', 'pawn']),
  _word('Vienna', ['austria', 'capital', 'city', 'danube', 'europe']),
  _word('Debugging', ['bug', 'code', 'error', 'fix', 'program']),
];
