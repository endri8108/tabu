import 'data/word_loader.dart';
import 'domain/model/word.dart';
import 'ui/app_theme.dart';
import 'ui/game_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Needed before reading bundled files (the word list) ahead of runApp.
  WidgetsFlutterBinding.ensureInitialized();
  var words = await loadWords();

  runApp(TabooApp(words: words));
}

class TabooApp extends StatefulWidget {
  final List<Word> words;

  const TabooApp({super.key, required this.words});

  @override
  State<TabooApp> createState() => _TabooAppState();
}

class _TabooAppState extends State<TabooApp> {
  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme(Brightness current) {
    setState(() {
      themeMode = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taboo',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: themeMode,
      home: GameScreen(words: widget.words, onToggleTheme: toggleTheme),
    );
  }
}
