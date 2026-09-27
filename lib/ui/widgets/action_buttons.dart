import 'package:flutter/material.dart';

// Taboo (red) · Pass (yellow) · Correct (green), sized for thumbs.
class ActionButtons extends StatelessWidget {
  final int passesLeft;
  final VoidCallback onTaboo;
  final VoidCallback onPass;
  final VoidCallback onCorrect;

  const ActionButtons({
    super.key,
    required this.passesLeft,
    required this.onTaboo,
    required this.onPass,
    required this.onCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          label: 'Taboo',
          icon: Icons.close_rounded,
          color: const Color(0xFFE5484D),
          onPressed: onTaboo,
        ),
        _ActionButton(
          label: 'Pass ($passesLeft)',
          icon: Icons.skip_next_rounded,
          color: const Color(0xFFF5A524),
          onPressed: passesLeft > 0 ? onPass : null,
        ),
        _ActionButton(
          label: 'Correct',
          icon: Icons.check_rounded,
          color: const Color(0xFF30A46C),
          onPressed: onCorrect,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
