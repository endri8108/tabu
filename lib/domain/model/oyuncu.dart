class Oyuncu{
  final String ad;
  final int id;

  Oyuncu({required this.ad, required this.id});

  Oyuncu copyWith({String? ad, int? id}) =>
    Oyuncu(ad: ad ?? this.ad, id: id ?? this.id);
}