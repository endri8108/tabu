# Tabu — Design Overview

## The game
- The describer explains the word to their own team. Green = correct, red = taboo, yellow = pass.
- Modes: single phone (offline) / multiple phones (online) · same room / remote · 2v2 / individual
- Max 4 players (v1). Invite friends via QR code.

## Phases
- v1: single phone, offline, pure Dart. A playable game.
- v2: online, same room. Backend + WebSocket + auth + QR.
- v3: *remote voice over WebRTC.

## Architecture
- Game engine: `apply(state, event) → new state`. Pure and framework-free: it knows nothing about Flutter, the screen or the network.
- Role-based views (`view(state, player)`) come in v2 with online mode. On a single phone only the describer looks at the screen anyway.
- Written in Dart first, later ported to Java with the same tests.
- Stack: Flutter + Dart, Java + Spring Boot, PostgreSQL, WebSocket/STOMP, Drift.

---

## Game engine (v1) — how it works

### In one sentence
The current state of the game lives in a `GameState` object. Everything that happens (a button press, a second passing) is an **event**. `apply()` takes the old state and an event and returns a **new** state. The old state is never modified.

```
Setup screen ──► GameState.initial(config, words) ──► first state
                                                         │
     button / timer ──► event ──► apply(state, event) ──► new state ──► screen redraws
                                        ▲                     │
                                        └─────────────────────┘
```

### Files
| File | Holds |
|---|---|
| `lib/domain/model/game_config.dart` | Setup: round length, target score, pass limit, teams |
| `lib/domain/model/team.dart` | Team: name, players, score, index of the next describer |
| `lib/domain/model/player.dart` | Player: name, id |
| `lib/domain/model/word.dart` | Card: word, forbidden words, difficulty |
| `lib/domain/model/game_state.dart` | Current game state + `initial()` + `describer` |
| `lib/domain/game/game_event.dart` | Events: `Correct`, `Taboo`, `Pass`, `SecondTick`, `TurnEnded` |
| `lib/domain/game/game.dart` | `apply()` — all game rules live here |

### `GameState` fields
| Field | Meaning |
|---|---|
| `config` | Settings given at setup (never changes) |
| `teams` | **Current** teams (score, describer order) |
| `activeTeamIndex` | The team currently playing |
| `startingTeamIndex` | The team that played the first turn; a round ends when the turn comes back to it |
| `currentWord` | The card in the describer's hand (on screen) |
| `remainingWords` | The deck: cards not drawn yet |
| `usedWords` | Cards already played (guessed, taboo, passed or discarded), waiting to be reshuffled |
| `remainingSeconds` | Time left in the turn |
| `remainingPasses` | Passes left in the turn |
| `isFinished` | Whether the game is over |
| `describer` (computed) | The player describing now = the active team's player at `describerIndex` |

### Starting a game: `GameState.initial(config, words)`
- Throws `ArgumentError` if the word list is empty — no game without cards.
- Takes the teams from `config` and resets their scores to 0.
- The first word goes to `currentWord`, the rest into the deck (`remainingWords`).
- Time and passes come from `config`; the team at `startingTeamIndex` starts (default 0, throws `ArgumentError` if there's no such team). The app picks it at random, so it isn't always the same team that starts.

### Events and rules
| Event | What happens |
|---|---|
| `Correct` | Active team +1. A new card is drawn. (Reaching the target does **not** end the game mid-turn — see decision 6.) |
| `Taboo` | Active team −1 (score can go negative). A new card is drawn. |
| `Pass` | If passes are left, one is used and a new card is drawn. With no passes left, nothing happens. |
| `SecondTick` | Time goes down by 1. At 0, `TurnEnded` is applied automatically. |
| `TurnEnded` | The finishing team's describer moves to their next player. If this closes a round and one team has reached the target score while being strictly ahead, the game ends. Otherwise the turn passes to the next team, time and passes reset, the half-played card is discarded and a new one is drawn. |

**Two rules that apply to every event:**
1. **If the game is finished** (`isFinished`), no event changes the state.
2. **If the deck is empty** whenever a card should be drawn, the used cards are shuffled into a new deck (decision 1). The game never ends because of the deck.

---

## Decisions

**1. When the deck runs out, the used cards are reshuffled.**
Every card that leaves the screen goes to `usedWords`. When a card should be drawn and the deck is empty, `usedWords` is shuffled and becomes the new deck, and the card just played goes to its bottom so it can't come straight back. So the game only ends by the target score (decision 6), and every team always gets the same number of turns.
All card drawing goes through one helper, `_drawCard`. The shuffle order comes from a `Random` that `apply()` takes as an optional third argument, so tests can pass a seeded `Random` and keep the engine predictable (decision 4).
Before this, the game ended when the deck ran out — which could happen mid-round, before every team had played the same number of turns.

**2. Teams live inside `GameConfig`.**
On the setup screen players enter their names, form teams, and then the game starts — so teams are part of the setup. Players used to be stored in two places (`config.players` and inside each team); keeping them in one place removes the risk of the two getting out of sync.
`config.teams` are the starting teams, `state.teams` are the current ones (scores change in `state` during the game).

**3. Describer order is stored on the team: `Team.describerIndex`.**
Each team remembers who its next describer is. When a turn ends, only the finishing team's index moves forward, wrapping around with `%`: A1 → B1 → A2 → B2 → A1…
The alternative was computing the describer from a single turn counter; that would work too, but it's harder to read. This approach also works naturally when teams have different numbers of players.

**4. The engine is pure and immutable.**
`apply()` never changes anything in place; it always returns a new `GameState` (via `copyWith`). Same input → always the same output. That makes it easy to test, and the same engine can later run on a server (Java).

**5. `copyWith` takes a function for `currentWord`.**
It's passed as `currentWord: () => word`. This lets us tell apart "nothing was passed (keep the old one)" from "set it to `null` on purpose".

**6. The target score is checked at the end of a round, not mid-turn.**
A round is over when the turn comes back to the starting team (`startingTeamIndex`), so every team has played the same number of turns. Only then is the target checked: a team that has reached it **and** is strictly ahead wins. On a tie at the top another round is played.
Before this, `Correct` ended the game the moment a team reached the target — the first team could win without the second team ever playing.

**7. A random team starts.**
Always letting the first team start gave it a small edge and got boring. The engine doesn't pick the team itself — `GameState.initial` takes `startingTeamIndex`, and the app passes a random one (`sample_game.dart`). That keeps the engine predictable in tests. Because the starting team is stored, the round-end check (decision 6) still works when the second team starts.

---

## Tests
`test/game_test.dart` — 24 tests, run with `fvm flutter test`. Covered:
- Correct → score +1
- Events are ignored after the game is finished
- `copyWith` can set `currentWord` to null
- `initial` sets up the game correctly; any team can start; throws on an empty word list or a starting team that doesn't exist
- The turn passes to the other team when time runs out
- A new card is drawn when the turn ends
- Describer rotation after 1, 2 and 4 turns (including wrap-around)
- Target score: not checked mid-turn, the second team still gets its turn, game ends at round end when one team is ahead, a tie plays another round, the round ends on the right team when the second team started
- Deck runs out: the last card still scores and the game goes on, used cards come back as a new deck, the card just played doesn't come straight back, a one-card game keeps working, `TurnEnded` on an empty deck passes the turn

## Open questions
- **At least 2 teams are needed**: the UI detects the end of a turn by `activeTeamIndex` changing.
- **A team with no players** would cause a division-by-zero error in `% playerCount` → the setup screen won't allow "Start" until every team has at least one player.
- The `Role` enum (`role.dart`) isn't used yet — it will be used with `view()` (v2).
