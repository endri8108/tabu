import 'player.dart';

class GameConfig {
  final int roundSeconds;
  final int targetScore;
  final int passLimit;
  final List<Player> players;

  GameConfig({
    required this.roundSeconds,
    required this.targetScore,
    required this.passLimit,
    required this.players,
  });
}
