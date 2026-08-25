import 'oyuncu.dart';

class Takim {
  final String ad;
  final List<Oyuncu> oyuncular;
  final int skor;

  Takim({required this.ad, required this.oyuncular, required this.skor});

  int get oyuncuSayisi => oyuncular.length;

  Takim copyWith({String? ad, List<Oyuncu>? oyuncular, int? skor}) => Takim(
    ad: ad ?? this.ad,
    oyuncular: oyuncular ?? this.oyuncular,
    skor: skor ?? this.skor,
  );
}
