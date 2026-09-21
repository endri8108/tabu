import 'domain/model/oyuncu.dart';
import 'domain/model/takim.dart';
import 'domain/model/kelime.dart';
import 'domain/model/oyun_kurulumu.dart';
import 'domain/model/kart_sonucu.dart';
import 'domain/model/durum.dart';

void main() {
  
  var anakin = Oyuncu(ad: 'Anakin', id:1);
  var obiwan = Oyuncu(ad:'Obi Wan Kenobi',id:2);

  var maul   = Oyuncu(ad:'Darth Maul',id:3);
  var sidious= Oyuncu(ad:'Darth Sidious',id:4);


  var takim1 = Takim(ad:'Jedi',oyuncular:[anakin , obiwan],skor:0);
  var takim2 = Takim(ad:'Sith',oyuncular:[maul,sidious],skor:1);
  var kelime1= Kelime(metin: 'War',yasaklilar:['light','dark','saber'],zorlukSeviyesi:2);
  var kelime2= Kelime(metin: 'Force',yasaklilar:['jedi','sith','push'],zorlukSeviyesi:3);

  var kurulum = OyunKurulumu(
    sure: 60,
    hedefSkor: 30,
    passHakki: 3,
    oyuncular: [anakin, obiwan,maul,sidious],
  );

  var durum = Durum(
    kurulum : kurulum,
    takimListesi : [takim1,takim2],
    aktifTakimIndex : 0,
    aktifKelime: Kelime(metin:'Star',yasaklilar:['sky','galaxy','universe'],zorlukSeviyesi:2),
    kalanKelimeler: [kelime1,kelime2],
    kalanPass : 3,
    kalanSure : 10,
    finish : false,

  );

  var yenitakim = takim2.copyWith(ad:'Dark Side');
  var yenisure = durum.copyWith(kalanSure:9);

  print('${takim2.ad}: ${yenitakim.oyuncuSayisi} oyuncu');
  print('${yenisure.kalanSure} s');


}
