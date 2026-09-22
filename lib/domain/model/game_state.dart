import 'team.dart';
import 'word.dart';
import 'game_config.dart';

class GameState {
  final GameConfig config;
  final List<Team> teams;
  final int activeTeamIndex;
  final Word? currentWord;
  final List<Word> remainingWords;
  final int remainingSeconds;
  final int remainingPasses;
  final bool isFinished;

  GameState({
    required this.config,
    required this.teams,
    required this.activeTeamIndex,
    required this.currentWord,
    required this.remainingWords,
    required this.remainingSeconds,
    required this.remainingPasses,
    required this.isFinished,
  });

  GameState copyWith({
    List<Team>? teams,
    int? activeTeamIndex,
    int? remainingSeconds,
    int? remainingPasses,
    Word? currentWord,
    List<Word>? remainingWords,
    bool? isFinished,
  }) => GameState(
    config: config,
    teams: teams ?? this.teams,
    activeTeamIndex: activeTeamIndex ?? this.activeTeamIndex,
    currentWord: currentWord ?? this.currentWord,
    remainingWords: remainingWords ?? this.remainingWords,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    remainingPasses: remainingPasses ?? this.remainingPasses,
    isFinished: isFinished ?? this.isFinished,
  );
}
