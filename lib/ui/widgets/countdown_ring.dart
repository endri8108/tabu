import 'package:flutter/material.dart';
import 'package:tabu/ui/app_theme.dart';

// Circular timer that empties as the turn runs out and turns red at the end.
class CountdownRing extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;
  final Color color;

  const CountdownRing({
    super.key,
    required this.secondsLeft,
    required this.totalSeconds,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    var isRunningOut = secondsLeft <= 10;
    var ringColor = isRunningOut ? Palette.taboo : color;

    return SizedBox(
      width: 76,
      height: 76,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Animates smoothly between whole seconds instead of jumping.
          TweenAnimationBuilder<double>(
            tween: Tween(end: secondsLeft / totalSeconds),
            duration: const Duration(seconds: 1),
            builder: (context, value, _) => CircularProgressIndicator(
              value: value,
              strokeWidth: 7,
              strokeCap: StrokeCap.round,
              color: ringColor,
              backgroundColor: ringColor.withValues(alpha: 0.15),
            ),
          ),
          Center(
            // In the last 10 seconds the number "beats" once per second.
            child: TweenAnimationBuilder<double>(
              key: ValueKey(secondsLeft),
              tween: Tween(begin: isRunningOut ? 1.35 : 1, end: 1),
              duration: const Duration(milliseconds: 300),
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Text(
                '$secondsLeft',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isRunningOut ? Palette.taboo : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
