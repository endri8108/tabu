import '../model/kelime.dart';
import '../model/durum.dart';
import 'olay.dart';

Durum uygula(Durum durum, Olay olay) {
  switch (olay) {
    case Dogru():
      var aktifTakim = durum.takimListesi[durum.aktifTakimIndex];

      var yeniTakim = aktifTakim.copyWith(skor: aktifTakim.skor + 1);

      var yeniListe = List.of(durum.takimListesi);
      yeniListe[durum.aktifTakimIndex] = yeniTakim;

      // Hedef skora ulaşıldıysa oyun biter.
      if (yeniTakim.skor >= durum.kurulum.hedefSkor) {
        return durum.copyWith(takimListesi: yeniListe, finish: true);
      }

      var yeniKelime = durum.kalanKelimeler[0];
      var kalanlar = durum.kalanKelimeler.sublist(1);

      return durum.copyWith(
        takimListesi: yeniListe,
        aktifKelime: yeniKelime,
        kalanKelimeler: kalanlar,
      );

    case Tabu():
      var aktifTakim = durum.takimListesi[durum.aktifTakimIndex];

      var yeniTakim = aktifTakim.copyWith(skor: aktifTakim.skor - 1);

      var yeniListe = List.of(durum.takimListesi);
      yeniListe[durum.aktifTakimIndex] = yeniTakim;

      var yeniKelime = durum.kalanKelimeler[0];
      var kalanlar = durum.kalanKelimeler.sublist(1);

      return durum.copyWith(
        takimListesi: yeniListe,
        aktifKelime: yeniKelime,
        kalanKelimeler: kalanlar,
      );

    case Pass():
      // Pass hakkı kalmadıysa hiçbir şey değişmez.
      if (durum.kalanPass <= 0) return durum;

      // Kelime kalmadıysa oyun biter.
      if (durum.kalanKelimeler.isEmpty) return durum.copyWith(finish: true);

      Kelime yeniKelime = durum.kalanKelimeler[0];
      var kalanlar = durum.kalanKelimeler.sublist(1);

      return durum.copyWith(
        kalanPass: durum.kalanPass - 1,
        aktifKelime: yeniKelime,
        kalanKelimeler: kalanlar,
      );

    case SaniyeGecti():
      var yeniSure = durum.kalanSure - 1;

      // Süre dolduğunda tur otomatik biter.
      if (yeniSure <= 0) return uygula(durum, TurBitti());

      return durum.copyWith(kalanSure: yeniSure);

    case TurBitti():
      // Sıradaki takıma geç, süreyi ve pass hakkını sıfırla.
      var sonrakiIndex =
          (durum.aktifTakimIndex + 1) % durum.takimListesi.length;

      return durum.copyWith(
        aktifTakimIndex: sonrakiIndex,
        kalanSure: durum.kurulum.sure,
        kalanPass: durum.kurulum.passHakki,
      );
  }
}
