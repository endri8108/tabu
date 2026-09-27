import 'package:flutter/material.dart';
import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/ui/widgets/score_bar.dart';

// Final screen: winner (or draw), final scores, play again.
class GameOver extends StatelessWidget {
  final GameState state;
  final VoidCallback onPlayAgain;

  const GameOver({super.key, required this.state, required this.onPlayAgain});

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var sorted = [...state.teams]..sort((a, b) => b.score.compareTo(a.score));
    var isDraw = sorted.length > 1 && sorted[0].score == sorted[1].score;
    var title = isDraw ? "It's a draw!" : '${sorted.first.name} win!';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Icon(
              isDraw ? Icons.handshake_rounded : Icons.emoji_events_rounded,
              size: 96,
              color: const Color(0xFFF5A524),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'Final score',
            style: TextStyle(fontSize: 16, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          ScoreBar(teams: state.teams, activeTeamIndex: -1),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onPlayAgain,
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Play again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
