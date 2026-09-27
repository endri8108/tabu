import 'package:flutter/material.dart';

// Circular timer that empties as the turn runs out and turns red at the end.
class CountdownRing extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;

  const CountdownRing({
    super.key,
    required this.secondsLeft,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var isRunningOut = secondsLeft <= 10;
    var ringColor = isRunningOut ? Colors.red : colors.primary;

    return SizedBox(
      width: 72,
      height: 72,
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
              backgroundColor: colors.surfaceContainerHighest,
            ),
          ),
          Center(
            child: Text(
              '$secondsLeft',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isRunningOut ? Colors.red : colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
