import 'package:flutter/material.dart';
import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/ui/widgets/score_bar.dart';

// Shown before every turn: "hand the phone to X", then the describer taps Start.
class TurnIntro extends StatelessWidget {
  final GameState state;
  final VoidCallback onStart;

  const TurnIntro({super.key, required this.state, required this.onStart});

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var team = state.teams[state.activeTeamIndex];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ScoreBar(teams: state.teams, activeTeamIndex: state.activeTeamIndex),
          const Spacer(),
          Icon(Icons.phone_iphone_rounded, size: 56, color: colors.primary),
          const SizedBox(height: 16),
          Text(
            'Hand the phone to',
            style: TextStyle(fontSize: 18, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            state.describer.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'describing for ${team.name} · ${state.config.roundSeconds} seconds',
            style: TextStyle(fontSize: 16, color: colors.onSurfaceVariant),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start turn'),
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
