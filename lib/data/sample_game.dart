import 'dart:math';

import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/domain/model/team.dart';
import 'package:tabu/domain/model/player.dart';
import 'package:tabu/domain/model/word.dart';
import 'package:tabu/domain/model/game_config.dart';

// Hard-coded teams until the setup screen exists; the cards come from the
// word list and are shuffled for every game, and a random team starts.
GameState sampleGame(List<Word> words) {
  var anakin = Player(name: 'Anakin', id: 1);
  var obiwan = Player(name: 'Obi Wan Kenobi', id: 2);

  var maul = Player(name: 'Darth Maul', id: 3);
  var sidious = Player(name: 'Darth Sidious', id: 4);

  var jedi = Team(name: 'Jedi', players: [anakin, obiwan], score: 0);
  var sith = Team(name: 'Sith', players: [maul, sidious], score: 0);

  var config = GameConfig(
    roundSeconds: 60,
    targetScore: 10,
    passLimit: 3,
    teams: [jedi, sith],
  );

  return GameState.initial(
    config,
    List.of(words)..shuffle(),
    startingTeamIndex: Random().nextInt(config.teams.length),
  );
}
