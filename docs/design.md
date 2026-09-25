# Tabu — Design Overview

## The game
- The describer explains the word to their own team. Green = correct, red = taboo, yellow = pass.
- Modes: single phone (offline) / multiple phones (online) · same room / remote · 2v2 / individual
- Max 4 players (v1). Invite friends via QR code. No matchmaking.

## Phases
- v1 (weeks 1–2): single phone, offline, pure Dart. A playable game.
- v2 (weeks 3–5): online, same room. Backend + WebSocket + auth + QR.
- v3 (rest of summer): remote voice over WebRTC.

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
| `currentWord` | The card in the describer's hand (on screen) |
| `remainingWords` | The deck: cards not drawn yet |
| `remainingSeconds` | Time left in the turn |
| `remainingPasses` | Passes left in the turn |
| `isFinished` | Whether the game is over |
| `describer` (computed) | The player describing now = the active team's player at `describerIndex` |

### Starting a game: `GameState.initial(config, words)`
- Throws `ArgumentError` if the word list is empty — no game without cards.
- Takes the teams from `config` and resets their scores to 0.
- The first word goes to `currentWord`, the rest into the deck (`remainingWords`).
- Time and passes come from `config`; the first team (index 0) starts.

### Events and rules
| Event | What happens |
|---|---|
| `Correct` | Active team +1. If the target score is reached, the game ends. Otherwise a new card is drawn. |
| `Taboo` | Active team −1 (score can go negative). A new card is drawn. |
| `Pass` | If passes are left, one is used and a new card is drawn. With no passes left, nothing happens. |
| `SecondTick` | Time goes down by 1. At 0, `TurnEnded` is applied automatically. |
| `TurnEnded` | The finishing team's describer moves to their next player. The turn passes to the other team. Time and passes reset. The half-played card is discarded and a new one is drawn. |

**Two rules that apply to every event:**
1. **If the game is finished** (`isFinished`), no event changes the state.
2. **If the deck is empty** whenever a card should be drawn, the game ends.

---

## Decisions (and why)

**1. The game ends when the deck runs out; the last word still counts.**
The last word is a normal word: if it's guessed before time runs out it scores, if it's a taboo it loses a point. That's why the code updates the score first and checks the deck afterwards.

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

---

## Tests
`test/game_test.dart` — 12 tests, run with `fvm flutter test`. Covered:
- Correct → score +1; correct on the last card → game ends and the point counts
- Events are ignored after the game is finished
- `copyWith` can set `currentWord` to null
- `initial` sets up the game correctly; throws on an empty word list
- The turn passes to the other team when time runs out
- A new card is drawn when the turn ends
- Describer rotation after 1, 2 and 4 turns (including wrap-around)

## Open questions
- **The target score is currently checked mid-turn** (on `Correct`). In real Taboo it's checked at the end of the turn, and play continues on a tie. To be decided.
- **A team with no players** would cause a division-by-zero error in `% playerCount` → the setup screen won't allow "Start" until every team has at least one player.
- The `Role` enum (`role.dart`) isn't used yet — it will be used with `view()` (v2).
- The "draw a card from the deck" code is repeated in `Correct`/`Taboo`/`Pass`/`TurnEnded`; it could be moved into a single helper function.
