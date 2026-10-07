import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabu/data/sample_game.dart';
import 'package:tabu/domain/game/game.dart';
import 'package:tabu/domain/game/game_event.dart';
import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/domain/model/word.dart';
import 'package:tabu/ui/app_theme.dart';
import 'package:tabu/ui/widgets/action_buttons.dart';
import 'package:tabu/ui/widgets/countdown_ring.dart';
import 'package:tabu/ui/widgets/game_over.dart';
import 'package:tabu/ui/widgets/score_bar.dart';
import 'package:tabu/ui/widgets/turn_intro.dart';
import 'package:tabu/ui/widgets/word_card.dart';

class GameScreen extends StatefulWidget {
  // The cards to play with; every new game shuffles them again.
  final List<Word> words;

  // Called with the brightness currently on screen; null hides the button.
  final ValueChanged<Brightness>? onToggleTheme;

  const GameScreen({super.key, required this.words, this.onToggleTheme});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState state;

  // false = between turns (TurnIntro is shown and the clock is stopped).
  bool turnRunning = false;
  Timer? clock;

  @override
  void initState() {
    super.initState();
    state = sampleGame(widget.words);
  }

  void startTurn() {
    setState(() => turnRunning = true);
    clock?.cancel();
    clock = Timer.periodic(
      const Duration(seconds: 1),
      (_) => send(SecondTick()),
    );
  }

  // The only place the UI talks to the engine.
  void send(GameEvent event) {
    var next = apply(state, event);

    // The engine ignored the event (e.g. Pass with no passes left).
    if (identical(next, state)) return;

    // The engine hands the turn to the next team when it ends.
    var turnOver = next.activeTeamIndex != state.activeTeamIndex;
    var stopClock = next.isFinished || turnOver;

    setState(() {
      state = next;
      if (stopClock) {
        turnRunning = false;
        clock?.cancel();
      }
    });

    if (stopClock) {
      HapticFeedback.vibrate();
    } else if (event is Correct) {
      HapticFeedback.mediumImpact();
    } else if (event is Taboo) {
      HapticFeedback.heavyImpact();
    }
  }

  void playAgain() {
    clock?.cancel();
    setState(() {
      state = sampleGame(widget.words);
      turnRunning = false;
    });
  }

  // Active team's colour while playing, the winner's colour at the end.
  Color accentColor(ColorScheme colors) {
    if (state.isFinished) {
      var winner = winnerIndex(state.teams);
      return winner == null ? colors.primary : Palette.team(winner);
    }
    return Palette.team(state.activeTeamIndex);
  }

  @override
  void dispose() {
    clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colors = theme.colorScheme;
    var accent = accentColor(colors);
    var word = state.currentWord;

    Widget body;
    // Without a card there is nothing left to play, so treat it as the end.
    if (state.isFinished || word == null) {
      body = GameOver(state: state, onPlayAgain: playAgain);
    } else if (!turnRunning) {
      body = TurnIntro(state: state, accent: accent, onStart: startTurn);
    } else {
      body = _buildTurn(word, accent);
    }

    var isDark = theme.brightness == Brightness.dark;
    var tint = accent.withValues(alpha: isDark ? 0.22 : 0.16);

    return Scaffold(
      // The background slowly takes on the colour of the team that is playing.
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.surface, Color.alphaBlend(tint, colors.surface)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _TopBar(onToggleTheme: widget.onToggleTheme),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: KeyedSubtree(
                    key: ValueKey('${state.isFinished}-$turnRunning'),
                    child: body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTurn(Word word, Color accent) {
    var colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        children: [
          ScoreBar(teams: state.teams, activeTeamIndex: state.activeTeamIndex),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESCRIBING',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      state.describer.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              CountdownRing(
                secondsLeft: state.remainingSeconds,
                totalSeconds: state.config.roundSeconds,
                color: accent,
              ),
            ],
          ),
          Expanded(
            child: Center(
              // New card slides in from the right whenever the word changes.
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween(
                    begin: const Offset(0.3, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                // Shrinks the card on short screens instead of overflowing.
                child: FittedBox(
                  key: ValueKey(word),
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: 320,
                    child: WordCard(word: word, accent: accent),
                  ),
                ),
              ),
            ),
          ),
          ActionButtons(
            passesLeft: state.remainingPasses,
            onTaboo: () => send(Taboo()),
            onPass: () => send(Pass()),
            onCorrect: () => send(Correct()),
          ),
        ],
      ),
    );
  }
}

// App name on the left, light/dark switch on the right.
class _TopBar extends StatelessWidget {
  final ValueChanged<Brightness>? onToggleTheme;

  const _TopBar({required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 8),
        child: Row(
          children: [
            Text(
              'TABOO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            if (onToggleTheme != null)
              IconButton(
                tooltip: 'Switch theme',
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                ),
                onPressed: () => onToggleTheme!(theme.brightness),
              ),
          ],
        ),
      ),
    );
  }
}
