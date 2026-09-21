import 'takim.dart';
import 'kelime.dart';
import 'oyun_kurulumu.dart';

class Durum {
  final OyunKurulumu kurulum;
  final List<Takim> takimListesi;
  final int aktifTakimIndex;
  final Kelime? aktifKelime;
  final List<Kelime> kalanKelimeler;
  final int kalanSure;
  final int kalanPass;
  final bool finish;

  Durum({
    required this.kurulum,
    required this.takimListesi,
    required this.aktifTakimIndex,
    required this.aktifKelime,
    required this.kalanKelimeler,
    required this.kalanSure,
    required this.kalanPass,
    required this.finish,
  });

  Durum copyWith({
    List<Takim>? takimListesi,
    int? aktifTakimIndex,
    int? kalanSure,
    int? kalanPass,
    Kelime? aktifKelime,
    List<Kelime>? kalanKelimeler,
    bool? finish,
  }) => Durum(
    kurulum: kurulum,
    takimListesi: takimListesi ?? this.takimListesi,
    aktifTakimIndex: aktifTakimIndex ?? this.aktifTakimIndex,
    aktifKelime: aktifKelime ?? this.aktifKelime,
    kalanKelimeler: kalanKelimeler ?? this.kalanKelimeler,
    kalanSure: kalanSure ?? this.kalanSure,
    kalanPass: kalanPass ?? this.kalanPass,
    finish: finish ?? this.finish,
  );
}
