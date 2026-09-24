# CHANGE-BRIEF — walker-jumpman-joe

> **Predictions written BEFORE implementation**, per Assignment 1. Honest, dated
> record: predictions are **retained**; changes go in the **Revisions log** at the
> bottom (never rewritten to look correct).

- **Assignment:** Assignment 1 — Extend Walker Jumpman (CSYE 7270, Fall 2026)
- **Student:** Sreeja Pulaparty (pulaparty.s@northeastern.edu)
- **Project:** walker-jumpman-joe · **Starter:** nikbearbrown/walker-jumpman
- **Engine:** Godot 4.7.2.stable.official.ed1daf0bf · macOS
- **Baseline:** starter 9387542; postman milestone 8672fe3 (on `main`)
- **Updated:** 2026-09-23

---

## 0. Theme — "Firefighter Rescue" (supersedes "Postman's Rush")

**Pitch:** You're a firefighter racing a countdown to climb a burning building,
rescue trapped survivors into your rescue bag, and jump out the window before the
fire wins.

**What this assignment builds (Tier 1 = increments 1–5, a complete game):**
firefighter character, flames (reskinned spikes), an extended Level 1 (reskinned
ground approach → climb with survivors → window finish), rescue-into-bag + a gated
window, and a countdown timer.

**Someday / stretch (documented, built only if time allows):** Level 2 + the
multi-level machinery (Tier 3), true-vertical camera (Tier 2). **Out of scope:**
lever, water/hose, follow-AI companions.

**Pivot note:** we first shipped a **postman** character + postbox finish (commit
8672fe3, on `main`). On 2026-09-23 we pivoted to the firefighter theme because it
gives the level a built-in decision and a natural reason to move the finish. The
postman remains in git history; the character iteration history is preserved.

---

## 1. Character — Iteration 3: Firefighter (predicted before coding)

**Concept:** replace the postman with a **firefighter** — red helmet (dome + brim
+ back beavertail + gold badge), dark turnout coat with a reflective yellow stripe,
an air tank high on the back, an orange **rescue duffel** on the back hip, boots.

**Distinguishing features vs. starter:** the helmet (top silhouette), the rescue
bag + air tank (back silhouette), and the dark-coat/yellow-stripe identity.

**Rescued indicator:** small heads poke out of the bag as survivors are rescued
(driven by a `rescued` count set by the rescue mechanic; 0 shows none).

**Provenance:** original geometric drawing; no imported art.

**Stays unchanged:** pure repaint of `player.gd` `_draw()`; the 18×28 collider,
movement, and `tuning.gd` untouched. **Prediction:** all 34 automated checks pass
with baseline-identical numbers.

**Failure cases + checks:** (1) *facing-flip* — helmet beavertail/tank/bag could
land on the wrong side facing left → play L/R and confirm they trail behind.
(2) *visual/collision mismatch* — helmet/bag pokes could mislead → run the 34
tests (collider proof) + confirm the body fills the box.

---

## 2. Fire hazard — flames (predicted)

