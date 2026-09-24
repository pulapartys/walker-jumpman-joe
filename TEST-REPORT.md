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

## Firefighter Rescue — increments 1–2 (character + flames) · 2026-09-23
Pivoted from postman (CHANGE-BRIEF §0). Source: working tree on top of 8672fe3.
Changes: `player.gd` `_draw()` → firefighter; `session.gd` spike → flames. Both pure repaints.

### System tests (automated) — ✅ PASS
`test_game.gd` **25/25**, `test_keyboard.gd` **9/9** (34/34). Physics-identity numbers
unchanged from baseline (jump rise 56.0747 px; spike collision; 20 retries; 325-tick
route) → the reskins changed no behavior.

### Manual tests (human, visual) — ⏳ PENDING
| # | Check | Result |
|---|---|---|
| F1 | Reads as a firefighter (helmet + coat + rescue bag) | ⏳ |
| F2 | Facing left/right mirrors (helmet tail, tank, bag trail behind) | ⏳ |
| F3 | Jumping looks right | ⏳ |
| F4 | Flames read as fire (not spikes); still deadly on touch | ⏳ |
| F5 | Controls/feel unchanged | ⏳ |

---

## Firefighter Rescue — Increment 3 (extended level: climb + dog detour + window) · 2026-09-23

### System tests (automated) — ✅ 36/36
`test_game.gd` **27/27** (added `extension-climb-and-detour`, `flame-clearance-positive`); `test_keyboard.gd` **9/9**.
- `complete-real-route`: **0 deaths**, reaches the window in **758 ticks**, `returned=true` (dog detour executed).
- `extension-climb-and-detour`: PASS — the scripted route climbs, drops to the dog ledge, jumps back, and finishes.
- `flame-clearance-positive`: min feet-above-flame (real engine) — **P2→P3 = 13.4px, P3→P4 = 12.1px**.
- Baseline mechanics (jump rise 56.07, coyote/buffer, spike, 20 retries, fall) still pass unchanged.

Two issues the real engine caught (and the fixes):
- **Window tripped mid-jump** — the P4→P5 arc passed through the window. Fixed: finish now requires `is_on_floor()`.
- **Flame P3→P4 grazing at 0.07px** — hand model overestimated. Fixed: lowered both climb flame rects (now 13.4 / 12.1px).

### Manual tests (human) — ✅ played 2026-09-23
- **Climb completable:** reached the window in **~42 s, 0 retries** → the route is reachable in real play ✓.
- **Reskin/theming reads correctly in play:** firefighter, flames, window, and floor labels all read as intended.
- **Observation:** the flames sit in the gaps at take-off level, so **every jump clears them — fire never blocks the route** (it reads as scenery, not an obstacle). → revision planned (see FRICTIONAL cycle #1): move flames onto the platforms as jump-over obstacles.
- **Not yet built (Increment 4) — noted as PENDING, not defects:** touching the person/dog does nothing; the window completes on contact **regardless of rescues** (no gating, no rescue counter yet).

---

## Firefighter Rescue — Increment 4 (rescue + gated exit + fire-on-platforms + clarity) · 2026-09-23

### System tests (automated) — ✅ 37/37
`test_game.gd` **28/28** (added `exit-locked-without-rescues`); `test_keyboard.gd` **9/9**.
- `complete-real-route`: **0 deaths**, **rescued 2/2** (person + dog), reaches the exit (750 ticks).
- `exit-locked-without-rescues`: PASS — standing at the exit with 0 rescued does **not** complete (state stays PLAYING) → gating works.
- `flame-clearance-positive`: fire now sits **on the platforms**; real jump-over clearances **P1 28.1px, P3 24.1px, P4 31.8px** (comfortable). The toothless gap-flames were removed. (First placement grazed at 5.4px → widened the takeoff-to-flame distance.)
- Baseline mechanics unchanged.

### Manual tests (human) — played 2026-09-23 (findings → Iteration 2)
Rescue both (person on the climb, dog on the detour); confirm the exit is **locked** until both are saved (cue shows) and **unlocked** after; a real failure (fire on a floor + a fall) → retry resets survivors + counter; the HUD objective + HELP! bubbles read clearly; replay.

### Increment 4 — Iteration 2 (playtest findings) · 2026-09-23
- **Rescue has no visible payoff:** the bag "head" was only ~1.3px and the "SAVED!" popup (in the Inc-4 spec) was never implemented, so rescuing *looks* like nothing happened even though the HUD `SAVE:` checkbox flips. (Also investigated a "still shows HELP! after collection" report.)
- **Fire doesn't read as lethal:** a playtester couldn't tell the platform flames are deadly (too small/faint to signal "jump over me").
→ Fixes in Iteration 2 (see FRICTIONAL cycle #2): visible bag heads (person + dog w/ ears), a SAVED! popup, bolder/vivid flames (collision unchanged so the jump margins hold), and a runtime check that a rescued survivor is removed.

**Iteration 2 result (automated, 2026-09-23):** fixes applied → **38/38** (added `survivor-removed-on-rescue`; prior 37 unchanged, none weakened). Flame clearances **unchanged at P1 28.1 / P3 24.1 / P4 31.8px** despite the bolder flame visual (collision rects untouched). `survivor-removed-on-rescue` PASS (`still_monitoring:false`). Human re-playtest pending.

### Increment 4 — Iteration 3 (playtest findings) · 2026-09-23
Playtest found rendering/placement bugs the automated tests missed (they assert state/data, not rendering):
- **(a) Platform flames don't kill a walking player** — the flame collision rects sat AT the platform surface (inside the platform body), not sticking up above it, so walking through didn't hit them.
- **(b) Dynamic level visuals never update** — rescued survivors didn't disappear, the "SAVED!" popup never showed, and the fire escape never visually unlocked, because `session.gd` only queued its own `_draw()` once at startup (the HUD redraws each frame; the level didn't).
- **(c)** The "02 / CLIMB & RESCUE" label was hidden behind a platform.
- Note: 38/38 still passed because those checks assert state/data, not pixels → added a walk-into-flame lethality check (below).

**Iteration 3 result (automated, 2026-09-23):** **41/41** (added `walk-into-flame-P1/P3/P4`; prior 38 unchanged, none weakened).
- `walk-into-flame-P1/P3/P4`: **DYING** → flames now kill a walking player (rects raised to stick up above each platform).
- `complete-real-route`: still **0 deaths, rescued 2/2** — the scripted jumps clear the now-taller flames. Real clearances **P1 14.1 / P3 10.1 / P4 17.8px** (lower than before because flames are 14px taller; still positive — P3 tightest).
- `queue_redraw()` added to `session._physics_process` fixes the stale dynamic visuals (survivors vanish, SAVED! popup, fire-escape unlock). Rendering confirmed by **human visual check** (tests can't see pixels).
