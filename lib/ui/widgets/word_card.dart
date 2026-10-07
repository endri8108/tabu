import 'package:flutter/material.dart';
import 'package:tabu/domain/model/word.dart';
import 'package:tabu/ui/app_theme.dart';

// The Taboo card: the word on a team-coloured header, forbidden words below.
class WordCard extends StatelessWidget {
  final Word word;
  final Color accent;

  const WordCard({super.key, required this.word, required this.accent});

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark
            ? colors.surfaceContainerHigh
            : colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        // Soft coloured glow instead of a grey drop shadow.
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.50 : 0.22),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, Color.lerp(accent, Colors.black, 0.3)!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              word.text.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
            child: Column(
              children: [
                const Text(
                  "DON'T SAY",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: Palette.taboo,
                  ),
                ),
                const SizedBox(height: 10),
                for (var forbidden in word.forbiddenWords)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.block_rounded,
                          size: 18,
                          color: Palette.taboo.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            forbidden,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
