# Tabu — Tasarım Özeti

## Oyun
- Anlatan kendi takımına anlatır. Yeşil=doğru, Kırmızı=tabu, Sarı=pas.
- Modlar: tek telefon (offline) / çok telefon (online) · aynı oda / uzak · 2v2 / bireysel
- Max 4 oyuncu (v1). QR ile arkadaş daveti. Matchmaking yok.

## Aşamalar
- v1 (hafta 1-2): Tek telefon, offline, sadece Dart. Oynanan oyun.
- v2 (hafta 3-5): Online, aynı oda. Backend + WebSocket + auth + QR.
- v3 (yaz kalanı): WebRTC ile uzaktan ses.

## Mimari
- Oyun motoru: uygula(olay)→durum ve goster(oyuncu)→görüntü. Saf, framework'süz.
- Önce Dart, sonra Java'ya taşınır, aynı testler.
- Stack: Flutter + Dart, Java + Spring Boot, PostgreSQL, WebSocket/STOMP, Drift.
