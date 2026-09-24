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

---

## Firefighter Rescue — Increment 5 (countdown timer) · 2026-09-23

### System tests (automated) — ✅ 44/44
`test_game.gd` **35/35** (added `route-beats-timer`, `timer-expiry-fails`, `timer-resets-on-retry`); `test_keyboard.gd` **9/9**.
- `route-beats-timer`: the scripted route finishes in **12.55s** of the **50s** limit (comfortable human margin).
- `timer-expiry-fails`: hitting 0 → **DYING** with reason **"Out of time!"** → retry.
- `timer-resets-on-retry`: after a timeout retry, `elapsed` is back to ~0 (timer full).
- Pause still freezes the timer (`pause-freezes` unchanged). No assertions weakened.

### Manual tests (human) — played 2026-09-24
- **HUD countdown** reads clearly (red under 10s); running out → "Out of time!" + retry with a full timer — confirmed.
- **Feel/tuning:** at 50 s the timer felt **too long** — Sreeja finished **under 35 s every run**, so there was no real pressure. Tuned the limit to **30 s** (her call). The scripted route still finishes in 12.55 s (`route-beats-timer` passes at 30 s). Trade-off: leisurely ~34 s runs may now time out — the intended pressure. See FRICTIONAL cycle #4.
- **Dynamic visuals confirmed in play (human, 2026-09-24):** on rescue the **"SAVED!" popup appears**, the rescued **person and dog vanish** from their spots, and **their heads appear in the firefighter's bag** — confirming the Iteration-3 `queue_redraw()` fix **at runtime** (the automated suite verifies state/data, not pixels).

---

## Consolidated verification — the finished game (timer build) · 2026-09-24

The rubric's six Verification checks against the final build (Increments 1–5).
Automated is fully verified; the manual rows cite the **real** per-iteration playtests
(FRICTIONAL cycles + the entries above), with a **final end-to-end pass** of the timer
build recorded with the player's own observations before the film.

| # | Rubric check | Status | Evidence |
|---|---|---|---|
| 1 | **Startup & controls** — runs; move/jump/pause-resume/restart work | ✅ | `test_keyboard.gd` 9/9 (start, move, jump, pause, resume, retry, replay, menu) + iterative play |
| 2 | **Character appearance** — L/R, standing, jumping; no visual/collision mismatch | ✅ | firefighter reads in all states; bag heads visible (Iter 2–3 playtests); collider unchanged (jump rise 56.07 identical) |
| 3 | **Extended route** — a normal route reaches both new landings + relocated finish | ✅ | Inc-3 playtest reached the window (~42 s, 0 retries); Inc-4 rescues both then exits; `complete-real-route` 0 deaths |
| 4 | **Failure & recovery** — real hazard/miss → retry; replay after completion | ✅ | fire death + fall → retry (Inc-3/4 play); `walk-into-flame-P1/P3/P4` lethal; timeout → retry; `replay-idempotent` |
| 5 | **Camera & presentation** — extension + landing/finish info visible/readable | ✅ | Inc-3 playtest confirmed readability across the wider level; hidden "02" label fixed (Iter 3) |
| 6 | **Automated checks** — commands + results + any updated/failed tests | ✅ | **44/44** (`test_game` 35 + `test_keyboard` 9); route/finish fixtures updated for the new layout; a `replay-idempotent` ordering issue was fixed (not weakened) |

**Remaining before the film: one final end-to-end run of the timer build** — climb →
rescue both → beat the clock → jump out → replay — to be recorded here with the player's
real observations (especially the **countdown timer** and the **P3 ~10 px** jump feel).
_No playtester or observation is invented._

---

## Two-building level redesign — runtime verification (automated) · 2026-09-24
Rebuilt the level as **two burning buildings** (person in B1, dog in B2, a burning street between, B2 rooftop = gated exit). Re-layout + re-draw; mechanics unchanged.

### System tests (automated) — ✅ 44/44
`test_game.gd` **35/35**, `test_keyboard.gd` **9/9**.
- `complete-real-route`: **0 deaths, rescued 2/2**, reaches the **B2 roof exit** (1999, 164) in **761 ticks (~12.7 s)** — the full path works: approach → climb B1 (rescue person) → **descent to B1's base** → **burning-street jump** → climb B2 (rescue dog) → gated roof exit.
- `reached-b2-roof-both-rescued`: PASS (replaces the old detour check).
- **Failure case #1 (descent into the street): cleared** — the route survives the drop + street with 0 deaths → the drop lands on B1's wide base, not the street.
- **Failure case #2 (flame lethal + jumpable): cleared** — `walk-into-flame-B1L1/B2L1/B2L2` all **DYING**; real margins **B1-L1 10.1 / street 5.8 / B2-L1 10.1 / B2-L2 10.1 px** (a first pass grazed at −3.5 px vs the rect top → widened the window ledges + earlier takeoffs).
- `exit-locked-without-rescues` (now at the B2 roof), `survivor-removed-on-rescue` (new person pos), `route-beats-timer` (12.7 / 30 s) all pass. **No assertions weakened.**

