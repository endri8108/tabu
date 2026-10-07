import 'dart:math';
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

  test('initial can let any team start', () {
    var state = sampleState();

    var result = GameState.initial(state.config, [
      state.currentWord!,
    ], startingTeamIndex: 1);

    expect(result.activeTeamIndex, 1);
    expect(result.describer.name, 'Darth Maul');
  });

  test('initial throws when the starting team does not exist', () {
    var state = sampleState();
    expect(
      () => GameState.initial(state.config, [
        state.currentWord!,
      ], startingTeamIndex: 2),
      throwsArgumentError,
    );
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

  group('target score', () {
    GameState withScores(
      int jedi,
      int sith, {
      int activeTeamIndex = 0,
      int startingTeamIndex = 0,
    }) {
      var state = sampleState();
      return GameState(
        config: state.config,
        teams: [
          state.teams[0].copyWith(score: jedi),
          state.teams[1].copyWith(score: sith),
        ],
        activeTeamIndex: activeTeamIndex,
        startingTeamIndex: startingTeamIndex,
        currentWord: state.currentWord,
        remainingWords: List.filled(10, state.currentWord!),
        remainingSeconds: state.remainingSeconds,
        remainingPasses: state.remainingPasses,
        isFinished: false,
      );
    }

    test('reaching the target mid-turn does not end the game', () {
      var state = withScores(29, 0);

      var result = apply(state, Correct());

      expect(result.teams[0].score, 30);
      expect(result.isFinished, false);
    });

    test('the second team still gets its turn after the first reaches it', () {
      var state = withScores(30, 0);

      var result = apply(state, TurnEnded());

      expect(result.isFinished, false);
      expect(result.activeTeamIndex, 1);
    });

    test('game ends at the end of the round when one team is ahead', () {
      var state = withScores(30, 12, activeTeamIndex: 1);

      var result = apply(state, TurnEnded());

      expect(result.isFinished, true);
    });

    test('when the second team started, the round ends on the first team', () {
      // Sith played first, Jedi is playing now -> this turn closes the round.
      var state = withScores(12, 30, activeTeamIndex: 0, startingTeamIndex: 1);

      var result = apply(state, TurnEnded());

      expect(result.isFinished, true);
    });

    test(
      'when the second team started, the first team still gets its turn',
      () {
        // Sith played first and reached the target; Jedi hasn't played yet.
        var state = withScores(0, 30, activeTeamIndex: 1, startingTeamIndex: 1);

        var result = apply(state, TurnEnded());

        expect(result.isFinished, false);
        expect(result.activeTeamIndex, 0);
      },
    );

    test('a tie at the top plays another round', () {
      var state = withScores(30, 30, activeTeamIndex: 1);

      var result = apply(state, TurnEnded());

      expect(result.isFinished, false);
      expect(result.activeTeamIndex, 0);
    });
  });

  group('deck runs out', () {
    // sampleState: Star on screen, War and Force in the deck.
    GameState playCorrect(GameState state, int count) {
      var random = Random(1);
      for (var i = 0; i < count; i++) {
        state = apply(state, Correct(), random);
      }
      return state;
    }

    test('Correct on the last card still scores and the game goes on', () {
      var state = sampleState().copyWith(remainingWords: []);

      var result = apply(state, Correct(), Random(1));

      expect(result.teams[0].score, 1);
      expect(result.isFinished, false);
    });

    test('used cards are shuffled back into a new deck', () {
      // Star, War, Force played -> deck was empty, so it is refilled.
      var result = playCorrect(sampleState(), 3);

      var inPlay = [
        result.currentWord!,
        ...result.remainingWords,
        ...result.usedWords,
      ].map((w) => w.text).toList()..sort();

      expect(inPlay, ['Force', 'Star', 'War']);
      expect(result.isFinished, false);
    });

    test('the card just played does not come straight back', () {
      // Force is the last card of the deck; after it the deck is reshuffled.
      var state = playCorrect(sampleState(), 2);
      expect(state.currentWord!.text, 'Force');

      var result = apply(state, Correct(), Random(1));

      expect(result.currentWord!.text, isNot('Force'));
      expect(result.remainingWords.last.text, 'Force');
    });

    test('a one-card game keeps showing the same card', () {
      var state = sampleState().copyWith(remainingWords: []);

      var result = apply(state, Pass(), Random(1));

      expect(result.currentWord!.text, 'Star');
      expect(result.remainingPasses, 2);
    });

    test('TurnEnded with an empty deck passes the turn instead of ending', () {
      var state = sampleState().copyWith(remainingWords: []);

      var result = apply(state, TurnEnded(), Random(1));

      expect(result.isFinished, false);
      expect(result.activeTeamIndex, 1);
    });
  });
}
