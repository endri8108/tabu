import 'package:flutter/material.dart';
import 'package:tabu/domain/model/team.dart';

// Both teams side by side; the team that is playing is highlighted.
class ScoreBar extends StatelessWidget {
  final List<Team> teams;
  final int activeTeamIndex;

  const ScoreBar({
    super.key,
    required this.teams,
    required this.activeTeamIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var (i, team) in teams.indexed)
          Expanded(
            child: _TeamScore(team: team, isActive: i == activeTeamIndex),
          ),
      ],
    );
  }
}

class _TeamScore extends StatelessWidget {
  final Team team;
  final bool isActive;

  const _TeamScore({required this.team, required this.isActive});

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? colors.primaryContainer : colors.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? colors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            team.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colors.onSurfaceVariant,
            ),
          ),
          // Score "pops" whenever it changes.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              '${team.score}',
              key: ValueKey(team.score),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
