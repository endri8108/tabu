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
    teams: [jedi, sith],
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
    // Beklenen
    expect(result.isFinished, true);
    expect(result.teams[0].score, 1);
  });

  test('When the game is finished nothing must change after that.', () {
    var state = sampleState().copyWith(isFinished: true);

    var result = apply(state, Correct());

    expect(result.teams[0].score, 0);
  });

  test('copyWith can set currentWord to null', () {
    var state = sampleState();

    var result = state.copyWith(currentWord: () => null);

    expect(result.currentWord, null);
  });

  test('initial sets up a fresh game from config and words', () {
    var config = sampleState().config;
    var words = [
      Word(text: 'Apple', forbiddenWords: ['fruit', 'red'], difficulty: 1),
      Word(text: 'Train', forbiddenWords: ['rail', 'station'], difficulty: 1),
      Word(text: 'Moon', forbiddenWords: ['night', 'sky'], difficulty: 2),
    ];

    var result = GameState.initial(config, words);

    expect(result.currentWord, words[0]);
    expect(result.remainingWords.length, 2);
    expect(result.remainingSeconds, config.roundSeconds);
    expect(result.remainingPasses, config.passLimit);
    expect(result.activeTeamIndex, 0);
    expect(result.isFinished, false);
  });

  test('initial throws when word list is empty', () {
    var state = sampleState();
    expect(() => GameState.initial(state.config, []), throwsArgumentError);
  });

  test('Turn passes to the other team when time runs out', () {
    var state = sampleState().copyWith(remainingSeconds: 1);

    var result = apply(state, SecondTick());

    expect(result.activeTeamIndex, 1);
    expect(result.remainingSeconds, state.config.roundSeconds);
  });

  test('TurnEnded draws a new card', () {
    var state = sampleState();

    var result = apply(state, TurnEnded());

    expect(result.currentWord, state.remainingWords[0]);
  });

  test('First describer is the first player of the first team', () {
    var result = sampleState();
    expect(result.describer.name, 'Anakin');
  });

  group('describer rotation', () {
    // Big deck so the game doesn't end before we're done rotating.
    GameState stateWithBigDeck() {
      var state = sampleState();
      return state.copyWith(
        remainingWords: List.filled(10, state.currentWord!),
      );
    }

    GameState endTurns(GameState state, int count) {
      for (var i = 0; i < count; i++) {
        state = apply(state, TurnEnded());
      }
      return state;
    }

    test('after 1 turn the other team describes', () {
      var result = endTurns(stateWithBigDeck(), 1);
      expect(result.describer.name, 'Darth Maul');
    });

    test('after 2 turns the first team moves to its next player', () {
      var result = endTurns(stateWithBigDeck(), 2);
      expect(result.describer.name, 'Obi Wan Kenobi');
    });

    test('after 4 turns it wraps back to the first player', () {
      var result = endTurns(stateWithBigDeck(), 4);
      expect(result.describer.name, 'Anakin');
    });
  });
}
