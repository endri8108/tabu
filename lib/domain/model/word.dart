class Word {
  final String text;
  final List<String> forbiddenWords;
  final int difficulty;

  Word({
    required this.text,
    required this.forbiddenWords,
    required this.difficulty,
  });
}
