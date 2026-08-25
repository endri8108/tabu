import 'oyuncu.dart';

class OyunKurulumu{

  final int sure;
  final int hedefSkor;
  final int passHakki;
  final List<Oyuncu>oyuncular;

  OyunKurulumu({required this.sure,
                required this.hedefSkor,
                required this.passHakki,
                required this.oyuncular});

}