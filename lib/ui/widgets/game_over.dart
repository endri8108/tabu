import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/domain/model/team.dart';
import 'package:tabu/ui/app_theme.dart';
import 'package:tabu/ui/widgets/score_bar.dart';

// Index of the team with the highest score, or null on a draw.
int? winnerIndex(List<Team> teams) {
  var best = teams.map((t) => t.score).reduce(max);
  var leaders = [
    for (var (i, team) in teams.indexed)
      if (team.score == best) i,
  ];
  return leaders.length == 1 ? leaders.first : null;
}

// Final screen: winner (or draw), final scores, play again.
class GameOver extends StatelessWidget {
  final GameState state;
  final VoidCallback onPlayAgain;

  const GameOver({super.key, required this.state, required this.onPlayAgain});

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var winner = winnerIndex(state.teams);
    var isDraw = winner == null;
    var title = winner == null
        ? "It's a draw!"
        : '${state.teams[winner].name} win!';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          const Spacer(),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.trophy.withValues(alpha: 0.15),
              ),
              child: Icon(
                isDraw ? Icons.handshake_rounded : Icons.emoji_events_rounded,
                size: 88,
                color: Palette.trophy,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: winner == null ? null : Palette.team(winner),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Final score',
            style: TextStyle(fontSize: 16, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          ScoreBar(teams: state.teams, activeTeamIndex: winner ?? -1),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onPlayAgain,
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Play again'),
            ),
          ),
        ],
      ),
    );
  }
}
