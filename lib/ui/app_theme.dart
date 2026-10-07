import 'package:flutter/material.dart';

class Palette {
  static const correct = Color(0xFF16A34A);
  static const taboo = Color.fromARGB(255, 232, 4, 12);
  static const pass = Color(0xFFF59E0B);
  static const onPass = Color(0xFF2A1A00);
  static const trophy = Color(0xFFF5A524);

  static const _teams = [
    Color(0xFF3B82F6),
    Color.fromARGB(255, 137, 3, 3),
    Color(0xFF14B8A6),
    Color.fromARGB(255, 101, 31, 167),
  ];

  static Color team(int index) => _teams[index % _teams.length];
}

ThemeData buildTheme(Brightness brightness) {
  var colors = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 2, 81, 28),
    brightness: brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
  );

  return ThemeData(
    colorScheme: colors,
    scaffoldBackgroundColor: colors.surface,
    // Big, rounded buttons everywhere (Start turn, Play again, ...).
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
    ),
  );
}
