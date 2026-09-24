import 'package:flutter_test/flutter_test.dart';
import 'package:tabu/domain/game/game.dart';
import 'package:tabu/domain/game/game_event.dart';
import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/domain/model/team.dart';
import 'package:tabu/domain/model/player.dart';
import 'package:tabu/domain/model/word.dart';
import 'package:tabu/domain/model/game_config.dart';

GameState sampleState() {
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

  var config = GameConfig(
    roundSeconds: 60,
    targetScore: 30,
    passLimit: 3,
    players: [anakin, obiwan, maul, sidious],
  );

  return GameState(
    config: config,
    teams: [jedi, sith],
    activeTeamIndex: 0,
    currentWord: Word(
      text: 'Star',
      forbiddenWords: ['sky', 'galaxy', 'universe'],
      difficulty: 2,
    ),
    remainingWords: [war, force],
    remainingPasses: 3,
    remainingSeconds: 60,
    isFinished: false,
  );
}

void main() {
  test('Correct increases active team score by 1', () {
    // Verilen
    var state = sampleState();

    var result = apply(state, Correct());

    // Beklenen
    expect(result.teams[0].score, 1);
  });

  test('Correct on last word ends the game without crashing', () {
    var state = sampleState().copyWith(remainingWords: []);
    // Yapılan
    var result = apply(state, Correct());
    //Beklenen
    expect(result.isFinished, true);
    expect(result.teams[0].score, 1);
  });
}
