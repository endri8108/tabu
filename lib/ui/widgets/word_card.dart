import 'package:flutter/material.dart';
import 'package:tabu/domain/model/word.dart';

// The Taboo card: the word on a coloured header, forbidden words below.
class WordCard extends StatelessWidget {
  final Word word;

  const WordCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primary, colors.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              word.text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onPrimary,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                for (var (i, forbidden) in word.forbiddenWords.indexed) ...[
                  if (i > 0)
                    const Divider(height: 1, indent: 48, endIndent: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      forbidden,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
