import 'domain/model/player.dart';
import 'domain/model/team.dart';
import 'domain/model/word.dart';
import 'domain/model/game_config.dart';
import 'domain/model/game_state.dart';

void main() {
  var anakin = Player(name: 'Anakin', id: 1);
  var obiwan = Player(name: 'Obi Wan Kenobi', id: 2);

  var maul = Player(name: 'Darth Maul', id: 3);
  var sidious = Player(name: 'Darth Sidious', id: 4);

  var jedi = Team(name: 'Jedi', players: [anakin, obiwan], score: 0);
  var sith = Team(name: 'Sith', players: [maul, sidious], score: 1);

  var war = Word(
    text: 'War',
    forbiddenWords: ['light', 'dark', 'saber'],
    difficulty: 2,
  );
  var force = Word(
    text: 'Force',
    forbiddenWords: ['jedi', 'sith', 'push'],
    difficulty: 3,
  );

  var config = GameConfig(
    roundSeconds: 60,
    targetScore: 30,
    passLimit: 3,
    players: [anakin, obiwan, maul, sidious],
  );

  var state = GameState(
    config: config,
    teams: [jedi, sith],
    activeTeamIndex: 0,
    currentWord: Word(
      text: 'Star',
      forbiddenWords: ['sky', 'galaxy', 'universe'],
      difficulty: 2,
    ),
    remainingWords: [war, force],
    remainingPasses: 3,
    remainingSeconds: 10,
    isFinished: false,
  );

  var renamedTeam = sith.copyWith(name: 'Dark Side');
  var tickedState = state.copyWith(remainingSeconds: 9);

  print('${sith.name}: ${renamedTeam.playerCount} players');
  print('${tickedState.remainingSeconds} s');
}
