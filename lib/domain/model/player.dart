class Player {
  final String name;
  final int id;

  Player({required this.name, required this.id});

  Player copyWith({String? name, int? id}) =>
      Player(name: name ?? this.name, id: id ?? this.id);
}
