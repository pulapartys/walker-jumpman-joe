# CHANGE-BRIEF — walker-jumpman-joe

> **Predictions written BEFORE implementation**, per Assignment 1 (Extend Walker
> Jumpman). This is a dated, honest record. Original predictions are **retained**.
> Later changes go in the **Revisions log** at the bottom — they are NOT edited
> into the predictions above — so the record stays honest even where a prediction
> turns out wrong.

- **Assignment:** Assignment 1 — Extend Walker Jumpman (CSYE 7270, Fall 2026)
- **Student:** Sreeja Pulaparty (pulaparty.s@northeastern.edu)
- **Project:** walker-jumpman-joe
- **Starter credited:** nikbearbrown/walker-jumpman ("First Steps" slice)
- **Engine:** Godot 4.7.2.stable.official.ed1daf0bf · macOS
- **Baseline source revision:** 9387542 (branch: `working`)
- **Brief created:** 2026-09-22

---

## 0. Theme / game concept — "Postman's Rush"

A postman runs a delivery route, crossing streets/rooftops safely and reaching
the **post office / postbox** at the end. Non-combat; the challenge is "can I
complete the route safely?" — which keeps the starter's control/retry feel.

**Full vision (someday, NOT all implemented — like the starter's own GDD):**
mail pickups (letters/packages/special), a delivery count, optional stars, and
multiple themed levels (Neighborhood → Downtown → Stormy → Christmas Rush).

**What this assignment actually implements (a focused slice):** re-theme the
character as a postman, extend the existing level into a short delivery route with
≥2 new jump landings and a route decision, re-skin the hazard as a construction
hazard, and relocate the finish to a **postbox**. (Optional stretch, decided at
the level phase: a few mail pickups + a delivery count on the finish screen.)

---

## 1. Character redesign — Iteration 2: Postman (predicted before coding)

> Iteration 1 was a chick (idea only, never coded); superseded by this postman
> when we adopted the Postman's Rush theme. Full chick record: CHARACTER-DESIGN.md
> Part 6. See the change in the Revisions log.

### Concept
Replace the starter's "guy in a box" with a **postman / mail carrier**: a blue
uniform, a peaked cap, and a brown mailbag — a runner whose shape clearly differs
from the original at a glance and matches the game's theme.

### Provenance
**Original geometric drawing** inspired by the generic cartoon-postman concept
(blue uniform + peaked cap + satchel). Stock images were viewed only as visual
reference and are **NOT imported or copied**; this will be documented in
`SOURCES.md`.

### Distinguishing visual features (vs. the starter)
- **New silhouette (the key change):** a **cap crown + forward brim** (top/front)
  and a **mailbag** on the back hip (back) — all break the original's plain
  rectangular outline.
- **New identity:** postal-blue uniform + navy cap/trousers + brown bag + gold
  cap badge, vs. the starter's plain blue box + orange sash.
- **Readable features:** shirt/trousers with a belt, a strap across the chest, a
  skin-tone face with an eye, and walking legs.
- **Facing cue:** brim + eye lead the direction of travel; mailbag + strap trail
  behind — so left/right is obvious.

### What must remain UNCHANGED (and how I ensure it)
This step is a **pure repaint** — it edits only `player.gd` `_draw()`.
- **Controls** — untouched (`session.gd` input map not edited).
- **Movement / jump tuning** — untouched (`features/player/tuning.gd` not edited:
  speed 160, jump_velocity −320, gravity 960, coyote 6, buffer 6).
- **Collision behavior** — untouched: the collider stays **18×28 at offset
  (0,−14)**; `player.gd` `_ready()` is not edited.
- **Retry / pause / completion** — untouched (`session.gd` state machine not edited).
- **Prediction:** all **34 automated checks** (`test_game.gd` + `test_keyboard.gd`)
  still pass with **identical numbers** (e.g., jump rise 56.07 px), because no
  physics-relevant code changes.

_No justified departure from the collider or behavior is planned for this step._

### Predicted failure cases + how I'll check them
1. **Facing-flip error (left/right).** Mirrored elements (brim, mailbag, strap,
   eye) could land on the wrong side or point the wrong way when facing left.
   - *Check:* play, hold **left** then **right**, and confirm the brim + eye lead
     while the bag + strap trail. Optionally capture one facing-left and one
     facing-right frame.
2. **Visual/collision mismatch.** The cap/brim (top/front) and mailbag (back) poke
   outside the 18×28 collider, so the postman could look like it should collide
   sooner/later than it does, or the body might not fill the box.
   - *Check:* (a) run `test_game.gd` + `test_keyboard.gd` and confirm all pass
     **unchanged** (proves the collider is identical); (b) confirm the body fills
     the box and feet sit on the floor line; (c) shrink the pokes if misleading.
3. **Readability / clutter at thumbnail size.** The postman has more parts than
   the starter box; it could read as a blob at ~18×28 px.
   - *Check:* play and confirm it reads as a postman; if possible, ask another
     person to identify it. Simplify features if unclear.

### Success criteria
Recognizable as a postman at thumbnail size; reads correctly facing left, facing
right, standing, and jumping; body aligned with the collider; **all 34 automated
checks pass unchanged**.

> Full design reasoning and the proposed `_draw()` code: see
> [CHARACTER-DESIGN.md](CHARACTER-DESIGN.md) Part 7 (Iteration 2: Postman).

---

## 2. Level extension — (to be written BEFORE building the level)

Direction locked (details/predictions to be filled in before any level code):
- **Theme:** delivery route (Postman's Rush).
- **Finish:** relocate to a **postbox / post office** at the far right (re-skin the
  goal drawing in `session.gd`).
- **New section:** ≥2 new jump landings (rooftops/sidewalk platforms + gaps).
- **Decision/challenge:** e.g., a risky rooftop shortcut vs. a safer street route
  that rejoin before the postbox.
- **Hazard:** re-skin the spike as a **construction hazard**.
- **Optional stretch:** a few mail pickups + a "📬 N delivered" line on the finish
  screen (scope decision A vs. B pending).
- Preserve a usable route through the original section + all failure/retry behavior.

_Full level predictions (with ≥2 failure cases) go here before we build._

---

## Revisions log

_Add dated entries as predictions are tested or change. Do **not** edit the
predictions above._

- **2026-09-22** — Brief created. Character Iteration 1 = 🐤 chick (idea only).
- **2026-09-22** — Adopted the **"Postman's Rush"** theme. Character switched from
  Iteration 1 (chick) → **Iteration 2 (postman)** to match the theme; finish will
  become a **postbox**. The chick was never written to code, so this is a
  pre-implementation plan change, not a post-hoc rewrite. Full chick record kept
  in CHARACTER-DESIGN.md Part 6.
- **2026-09-22** — Character prediction **TESTED**: postman `_draw()` applied; all
  **34 automated checks passed** with baseline-identical numbers (jump rise
  56.0747 px, coyote/buffer, spike, retries, 325-tick route) — confirming the
  "pure repaint / physics unchanged" prediction. **Manual visual check** (facing
  L/R, standing, jumping) still ⏳ pending. Full results: **TEST-REPORT.md**.
  (Predictions above unchanged.)
- **2026-09-22** — Implemented the **postbox finish** drawing early (theming):
  `session.gd` finish flag → red postbox, drawn **data-driven** from `level.finish`.
  This is a cosmetic re-skin at the current finish spot; the structural level
  extension (new landings, relocating the finish, the route decision) still gets
  its full predictions written in §2 **before** it is built. `test_game.gd` 25/25.
- **2026-09-22** — **Manual playtest passed** (human): postman reads correctly
  facing L/R, standing, and jumping; postbox reads correctly at the finish;
  controls unchanged. Player: _"all good, manually tested everything works."_
  Recorded in TEST-REPORT.md. Milestone committed to branch `working`.
