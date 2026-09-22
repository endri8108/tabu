sealed class GameEvent {}

class Correct extends GameEvent {}

class Taboo extends GameEvent {}

class Pass extends GameEvent {}

class SecondTick extends GameEvent {}

class TurnEnded extends GameEvent {}
