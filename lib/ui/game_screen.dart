import 'package:flutter/material.dart';
import 'package:tabu/domain/model/game_state.dart';
import 'package:tabu/data/sample_game.dart';
import 'package:tabu/domain/game/game.dart';
import 'package:tabu/domain/game/game_event.dart';

class GameScreen extends StatefulWidget {
  // 1. sınıf: "kabuk"
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameState state = sampleGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(state.currentWord!.text, style: TextStyle(fontSize: 40)),
      ),
    );
  }
}
