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

  factory GameState.initial(GameConfig config, List<Word> words) {
    if (words.isEmpty) {
      throw ArgumentError('Word List is empty!');
    }

    var teams = config.teams.map((t) => t.copyWith(score: 0)).toList();

    return GameState(
      config: config,
      teams: teams,
      remainingWords: words.sublist(1),
      currentWord: words[0],
      remainingSeconds: config.roundSeconds,
      remainingPasses: config.passLimit,
      activeTeamIndex: 0,
      isFinished: false,
    );
  }

  GameState copyWith({
    List<Team>? teams,
    int? activeTeamIndex,
    int? remainingSeconds,
    int? remainingPasses,
    Word? Function()? currentWord,
    List<Word>? remainingWords,
    bool? isFinished,
  }) => GameState(
    config: config,
    teams: teams ?? this.teams,
    activeTeamIndex: activeTeamIndex ?? this.activeTeamIndex,
    currentWord: currentWord != null ? currentWord() : this.currentWord,
    remainingWords: remainingWords ?? this.remainingWords,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    remainingPasses: remainingPasses ?? this.remainingPasses,
    isFinished: isFinished ?? this.isFinished,
  );
}
