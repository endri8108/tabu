import 'package:flutter/material.dart';
import 'package:tabu/ui/app_theme.dart';

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
          color: Palette.taboo,
          onPressed: onTaboo,
        ),
        _ActionButton(
          label: 'Pass ($passesLeft)',
          icon: Icons.skip_next_rounded,
          color: Palette.pass,
          textColor: Palette.onPass,
          onPressed: passesLeft > 0 ? onPass : null,
        ),
        _ActionButton(
          label: 'Correct',
          icon: Icons.check_rounded,
          color: Palette.correct,
          onPressed: onCorrect,
        ),
      ],
    );
  }
}

// A button that shrinks a little while the finger is on it.
class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.textColor = Colors.white,
    required this.onPressed,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool pressed = false;

  void setPressed(bool value) {
    if (widget.onPressed == null) return; // disabled buttons don't react
    setState(() => pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Listener(
          onPointerDown: (_) => setPressed(true),
          onPointerUp: (_) => setPressed(false),
          onPointerCancel: (_) => setPressed(false),
          child: AnimatedScale(
            scale: pressed ? 0.92 : 1,
            duration: const Duration(milliseconds: 100),
            child: FilledButton(
              onPressed: widget.onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: widget.textColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, size: 30),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
