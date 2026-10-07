import 'package:flutter/material.dart';
import 'package:tabu/domain/model/team.dart';
import 'package:tabu/ui/app_theme.dart';

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
            child: _TeamScore(
              team: team,
              color: Palette.team(i),
              isActive: i == activeTeamIndex,
            ),
          ),
      ],
    );
  }
}

class _TeamScore extends StatelessWidget {
  final Team team;
  final Color color;
  final bool isActive;

  const _TeamScore({
    required this.team,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: isActive
            ? color.withValues(alpha: 0.16)
            : colors.surfaceContainerHigh.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              team.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
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
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
