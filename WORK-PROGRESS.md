# WORK-PROGRESS — Code Change Log

> A running, TA-friendly log of **every code file we touch**, what changed, why,
> and how we verified it. Purpose: make it easy to explain the implementation to
> the professor/TA and to trace each change back to an assignment requirement.
> (Doc/writing files are listed briefly at the bottom; this log is mainly code.)

- **Project:** walker-jumpman-joe (starter: nikbearbrown/walker-jumpman)
- **Engine:** Godot 4.7.2.stable.official.ed1daf0bf · macOS
- **Baseline commit:** 9387542 (branch: `working`)

**Status legend:** 🔲 planned · 🔧 in progress · ✅ applied & verified · ⛔ must NOT change (assignment rule)

---

## The codebase at a glance (baseline, before my changes)

What each code file does, so a reviewer understands the starting point:

| File | Role |
|---|---|
| `godot/game/main.tscn` | Near-empty entry scene; just attaches `session.gd`. |
| `godot/game/session.gd` | **The brain.** Reads the level JSON, builds all platforms/spikes/flag/walls, spawns player + camera + HUD, runs the state machine (MENU→PLAYING→DYING→COMPLETE), and **draws the level** (`_draw()` has some hard-coded coordinates). |
| `godot/features/player/player.gd` | The player: input→movement, jump/gravity, and **self-drawing** in `_draw()`. Collider (18×28) defined in `_ready()`. |
| `godot/features/player/tuning.gd` | Just **numbers**: speed, acceleration, jump, gravity, coyote/buffer windows. |
| `godot/ui/hud.gd` | On-screen text, progress bar, menus/overlays. |
| `godot/levels/first_steps.json` | The **level as data**: floor pieces, steps, hazard, finish, width, spawn, fall line. |
| `godot/tests/test_game.gd` | ~25 headless mechanics checks (movement, jump height, coyote/buffer, spike death, respawn, full winning route). |
| `godot/tests/test_keyboard.gd` | 9 checks that inject real key events. |
| `godot/tests/route_driver.gd` | The known winning input route (jump marks at x = 138, 292, 424, 548, 712). |
| `godot/tests/capture_game.gd` | Renders viewport screenshots for evidence. |

---

## Files I am changing (and why) — the plan

| File | Change | Assignment requirement | Status |
|---|---|---|---|
| `features/player/player.gd` | `_draw()` → **firefighter** (Iteration 3; postman was prior) + `rescued` var for bag heads | New visual identity | ✅ applied · system pass · manual ⏳ |
| `features/player/tuning.gd` | — | Preserve movement/jump feel | ⛔ must not change |
| `levels/first_steps.json` | width 960→1900; original approach kept; climb P1–P5 + dog ledge PD (open sky); finish → window; `survivors`; flames | Extend playable level (≥2 new landings) | ✅ built · route test passes · manual ⏳ |
| `game/session.gd` | flames ✅; finish → **window** ✅ (data-driven, `is_on_floor` gate); widened bg/grid/mountains ✅; survivors drawn ✅; themed labels/death ✅ (rescue Area2Ds = Inc 4) | Firefighter theme + level extension | ✅ built · route test passes · manual ⏳ |
| `ui/hud.gd` | title→FIREFIGHTER RESCUE; progress denominator data-driven from `level.finish`; themed text | Readable presentation | ✅ built |
| `tests/route_driver.gd` | rewritten: 4-phase route (climb → dog ledge → jump back → window) | Updated route fixture | ✅ built |
| `tests/test_game.gd` | route assertions updated; added `extension-climb-and-detour` + `flame-clearance-positive` | Regression + new-section check | ✅ built |
| `tests/test_keyboard.gd` | Likely unchanged | Preserve control checks | 🔲 planned |

---

## Change log (chronological)

### 2026-09-22 · Entry 0 — Baseline verified (no code changed)
- **What:** Confirmed the starter runs and passes before touching anything.
- **Evidence:** `test_game.gd` → 25/25 PASS; `test_keyboard.gd` → 9/9 PASS
  (34 total). Played to "Course complete." in the editor. Engine 4.7.2.stable.
- **Why it matters:** establishes the baseline every later change is compared to.
- **Human/AI:** Human ran the game; AI ran the headless checks and read the code.

