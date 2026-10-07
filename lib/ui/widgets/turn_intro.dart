import 'package:flutter/material.dart';
import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/ui/widgets/score_bar.dart';

// Shown before every turn: "hand the phone to X", then the describer taps Start.
class TurnIntro extends StatelessWidget {
  final GameState state;
  final Color accent;
  final VoidCallback onStart;

  const TurnIntro({
    super.key,
    required this.state,
    required this.accent,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var team = state.teams[state.activeTeamIndex];
    var name = state.describer.name;
    var initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          ScoreBar(teams: state.teams, activeTeamIndex: state.activeTeamIndex),
          const Spacer(),
          // Avatar: the describer's first letter in the team's colour.
          Container(
            width: 112,
            height: 112,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [accent, Color.lerp(accent, Colors.black, 0.3)!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.35),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Hand the phone to',
            style: TextStyle(fontSize: 18, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _InfoChip(
                icon: Icons.groups_rounded,
                label: team.name,
                iconColor: accent,
              ),
              _InfoChip(
                icon: Icons.timer_outlined,
                label: '${state.config.roundSeconds} s',
              ),
              _InfoChip(
                icon: Icons.skip_next_rounded,
                label: '${state.config.passLimit} passes',
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start turn'),
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Small rounded label: icon + text.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _InfoChip({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor ?? colors.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
