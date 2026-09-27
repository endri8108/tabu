import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/domain/model/team.dart';
import 'package:tabu/domain/model/player.dart';
import 'package:tabu/domain/model/word.dart';
import 'package:tabu/domain/model/game_config.dart';

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
    forbiddenWords: ['jedi', 'younglings', ''],
    difficulty: 4,
  );

  var lightsaber = Word(
    text: 'lightsaber',
    forbiddenWords: ['jedi', 'sith', 'darth vader'],
    difficulty: 2,
  );

  var config = GameConfig(
    roundSeconds: 60,
    targetScore: 30,
    passLimit: 3,
    teams: [jedi, sith],
  );

  var words = [force, war, darkside, holocron, lightsaber];

  return GameState.initial(config, words);
}