### 2026-09-22 · Entry 1 — `godot/project.godot` reformatted by the editor (to revert)
- **What:** Opening the project in the Godot editor auto-rewrote `project.godot`
  (removed the custom header comment, dropped `physics_ticks_per_second=60` and
  `stretch/aspect="keep"` because they equal Godot's defaults).
- **Effect:** functionally identical (those values are the engine defaults), but
  it's a noisy diff we didn't intend.
- **Plan:** `git checkout godot/project.godot` to restore the clean original
  before committing real work. **Status: 🔲 to revert.**
- **Human/AI:** AI identified the diff; decision to revert pending human OK.

### 2026-09-22 · Entry 2 — Character (chick) designed, NOT yet coded
- **What:** Designed Iteration 1 of the chick character (round yellow body, beak,
  head tuft, wing, eye, legs). Wrote predictions in `CHANGE-BRIEF.md` and the full
  design + proposed `_draw()` in `CHARACTER-DESIGN.md` Part 6.
- **Files that will change when applied:** only `features/player/player.gd`
  `_draw()` — a **pure repaint** (collider/movement/tuning untouched).
- **Verification plan:** re-run all 34 checks (expect identical numbers, proving
  physics unchanged) + human playtest facing left/right, standing, jumping.
- **Status: 🔲 planned** (awaiting go-ahead / any design tweaks).
- **Human/AI:** AI proposed the design and code; human owns the concept and will
  approve/tweak before it's applied.

### 2026-09-22 · Entry 3 — Theme = "Postman's Rush"; character → postman; finish → postbox
- **What:** Adopted the "Postman's Rush" theme (deliver mail along a route to a
  post office). Character switched from the chick (Entry 2) to a **postman with a
  mailbag**; the finish flag will be re-skinned as a **postbox**.
- **Files affected when applied:** `player.gd` `_draw()` (postman) now; later
  `session.gd` `_draw()` (goal → postbox) + `first_steps.json` (extended route).
- **Provenance:** character is **original geometric drawing** inspired by the
  generic cartoon-postman concept; stock images viewed only as reference,
  **NOT imported** (to be logged in `SOURCES.md`).
- **Status: 🔲 planned** — postman `_draw()` code is ready to apply on approval.
- **Human/AI:** Human chose the theme, character, and postbox finish; AI
  translated it into geometric shapes/code.

### 2026-09-22 · Entry 4 — Applied postman `_draw()` + ran system tests
- **What:** Replaced `player.gd` `_draw()` (lines 70-80) with the postman drawing
  (legs, uniform + belt, chest strap, mailbag, head, cap + brim + badge, eye).
  **Pure repaint** — `_ready()` collider, `_physics_process()`, and `tuning.gd`
  untouched.
- **System tests (automated):** `test_game.gd` 25/25, `test_keyboard.gd` 9/9
  (**34/34**). Every physics-identity number matches the baseline (jump rise
  56.0747 px; coyote/buffer boundaries; spike death; 20 retries; 325-tick route).
  → Full detail in **TEST-REPORT.md**.
- **Manual tests (visual):** ⏳ pending human playtest (facing L/R, standing,
  jumping) — see TEST-REPORT.md manual section.
- **Human/AI:** AI wrote the drawing code and ran the automated suites; human owns
  the concept and does the visual playtest.

### 2026-09-22 · Entry 5 — Finish flag → red postbox (`session.gd`, theming)
- **What:** Replaced the finish flag drawing in `session.gd` `_draw()` with a red
  **postbox** (domed top, mail slot, gold collection band, base). Drawn from
  `level.finish` (**data-driven**) so it aligns with the goal collision box and
  will follow the finish when it's relocated during the level extension — fixing
  one of the hard-coded finish-Y coordinates.
- **Scope note:** cosmetic re-skin at the CURRENT finish location; the structural
  level extension (new landings, moving the finish) is separate and still needs
  its predictions written first.
- **Tests:** `test_game.gd` 25/25 (drawing-only change; `complete-real-route`
  still reaches COMPLETE → goal collision unaffected).
- **Human/AI:** Human requested the postbox; AI implemented the geometric drawing.

### 2026-09-22 · Entry 6 — Manual playtest passed; milestone committed
- **Manual playtest (human):** Player confirmed all visual/feel checks pass
  (postman facing L/R, standing, jumping; postbox finish; controls). Recorded in
  TEST-REPORT.md — _"all good, manually tested everything works."_
- **Housekeeping:** reverted the editor-reformatted `project.godot` to the
  original (the reformat only stripped default-valued settings — functionally
  identical noise), so the commit shows only intentional changes.
- **Committed as:** "Replace character with postman and finish flag with postbox"
  (branch `working` → PR to `main`). Transient `evidence/*.json` test outputs left
  untracked for now; to be curated for the final submission.
- **Human/AI:** Human playtested and approved; AI updated docs, reverted the
  config, and prepared the commit/PR.

### 2026-09-23 · Entry 7 — PIVOT to "Firefighter Rescue" + increments 1–2
- **Pivot:** theme changed Postman's Rush → **Firefighter Rescue** (CHANGE-BRIEF §0). The postman milestone stays on `main` (8672fe3) as honest history.
- **Increment 1 — Firefighter (Iteration 3):** `player.gd` `_draw()` → red helmet (dome + brim + back beavertail + gold badge), dark turnout coat + reflective stripe, air tank, orange rescue duffel, boots. Added `rescued` var (drives heads-in-bag; reset on retry). Pure repaint.
- **Increment 2 — Flames:** `session.gd` spike drawing → **data-driven flames** (orange + yellow tongues, uses hazard Y so flames on raised platforms draw correctly). Collision unchanged.
- **Tests:** 34/34 (`test_game.gd` 25/25, `test_keyboard.gd` 9/9); jump rise 56.0747, spike collision, 325-tick route all identical → proven pure repaints.
- **Manual:** ⏳ pending human visual check (firefighter L/R + jump; flames read as fire).
- **Human/AI:** Human wrote the firefighter spec + chose the theme; AI implemented the drawings and ran the suites.

### 2026-09-23 · Entry 8 — Increment 3: extended Level 1 (climb + dog detour + window)
- **Level data (`first_steps.json`):** width 960→1900; kept the original 5 solids (approach preserved); added climb platforms P1–P5 + a dog ledge PD (relocated to **open sky**, right of P5, per review); finish → **window** `[1560,112,26,44]`; added `survivors` (person @P2, dog @PD).
- **`session.gd`:** widened background/grid/mountains (data-driven to `level.width`); postbox → **window** (data-driven); drew survivors; re-themed labels + death text. **Finish now requires `is_on_floor()`** so the climb arc can't trip it mid-air (documented addition; still ungated — rescue gate is Inc 4).
- **`hud.gd`:** FIREFIGHTER RESCUE / FIRST ALARM; progress denominator data-driven; themed menu/complete text.
- **`route_driver.gd`:** 4-phase route (climb → dog ledge → jump back → window). **`test_game.gd`:** added `extension-climb-and-detour` + `flame-clearance-positive`; tick cap 900→2000.
- **Reviewer gate — MET (real engine):** route reaches the window with **0 deaths** and **executes the detour** (drop → dog → return → finish, 758 ticks). Real flame clearances: **P2→P3 13.4px, P3→P4 12.1px** (fixed from a 0.07px graze by lowering both flame rects). **36/36 automated pass.**
- **Manual:** ⏳ pending human playtest (route, failure/recovery, detour discoverability, readability).
- **Human/AI:** Reviewer set the gate + caught the mid-jump window trigger and the tight flame margins; AI built the level/draws/route/tests, traced the real physics, and applied the fixes.

### 2026-09-23 · Entry 9 — Increment 4: rescue + gated exit + fire-on-platforms + clarity
- **Fire (revision):** removed the toothless gap flames; placed flames as jump-over obstacles **on** P1/P3/P4 (+ ground). Real jump clearances 28 / 24 / 32 px (route test).
- **Rescue (touch):** survivor `Area2D`s (person @P2, dog @detour ledge) in `session.gd`; overlapping rescues them (removed, counter++, `player.rescued` drives the head-in-bag), resets on retry.
- **Gated exit:** "FIRE ESCAPE" completes only when BOTH rescued AND reached on foot; LOCKED (lock icon + "Rescue everyone first!" cue) vs UNLOCKED ("JUMP OUT →"). State machine unchanged.
- **Clarity (`hud.gd` + `session.gd`):** persistent HUD objective (PERSON/DOG → check), HELP! bubbles over un-rescued survivors, themed intro + finish counts.
- **Tests:** route grabs both survivors + reaches exit (0 deaths, 750 ticks); added `exit-locked-without-rescues`; flame clearance measured on the platform flames. **37/37 pass.**
- **Manual:** ⏳ pending human playtest.
- **Human/AI:** reviewer approved touch-to-rescue + reach-unlocked-exit; AI built it, fixed a 5.4px flame graze → 24–32px, and verified gating.

### 2026-09-23 · Entry 10 — Increment 4, Iteration 2 (clarity/feedback fixes)
- **Playtest findings:** rescue had no visible payoff (1.3px bag head, no SAVED! popup); flames didn't read as lethal.
- **Fixes:** `player.gd` — big **typed bag heads** (person + dog w/ ears, grow per rescue) via new `bag_types`. `session.gd` — **"SAVED!" popup** (rises + fades) on rescue; **bolder/vivid flames** (VISUAL only — collision rects unchanged). `test_game.gd` — added `survivor-removed-on-rescue`.
- **Verified:** **38/38** (37 + 1 new; no weakened assertions). Flame clearances held at **28/24/32px** (collision untouched despite bigger visual). Rescued survivor confirmed removed (monitoring off).
- **Manual:** ⏳ re-playtest pending.
- **Human/AI:** reviewer flagged the no-feedback + unreadable-fire issues; AI implemented the visible payoff, popup, bolder flames, and the removal check.

### 2026-09-23 · Entry 11 — Increment 4, Iteration 3 (lethality + stale-redraw + hidden-label)
- **Root causes:** flame rects sat at the surface (inside platforms) so they didn't kill walking; `session._draw()` was only queued at startup so dynamic level visuals never refreshed; the "02" label sat behind a platform.
- **Fixes:** raised the 3 climb flame rects to stick up (P1 y268 / P3 y196 / P4 y160); added `queue_redraw()` to `session._physics_process` (level refreshes each frame → survivors vanish, SAVED! animates, exit unlocks); moved the "02 / CLIMB & RESCUE" label to open air.
- **Tests:** added `walk-into-flame-P1/P3/P4` (assert DYING) — flames now lethal on touch. Route still completes (0 deaths, both rescued); clearances to taller flames P1 14 / P3 10 / P4 18px. **41/41, none weakened.**
- **Visual (human) to verify:** flames kill on touch (also now tested), rescued survivors vanish, SAVED! shows, exit unlocks.
- **Human/AI:** reviewer found the bugs in playtest; AI diagnosed the redraw + rect-placement root causes, fixed, and added lethality tests.

### 2026-09-23 · Entry 12 — Increment 5: countdown timer
- **Data:** `time_limit: 30` in `first_steps.json` (per-level; tuned from 50 → 30 after Sreeja's playtest — she finished under 35 s every run; see FRICTIONAL cycle #4).
- **`session.gd`:** timeout fails the attempt (`elapsed >= time_limit` → fatal, reason "Out of time!"); resets on retry (elapsed already zeroed). Fire/fall/time death reasons prioritized. State machine unchanged (added fail reason only); timer freezes when paused.
- **`hud.gd`:** timer now counts **DOWN** (TIME remaining), turns **red under 10s**.
- **Tests:** added `route-beats-timer` (12.55/50s), `timer-expiry-fails` (DYING + "Out of time!"), `timer-resets-on-retry`; reordered so the timer checks don't pollute `replay-idempotent`. **44/44**, none weakened.
- **Manual:** ⏳ pending playtest.
- **Human/AI:** user requested Inc 5; AI implemented + tested. **Completes the core game (increments 1–5).**

### 2026-09-24 · Entry 13 — Level redesign: two burning buildings (documented; building)
- **Design:** approach → Building 1 (person's window) → descent to B1's wide base → burning street (ground-level gap + fire, one jump) → Building 2 (dog's window) → B2 rooftop gated exit. Reuses all mechanics; re-layout + re-draw only.
- **Files:** `first_steps.json` (new solids/hazards/survivors/finish/`buildings`/width 2200); `session.gd` (two facades drawn behind the data-driven ledges + rescue windows + burning street + label reposition; exit repositions via `finish`); `route_driver.gd` (simplify to linear marks); `test_game.gd` (reposition checks; replace `extension-climb-and-detour` with "reached B2 roof + both rescued").
- **Predicted failure cases:** (1) descent drops into the street (mitigated: wide B1 base); (2) a platform flame non-lethal/non-jumpable (checked via `walk-into-flame` + real clearance). See CHANGE-BRIEF two-building revision.
- **Status:** ✅ built + verified — **44/44**; route 0 deaths reaches the B2 roof with both rescued (~12.7 s); flame clearances B1-L1/B2-L1/B2-L2 = 10 px, street 5.8 px; all `walk-into-flame` lethal; descent lands on B1's base; gating at the roof. First flame pass grazed (−3.5 px) → widened window ledges + earlier takeoffs. Human playtest pending (⚠️ 30 s timer may be tight on this longer level).
- **Human/AI:** Sreeja approved the two-building design + coords; AI builds + verifies on the real engine.

### 2026-09-24 · Entry 14 — New mechanic: the hose (documented + proposed)
- **Mechanic:** a large blocking fire at the person's window; lethal + blocks the rescue until put out. New input **W = "water"** (added to the input map; existing bindings untouched). Tap W within ~50 px → ~4 s water → fire gone. Prompt when near; resets on retry; timer 30 → 35 s.
- **Files (when built):** `first_steps.json` (`blocking_fire` + `time_limit` 35); `session.gd` (build the blocking-fire Area2D, track `fire_active`/`extinguish_ticks`, detect W, gate the rescue on not-fatal, draw fire/water/prompt, reset on retry); `_setup_input` (+ `"water": [KEY_W]`); `player.gd` (test hook `test_water_pressed`); `route_driver.gd` (hose before rescuing the person); `test_game.gd` (5 new checks).
- **Predicted failure cases:** (a) rescue without extinguishing; (b) extinguish doesn't reset on retry — see CHANGE-BRIEF hose revision.
- **Status:** ✅ built + verified — **50/50** (6 hose checks). Route 0 deaths runs approach → B1 → **hose** → walk right → rescue person → descent → street → B2 → dog → roof (~17.4 s). **Layout runway (1175–1250) → fire (1250–1306) → visible person (1335)** on one widened ledge; ~40 px landing runway left of the fire (safe, no slide-in); B2 shifted +60 to keep street/climb reachability. **Progressive extinguish:** W-in-range → fire full → **half height at t=2 s** → **gone at t=4 s**; kill-zone shrinks from the top with the flames (`fire_height()` drives draw + collision) but the **base stays lethal + blocking until fully out** (`half-size-fire-still-kills`: step into the half fire at t=2 s → DYING, person not rescued); water lingers ~1 s; existing controls untouched. **Timer 40 s** (human-playtested fair; route ~17.4 s beats it; `route-beats-timer` passes). Resets on retry (fire full, timer 40 s). Human playtest of the shrink visual + fair-timing pending.
- **Human/AI:** Sreeja specified the hose mechanic; AI documents + proposes exact values for review.

### 2026-09-24 · Entry 15 — Readability + figure visual pass (drawing only)
- **Files:** `godot/game/session.gd` (`_draw`: lighter facades, dark-opening rescue windows, redrawn person/dog, bigger HELP! bubbles + tails, lifted hose prompt), `godot/features/player/player.gd` (`_draw`: pale rim light), `godot/ui/hud.gd` (added `W: hose` to the controls bar).
- **What:** facades → **very light brown** (kept fire glow; facade windows halved in count + recoloured to beige/cream with brown frames, so the only orange is the real fire) for contrast; **person** redrawn as a clear waving human (head/face, torso, raised arm, legs), **dog** as ears/snout/tail/four legs — bright fills + dark outlines; rescue windows → dark openings (not solid boxes) so figures pop and don't share the window colour; HELP! bubbles enlarged with pointer tails; firefighter rim light for dark surfaces; hose prompt lifted + `W: hose` added to the controls bar; intro world-labels ("01 / TO THE BUILDINGS" + objective) hidden while the menu/pause/complete card is up so they no longer overflow behind it.
- **Constraint:** purely visual — collision, triggers, tuning, controls, and survivor/exit positions untouched.
- **Verify:** suite **50/50** (`fixed-jump` 56.07 px unchanged); confirmed in `evidence/screens/read-b1-person.png` + `read-b2-dog.png` — firefighter, clearly-a-person + clearly-a-dog, HELP! signs, fire all read cleanly on the buildings.
- **Status:** ✅ built + screenshot-verified. Human eyeball of the live look pending.

---

## Supporting docs (not code)
- `CHANGE-BRIEF.md` — pre-implementation predictions (Step 1 deliverable).
- `CHARACTER-DESIGN.md` — character learning notes + Iteration 1 proposal.
- `WALKER-JUMPMAN-NOTES.md` — whole-project map.
- _(Later: `TEST-REPORT.md`, `FRICTIONAL.md`, `SOURCES.md`, `SUBMISSION.md`.)_
