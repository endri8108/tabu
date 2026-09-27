import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabu/data/sample_game.dart';
import 'package:tabu/domain/game/game.dart';
import 'package:tabu/domain/game/game_event.dart';
import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/ui/widgets/action_buttons.dart';
import 'package:tabu/ui/widgets/countdown_ring.dart';
import 'package:tabu/ui/widgets/game_over.dart';
import 'package:tabu/ui/widgets/score_bar.dart';
import 'package:tabu/ui/widgets/turn_intro.dart';
import 'package:tabu/ui/widgets/word_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameState state = sampleGame();

  // false = between turns (TurnIntro is shown and the clock is stopped).
  bool turnRunning = false;
  Timer? clock;

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
    var before = state;

    setState(() {
      state = apply(state, event);

      // A new turn resets the clock upwards; the game can also just end.
      var turnOver = state.remainingSeconds > before.remainingSeconds;
      if (state.isFinished || turnOver) {
        turnRunning = false;
        clock?.cancel();
      }
    });

    switch (event) {
      case Correct():
        HapticFeedback.mediumImpact();
      case Taboo():
        HapticFeedback.heavyImpact();
      default:
        break;
    }
  }

  void playAgain() {
    clock?.cancel();
    setState(() {
      state = sampleGame();
      turnRunning = false;
    });
  }

  @override
  void dispose() {
    clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;

    Widget body;
    if (state.isFinished) {
      body = GameOver(state: state, onPlayAgain: playAgain);
    } else if (!turnRunning) {
      body = TurnIntro(state: state, onStart: startTurn);
    } else {
      body = _buildTurn(colors);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.surface, colors.primaryContainer],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: KeyedSubtree(
              key: ValueKey('${state.isFinished}-$turnRunning'),
              child: body,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTurn(ColorScheme colors) {
    var word = state.currentWord!;

    return Padding(
      padding: const EdgeInsets.all(20),
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
                      'Describing',
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                    Text(
                      state.describer.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              CountdownRing(
                secondsLeft: state.remainingSeconds,
                totalSeconds: state.config.roundSeconds,
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
                  child: SizedBox(width: 320, child: WordCard(word: word)),
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
