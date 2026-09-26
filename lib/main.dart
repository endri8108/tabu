import 'package:flutter/material.dart';

void main() {
  runApp(const TabuApp());
}

class TabuApp extends StatelessWidget {
  const TabuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taboo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color.fromARGB(255, 31, 12, 158)),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Taboo',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(' Word Guessing Game', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
