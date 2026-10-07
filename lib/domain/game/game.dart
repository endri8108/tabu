import 'dart:math';

import '../model/team.dart';
import '../model/game_state.dart';
import 'game_event.dart';

// `random` decides the order when the used cards are shuffled back into the
// deck. Tests pass a seeded Random so the result is always the same.
GameState apply(GameState state, GameEvent event, [Random? random]) {
  random ??= Random();

  if (state.isFinished) {
    return state;
  }
  switch (event) {
    case Correct():
      var activeTeam = state.teams[state.activeTeamIndex];

      var updatedTeam = activeTeam.copyWith(score: activeTeam.score + 1);

      var updatedTeams = List.of(state.teams);
      updatedTeams[state.activeTeamIndex] = updatedTeam;

      return _drawCard(state, random).copyWith(teams: updatedTeams);

    case Taboo():
      var activeTeam = state.teams[state.activeTeamIndex];

      var updatedTeam = activeTeam.copyWith(score: activeTeam.score - 1);

      var updatedTeams = List.of(state.teams);
      updatedTeams[state.activeTeamIndex] = updatedTeam;

      return _drawCard(state, random).copyWith(teams: updatedTeams);

    case Pass():
      if (state.remainingPasses <= 0) {
        return state;
      }

      return _drawCard(
        state,
        random,
      ).copyWith(remainingPasses: state.remainingPasses - 1);

    case SecondTick():
      var secondsLeft = state.remainingSeconds - 1;

      if (secondsLeft <= 0) return apply(state, TurnEnded(), random);

      return state.copyWith(remainingSeconds: secondsLeft);

    case TurnEnded():
      var nextIndex = (state.activeTeamIndex + 1) % state.teams.length;

      var activeTeam = state.teams[state.activeTeamIndex];

      var newIndex = (activeTeam.describerIndex + 1) % activeTeam.playerCount;
      var updatedTeam = activeTeam.copyWith(describerIndex: newIndex);

      var updatedTeams = List.of(state.teams);
      updatedTeams[state.activeTeamIndex] = updatedTeam;

      // Back to the starting team = every team has played the same number of
      // turns, so this is the only moment the target score is checked.
      var roundOver = nextIndex == state.startingTeamIndex;
      if (roundOver && _hasWinner(updatedTeams, state.config.targetScore)) {
        return state.copyWith(teams: updatedTeams, isFinished: true);
      }

      return _drawCard(state, random).copyWith(
        activeTeamIndex: nextIndex,
        remainingSeconds: state.config.roundSeconds,
        remainingPasses: state.config.passLimit,
        teams: updatedTeams,
      );
  }
}

GameState _drawCard(GameState state, Random random) {
  var current = state.currentWord;
  var deck = state.remainingWords;
  var used = [...state.usedWords, ?current];

  if (deck.isEmpty) {
    var reshuffled = List.of(state.usedWords)..shuffle(random);
    deck = [...reshuffled, ?current];
    used = [];
  }

  return state.copyWith(
    currentWord: () => deck.first,
    remainingWords: deck.sublist(1),
    usedWords: used,
  );
}

bool _hasWinner(List<Team> teams, int targetScore) {
  var scores = teams.map((t) => t.score).toList()..sort();
  var best = scores.last;

  if (best < targetScore) return false;
  return scores.length == 1 || best > scores[scores.length - 2];
}
