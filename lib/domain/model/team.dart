import 'player.dart';

class Team {
  final String name;
  final List<Player> players;
  final int score;

  Team({required this.name, required this.players, required this.score});

  int get playerCount => players.length;

  Team copyWith({String? name, List<Player>? players, int? score}) => Team(
    name: name ?? this.name,
    players: players ?? this.players,
    score: score ?? this.score,
  );
}
