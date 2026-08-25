enum KartSonucu { dogru, tabu, pas }

int puanDondur(KartSonucu sonuc) {
  switch (sonuc) {
    case .dogru:
      return 1;

    case .tabu:
      return -1;

    case .pas:
      return 0;
  }
}