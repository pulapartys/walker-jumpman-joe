# TEST-REPORT — walker-jumpman-joe

> Actual test results, per Assignment 1 Step 3. Two kinds of tests:
> - **System tests (automated):** the headless suites in `godot/tests/` (mechanics
>   + keyboard). Run by command; deterministic; catch regressions.
> - **Manual tests (human):** I play the game and judge what code cannot —
>   visuals, readability, feel. **Real observations only; nothing invented.**
>
> Results are recorded per build; earlier results are retained.

- **Assignment:** Assignment 1 — Extend Walker Jumpman (CSYE 7270, Fall 2026)
- **Student:** Sreeja Pulaparty (pulaparty.s@northeastern.edu)
- **Engine:** Godot 4.7.2.stable.official.ed1daf0bf · macOS
- **Godot binary:** `~/Downloads/Godot.app/Contents/MacOS/Godot`

### How to re-run the system tests
```
<godot> --headless --path godot --script res://tests/test_game.gd
<godot> --headless --path godot --script res://tests/test_keyboard.gd
```
`test_game.gd` ends with `WALKER TESTS: N checks / M failures`.

---

## Baseline — starter, before any changes (2026-09-22)
Source revision: **9387542** (starter "First Steps").
- **System:** `test_game.gd` **25/25 PASS**, `test_keyboard.gd` **9/9 PASS** (34 total).
- **Manual:** played to "Course complete." in the editor (10.9 s, 1 retry). Baseline confirmed working.

---

## Character — Iteration 2 (Postman): first applied code build (2026-09-22)
Source: **working tree on top of 9387542** (character change uncommitted at test time).
Change under test: `player.gd` `_draw()` rewritten to a postman — a **pure
repaint**; the collider in `_ready()`, `_physics_process()`, and `tuning.gd` are
unchanged. (Code log: WORK-PROGRESS.md Entry 4. Prediction: CHANGE-BRIEF.md §1.)

### System tests (automated) — ✅ PASS
| Suite | Command | Result |
|---|---|---|
| Mechanics | `res://tests/test_game.gd` | **25 / 25 PASS** |
| Keyboard | `res://tests/test_keyboard.gd` | **9 / 9 PASS** |
| **Total** | | **34 / 34 PASS** |

**Physics-identity check** — these must match the baseline exactly to prove the
repaint changed no behavior. They do:

| Check | Observed | Matches baseline? |
|---|---|---|
| fixed-jump rise | 56.0747 px | ✅ |
| coyote 5 / 6 / 7 | jump / jump / no-jump | ✅ |
| buffer 5 / 6 / 7 | jump / jump / no-jump | ✅ |
| actual-spike-collision | death → DYING | ✅ |
| twenty-retries | 21 deaths, max 34 ticks | ✅ |
| complete-real-route | 0 deaths, 325 ticks, (912.88, 319.92) | ✅ |

**Conclusion:** controls, jump feel, collision, retry, and completion are
unchanged. Satisfies "preserve the control/retry experience" and clears predicted
failure case #2 (collision) on the physics side. The remaining question — does the
postman *look* right? — is a manual visual check below.

### Manual tests (human, visual) — ✅ PASS (human playtest, 2026-09-22)
Player (Sreeja Pulaparty) played the build in the Godot editor and confirmed every
check below. The postbox finish was added and confirmed in the same session.

| # | What to check | Result |
|---|---|---|
| M1 | Reads as a **postman** at game size | ✅ pass |
| M2 | Facing **right** — brim + eye lead, bag + strap trail | ✅ pass |
| M3 | Facing **left** — everything mirrors cleanly | ✅ pass |
| M4 | **Standing** — legs still, no jitter | ✅ pass |
| M5 | **Jumping** — no glitch mid-air | ✅ pass |
| M6 | No visual/collision mismatch — body matches the box | ✅ pass |
| M7 | Controls still **feel** right (move/jump/pause/retry) | ✅ pass |
| M8 | **Postbox** finish reads correctly at the goal | ✅ pass |

Player summary: _"all good, manually tested everything works."_ Completed a full
run to the postbox (9.5 s, 2 retries). Both predicted failure cases from the
CHANGE-BRIEF (facing-flip, visual/collision mismatch) checked out fine.

> Optional evidence: we can generate rendered viewport captures (menu, failure,
> jump, completion) via `res://tests/capture_game.gd` for the film/README later.

---

## Level extension — (results added after we build it)
_Not started._
