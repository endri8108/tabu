import 'player.dart';

class Team {
  final String name;
  final List<Player> players;
  final int score;
  final int describerIndex;

  Team({
    required this.name,
    required this.players,
    required this.score,
    this.describerIndex = 0,
  });

  int get playerCount => players.length;

  Team copyWith({
    String? name,
    List<Player>? players,
    int? score,
    int? describerIndex,
  }) => Team(
    name: name ?? this.name,
    players: players ?? this.players,
    score: score ?? this.score,
    describerIndex: describerIndex ?? this.describerIndex,
  );
}