### Manual (human) — ⏳ PENDING
Play it: climb B1 → rescue person → down → cross the burning street → climb B2 → rescue dog → jump off the B2 roof.

---

## Hose mechanic — runtime verification (automated) · 2026-09-24
Added an **extinguishable blocking fire** that stands **between** the firefighter and a **visible trapped person** on B1's window ledge, a new **W = "water"** input, and tuned the landing/descent/street for safety. Documented predict-before-code (CHANGE-BRIEF hose revision).

**Ledge layout (left → right):** landing runway (x1175–1250) → **blocking fire (1250–1306)** → **person at 1335** (visible, HELP! bubble, clear of the fire). Fire lethal + blocks the path until hosed.

**Progressive extinguish (updated 2026-09-24):** W-in-range starts the water; the fire is **full**, shrinks to **half height at t=2 s**, and is **gone at t=4 s**. The kill-zone shrinks from the top *with* the flames (`fire_height()` drives both the drawing and the collision), but the **base stays lethal + blocking until fully out** — walking in mid-extinguish still kills, and the person is unreachable until t=4 s. Water visual lingers ~1 s after. **Timer set to 40 s** (human-playtested fair).

### System tests (automated) — ✅ 50/50
`test_game.gd` **41/41** (added 6 hose checks), `test_keyboard.gd` **9/9**.
- **Safe landing:** `complete-real-route` runs the full path — approach → climb B1 → **hose the fire** → walk right → rescue person → descent → street → climb B2 → rescue dog → roof — with **0 deaths** (1040 ticks, ~17.4 s). Lands with ~40 px runway *left* of the fire, stops (no slide-in), hoses, waits out the ~4 s extinguish, then walks through. Flame clearances all positive (street **+17.8 px**).
- **Progressive lethality:** `half-size-fire-still-kills` — at **t=2 s** the fire is half height (`extinguish_ticks=120`, exactly half) yet stepping in → **DYING, person NOT rescued**. `hose-extinguishes-fire` — still lit at 3.5 s, **out by ~4 s** (`lit_at_3.5s=true` → gone).
- **Gating both directions:** `person-rescue-blocked-until-extinguished` *walks into the lit fire* → **DYING, not rescued** (unreachable while lit); `survivor-removed-on-rescue` *extinguishes first, then walks to the person* → **rescued & removed** (reachable only after fully out).
- `hose-out-of-range-noop` (W far → fire stays), `blocking-fire-kills-on-touch` (DYING), `extinguish-resets-on-retry` (fire back to full + timer 40 s on retry) — **all PASS.**
- `route-beats-timer` passes at the **40 s** limit (~17.4 s run). Existing controls untouched (`test_keyboard` 9/9); **W is additive**. No assertions weakened.

### Manual (human) — ⏳ PENDING
Reach B1's window → see the **trapped person behind the fire** + the **"Press W to hose the fire"** prompt → tap **W** → watch the **fire shrink (full → half → gone over ~4 s)** while water pours → then walk across and rescue the person. Confirm you **can't slip through the half-size fire**. Then street → B2 → roof. **Timer 40 s — confirm a normal run still finishes comfortably (bot run ~17.4 s).**

---

## Readability + figure pass (drawing only) · 2026-09-24
Pure repaint — **no collision / trigger / tuning / control / survivor-exit-position changes**. Suite still **50/50** (`fixed-jump` rise **56.07 px** unchanged). Verified in rendered screenshots (`evidence/screens/read-b1-person.png`, `read-b2-dog.png`):
- **Facades** → **very light brown**, with **half as many beige/cream windows** (brown frames) — no orange facade windows, so the **only orange on screen is the actual fire**, which now pops; the dark firefighter + survivors read strongly against the light wall.
- **Survivors redrawn** to read at game size: the **person** is a clear waving human (head + face, torso, one raised arm, legs); the **dog** has ears, a snout, a tail, four legs. Both get a bright fill + dark outline.
- **Windows** are now **dark openings** (thin frame + dark interior + soft backlight), not solid boxes — survivors no longer share their window's colour and pop against it.
- **HELP! bubbles** enlarged (bigger box + size-15 text) with a **pointer/tail** to the survivor; the "Press W to hose the fire" prompt lifted higher so it's clearly visible above the flames + bubble, and **W: hose** added to the top controls bar.
- **Firefighter** gets a pale **rim light** so it reads against dark ledges + burning interiors.
- Screenshot check: firefighter, clearly-a-person + clearly-a-dog survivors, HELP! signs, and the fire all read cleanly on the buildings. ✅
