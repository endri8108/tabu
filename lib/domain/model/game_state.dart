import 'team.dart';
import 'word.dart';
import 'game_config.dart';
import 'player.dart';

class GameState {
  final GameConfig config;
  final List<Team> teams;
  final int activeTeamIndex;
  // The team that played the first turn. A round is over when the turn comes
  // back to this team.
  final int startingTeamIndex;
  final Word? currentWord;
  final List<Word> remainingWords;
  final List<Word> usedWords;
  final int remainingSeconds;
  final int remainingPasses;
  final bool isFinished;

  GameState({
    required this.config,
    required this.teams,
    required this.activeTeamIndex,
    this.startingTeamIndex = 0,
    required this.currentWord,
    required this.remainingWords,
    this.usedWords = const [],
    required this.remainingSeconds,
    required this.remainingPasses,
    required this.isFinished,
  });

  Player get describer {
    var team = teams[activeTeamIndex];
    return team.players[team.describerIndex];
  }

  factory GameState.initial(
    GameConfig config,
    List<Word> words, {
    int startingTeamIndex = 0,
  }) {
    if (words.isEmpty) {
      throw ArgumentError('Word List is empty!');
    }
    if (startingTeamIndex < 0 || startingTeamIndex >= config.teams.length) {
      throw ArgumentError('No team at index $startingTeamIndex!');
    }

    var teams = config.teams.map((t) => t.copyWith(score: 0)).toList();

    return GameState(
      config: config,
      teams: teams,
      remainingWords: words.sublist(1),
      currentWord: words[0],
      remainingSeconds: config.roundSeconds,
      remainingPasses: config.passLimit,
      activeTeamIndex: startingTeamIndex,
      startingTeamIndex: startingTeamIndex,
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
    List<Word>? usedWords,
    bool? isFinished,
  }) => GameState(
    config: config,
    teams: teams ?? this.teams,
    activeTeamIndex: activeTeamIndex ?? this.activeTeamIndex,
    startingTeamIndex: startingTeamIndex,
    currentWord: currentWord != null ? currentWord() : this.currentWord,
    remainingWords: remainingWords ?? this.remainingWords,
    usedWords: usedWords ?? this.usedWords,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    remainingPasses: remainingPasses ?? this.remainingPasses,
    isFinished: isFinished ?? this.isFinished,
  );
}
