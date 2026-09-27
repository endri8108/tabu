import 'ui/game_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TabooApp());
}

class TabooApp extends StatelessWidget {
  const TabooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taboo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color.fromARGB(255, 31, 12, 158)),
      home: const GameScreen(),
    );
  }
}
