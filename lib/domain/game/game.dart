import '../model/word.dart';
import '../model/game_state.dart';
import 'game_event.dart';

GameState apply(GameState state, GameEvent event) {
  if (state.isFinished) {
    return state;
  }
  switch (event) {
    case Correct():
      var activeTeam = state.teams[state.activeTeamIndex];

      var updatedTeam = activeTeam.copyWith(score: activeTeam.score + 1);

      var updatedTeams = List.of(state.teams);
      updatedTeams[state.activeTeamIndex] = updatedTeam;

      if (updatedTeam.score >= state.config.targetScore) {
        return state.copyWith(teams: updatedTeams, isFinished: true);
      }
      if (state.remainingWords.isEmpty) {
        return state.copyWith(teams: updatedTeams, isFinished: true);
      }

      var nextWord = state.remainingWords[0];
      var rest = state.remainingWords.sublist(1);

      return state.copyWith(
        teams: updatedTeams,
        currentWord: nextWord,
        remainingWords: rest,
      );

    case Taboo():
      var activeTeam = state.teams[state.activeTeamIndex];

      var updatedTeam = activeTeam.copyWith(score: activeTeam.score - 1);

      var updatedTeams = List.of(state.teams);
      updatedTeams[state.activeTeamIndex] = updatedTeam;

      if (state.remainingWords.isEmpty) {
        return state.copyWith(teams: updatedTeams, isFinished: true);
      }

      var nextWord = state.remainingWords[0];
      var rest = state.remainingWords.sublist(1);

      return state.copyWith(
        teams: updatedTeams,
        currentWord: nextWord,
        remainingWords: rest,
      );

    case Pass():
      if (state.remainingPasses <= 0) {
        return state;
      }
      if (state.remainingWords.isEmpty) return state.copyWith(isFinished: true);

      Word nextWord = state.remainingWords[0];
      var rest = state.remainingWords.sublist(1);

      return state.copyWith(
        remainingPasses: state.remainingPasses - 1,
        currentWord: nextWord,
        remainingWords: rest,
      );

    case SecondTick():
      var secondsLeft = state.remainingSeconds - 1;

      if (secondsLeft <= 0) return apply(state, TurnEnded());

      return state.copyWith(remainingSeconds: secondsLeft);

    case TurnEnded():
      var nextIndex = (state.activeTeamIndex + 1) % state.teams.length;

      return state.copyWith(
        activeTeamIndex: nextIndex,
        remainingSeconds: state.config.roundSeconds,
        remainingPasses: state.config.passLimit,
      );
  }
}