Redraw the spike hazard in `session.gd` `_draw()` as **flames** (orange + yellow
tongues), made **data-driven** (uses the hazard's Y, not hard-coded 320) so flames
placed on raised platforms draw correctly. **Collision unchanged:** touch = die +
retry. **Check:** run `test_game.gd` (`actual-spike-collision` still passes).

---

## 3. Level extension — the climb + window finish (predicted)

- **Ground floor** = the original First Steps route, reskinned as the building
  approach (cracked floor/debris, the first flame) → keeps the original route usable.
- **Climb** = new section: **2+ new landings requiring jumps**, going
  **up-and-to-the-right** (stays on the existing X-only camera; no vertical camera).
- **Decision:** a risky short hop **through a flame** (fast) vs. a longer safe
  detour to reach the dog.
- **Survivors:** a person on the main upper path; a dog slightly off-path (the
  detour reward).
- **Finish:** a **window** at the top (replaces the postbox), which completes
  **only when both survivors are rescued**.
- Fix hard-coded draw coords that won't follow the JSON: background rectangle,
  grid lines, zone labels, and the HUD progress denominator.

**Failure cases + checks:** (1) a new platform is **unreachable** with the fixed
jump (~56 px rise / spacing) → playtest each jump + update the route test.
(2) a **flame/label drawn at the wrong Y** vs. its collision on a raised platform →
verify drawing matches the hazard/goal data.

---

## 4. Rescue mechanic + gated window (predicted)

_Finalized for Increment 4 (predicted before the code):_

- **Fire placement (revision):** flames become **stick-up obstacles on the platforms**
  (reskinned like the ground spike) near each platform's right edge, so the gap-jump
  takes off *before* the fire and a player who walks into it burns — fire now shapes
  movement on each floor. Toothless gap-flames removed. Every flame stays jumpable
  with margin (verified by re-running the route test).
- **Rescue (touch to rescue):** each survivor (person, dog) = an `Area2D` at its
  position. Overlapping it rescues them: remove from the world, increment a rescued
  count, set `player.rescued` (drives the head-in-bag drawing), and the "HELP!"
  bubble over them disappears. Survivors + count **reset on retry**.
- **Gated exit (window → "FIRE ESCAPE"):** completes only when **both** survivors are
  rescued **and** the player reaches it on foot. Locked (not all saved): drawn darker
  with a lock; touching it flashes "Rescue everyone first!". Unlocked (both saved):
  brightened with a "JUMP OUT →" prompt. **No precise mid-air trigger — reaching the
  unlocked exit = win.** State machine unchanged; only the *condition* to reach
  COMPLETE gains "both rescued."
- **Clarity layer:** persistent HUD objective (person/dog, filling to a check as
  saved); themed intro line; finish screen shows saved counts + time.

**Failure cases + checks:** (1) *rescues don't reset on retry* → die after saving one,
retry, confirm count = 0 and survivors reappear. (2) *exit completes without both* →
reach it at 1/2, confirm it does NOT finish + the locked cue shows (add an automated
gating check). (3) *a platform flame grazes/blocks the route* → re-run the route test,
report real clearances, fix geometry (not the test).

---

## 5. Countdown timer (predicted)

_Finalized for Increment 5 (predicted before the code):_

- **`time_limit` per level in the JSON** (Level 1 = **50 s** — the scripted route
  finishes in ~12.5 s, leaving comfortable human margin). The HUD timer counts
  **down** from it and turns **red under 10 s**.
- Reaching **0 = attempt fails = retry** (death reason "Out of time!"; the whole
  attempt resets and the timer returns to full — `elapsed` already resets on retry).
- An **added fail reason only** — controls, tuning, collider, pause (timer freezes
  when paused), and the completion flow are unchanged.

**Failure cases + checks:** (1) *tuned too tight* → the auto route can't finish →
`route-beats-timer` asserts the route completes with time to spare; (2) *timer
doesn't reset on retry* → `timer-resets-on-retry` after a timeout; (3) *timeout
doesn't fail* → `timer-expiry-fails` asserts DYING + "Out of time!".

---

## What must NOT change
Movement/jump tuning (`tuning.gd`), the 18×28 collider, and the pause/retry/
completion **flow**. The gated window and the timer are documented **additions**
(a new win *condition* and a new fail *reason*), not changes to the existing feel.

---

## Level redesign revision — two burning buildings (2026-09-24, predicted before rebuild)

_Added revision. The original single-climb level prediction (§3) is **retained** above,
not rewritten._

**New design:** approach (original ground, kept) → **Building 1** (climb to the
**person's window**) → **descent** (drop back to B1's wide base) → **burning street**
(a ground-level gap with fire, crossed in one jump — no mid-air platform) → **Building 2**
(climb to the **dog's window**) → **Building 2 rooftop** = the gated exit ("JUMP OUT" once
both are rescued). **Reuses every mechanic unchanged** (touch-to-rescue, gated exit,
stick-up lethal fire, countdown timer) — a re-layout + re-draw, no new systems. Coordinates
and the reachability table were posted and approved before this rebuild.

**Stays unchanged:** movement/jump tuning (`tuning.gd`), the 18×28 collider, and the
pause/retry/completion flow. Two decorative building facades are drawn *behind* the ledges
(no collision); the ledges/windows/exit are drawn from the level data
(`solids`/`survivors`/`finish`) so the visuals line up with the physics by construction.

**Predicted failure cases + how I'll check them:**
1. **The descent drop lands in the burning street** — falling off the person's window
   drifts ~65 px right during the fall. → B1's base is made **wide** (x1000–1400) to catch
   it; checked by `complete-real-route` (0 deaths through the descent) and by confirming the
   player is grounded on B1-ground after the drop, not falling into the street.
2. **A platform flame is non-lethal or non-jumpable** (placed inside the platform, or too
   tall/tight). → `walk-into-flame-*` must assert **DYING** (kills on walk-in) and
   `flame-clearance-positive` must report a **positive real-engine margin** on the route —
   the same build-and-measure gate as the last level.
3. **The street jump is unreachable / a mid-air building leap.** → the table keeps it a
   **flat ~85 px** single jump (≤ ~106 max); `complete-real-route` crosses it with 0 deaths.

## Revisions log
- **2026-09-22** — Postman character + postbox finish predicted, built, tested
  (34/34 + human playtest), shipped to `main` (8672fe3). _(Full postman predictions
  are in git history at 8672fe3.)_
- **2026-09-23** — **Pivoted to "Firefighter Rescue."** Character → firefighter
  (Iteration 3), spikes → flames, level → burning-building climb with rescue + gated
  window + countdown timer. Reasons: a built-in player decision and a natural moved
  finish. Postman retained in history; not deleted. This brief rewritten for the new
  direction *before* the firefighter code is written.
- **2026-09-23** — Inc-3 playtest → fire placement + window-gating revisions planned;
  see TEST-REPORT / FRICTIONAL. (Predictions above unchanged; §4 to be refined once decided.)
- **2026-09-23** — §4 refined with the finalized Inc-4 design (touch-to-rescue,
  reach-unlocked-exit=win, fire-on-platforms, clarity) *before* the code; then Inc 4
  built + tested (37/37, both rescued, gating verified). See TEST-REPORT / FRICTIONAL.
- **2026-09-23** — §5 finalized (50 s limit, HUD counts down + red under 10 s, "Out of
  time!" fail) *before* coding Increment 5.
- **2026-09-24** — Inc-5 playtest → `time_limit` **50 → 30 s** (finished under 35 s every
  run; wanted real pressure). §5's 50 s prediction retained; the route still beats the timer.
  See FRICTIONAL cycle #4.
- **2026-09-24** — Level redesigned to **two burning buildings** (person in B1, dog in B2,
  a burning street between, B2 rooftop = gated exit). Recorded as the revision section above;
  §3's single-climb prediction retained. Build + runtime verification next.
