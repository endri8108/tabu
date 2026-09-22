enum CardResult { correct, taboo, pass }

int pointsFor(CardResult result) {
  switch (result) {
    case .correct:
      return 1;

    case .taboo:
      return -1;

    case .pass:
      return 0;
  }
}
