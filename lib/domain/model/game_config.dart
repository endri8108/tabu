import 'team.dart';

class GameConfig {
  final int roundSeconds;
  final int targetScore;
  final int passLimit;
  final List<Team> teams;

  GameConfig({
    required this.roundSeconds,
    required this.targetScore,
    required this.passLimit,
    required this.teams,
  });
}
