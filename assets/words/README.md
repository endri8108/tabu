# Word list

`en.json` holds the **general** English cards the game plays with — 2,176 everyday words anyone knows, one card per line:

```json
{"word": "Sun", "forbidden": ["bright", "hot", "sky", "day", "light"], "difficulty": 1, "category": "mixed"}
```

| Field | Meaning |
|---|---|
| `word` | The word on the card |
| `forbidden` | Exactly 5 words the describer may not say |
| `difficulty` | 1 = easy, 2 = medium, 3 = hard |
| `category` | Topic of the card (food, animals, sports, …). Not used by the game yet. |

## Mode cards (`modes/`)
Field-specific words were kept **out** of the general list and saved per topic for the upcoming modes:
`computer_science.json`, `medicine.json`, `engineering.json`, `science.json`, `art.json` (74 cards in total, same format).
They are only seeds — each mode needs many more cards before it is playable — and they are not bundled into the app yet.

Rules every card follows, in every file (checked by `test/word_list_test.dart`):
- 5 different forbidden words
- no card appears twice — not even across the general list and the mode files
- no forbidden word contains a part of the card itself ("Polar bear" can't forbid "bear" — saying part of the card is never allowed anyway)

## Sources
- 258 cards (category `mixed`) come from [mohitooo28/Taboo](https://github.com/mohitooo28/Taboo) (`lib/data/default_words.json`), MIT License — see below. Adult and region-specific cards were left out; forbidden words were lower-cased.
- All other cards were written for this project.

## Third-party license

```
MIT License

Copyright (c) 2025 Mohit

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
