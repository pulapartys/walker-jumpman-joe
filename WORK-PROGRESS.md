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
| `features/player/player.gd` | Rewrite `_draw()` → **postman** character (keep collider in `_ready()`) | New visual identity | ✅ applied · system + manual tests pass |
| `features/player/tuning.gd` | — | Preserve movement/jump feel | ⛔ must not change |
| `levels/first_steps.json` | Add platforms/landings, widen level, **move finish** | Extend playable level (≥2 new landings) | 🔲 planned |
| `game/session.gd` | Fix hard-coded draw coords (grid/background extent, hazard Y); re-skin finish → **postbox** ✅; theme labels (mail/route); check camera bounds | Keep visuals matched to physics on the wider level | 🔧 in progress · postbox done · rest pending |
| `ui/hud.gd` | Verify/adjust progress bar for new width | Readable presentation | 🔲 planned |
| `tests/route_driver.gd` | Update jump marks for the extended route | Updated route fixture | 🔲 planned |
| `tests/test_game.gd` | Update finish/route assertions; add a check for the extension | Regression + new-section check | 🔲 planned |
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

---

## Supporting docs (not code)
- `CHANGE-BRIEF.md` — pre-implementation predictions (Step 1 deliverable).
- `CHARACTER-DESIGN.md` — character learning notes + Iteration 1 proposal.
- `WALKER-JUMPMAN-NOTES.md` — whole-project map.
- _(Later: `TEST-REPORT.md`, `FRICTIONAL.md`, `SOURCES.md`, `SUBMISSION.md`.)_
