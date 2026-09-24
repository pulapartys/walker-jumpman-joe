# FRICTIONAL — honest log (walker-jumpman-joe)

> An honest record of what was actually tried, what went wrong, what I checked or
> changed in response, and who did what (human vs. AI). Retrospective notes are
> labeled. Nothing here is invented; unsuccessful attempts are kept.

- **Assignment:** Assignment 1 — Extend Walker Jumpman (CSYE 7270, Fall 2026)
- **Student:** Sreeja Pulaparty (pulaparty.s@northeastern.edu)
- **Engine:** Godot 4.7.2.stable · macOS

---

## 2026-09-23 · Reachability verification friction (Increment 3, before playtest)
- **Tried:** proposed the climb layout with a *hand-computed* jump model and "safe"
  flame clearances (I claimed +11 / +14.7 px), plus a dog pocket tucked under the
  top floor (P5).
- **What went wrong / what the review caught:**
  - The hand model **overestimated early-tick rise** — it used ~10 px at tick 1, but
    the real integration sets `vy = -320` *then* moves, so tick-1 rise is ~5 px.
  - Building and running the **real engine** showed the P3→P4 flame clearance was
    **0.07 px** (a graze), and the window **completed mid-jump** because the P4→P5
    arc passed through it.
  - The dog pocket under P5 was a fiddly "bonk-the-ceiling" return.
- **Checked / changed:** added `flame-clearance-positive` (measures real
  feet-above-flame from the simulation) and `extension-climb-and-detour` checks;
  lowered both flame rects (now 13.4 / 12.1 px); made the finish require
  `is_on_floor()`; relocated the dog ledge to open sky right of P5. Re-ran: **0
  deaths, detour executed, 36/36**.
- **Human/AI:** the reviewer (human) set a *build-and-measure* gate and caught the
  graze / overhang / mid-jump issues; AI traced the real physics, wrote the checks,
  and applied the fixes.
- **Traceable to:** `godot/tests/test_game.gd` (`flame-clearance-positive`,
  `extension-climb-and-detour`), TEST-REPORT.md Increment 3, WORK-PROGRESS Entry 8.

## 2026-09-23 · Inspect-and-revise cycle #1 (playtest)
- **Observed (human playtest):** fire never blocks the path — the flames sit in the
  gaps at take-off level, so every jump clears them; and the window finishes
  without rescuing the dog (gating not built yet).
- **Decided:**
  - **(a)** Relocate flames as stick-up obstacles **on** the climb platforms, so
    the player must jump over fire on each floor (make fire a real obstacle, not
    scenery).
  - **(b)** Build **Increment 4**: gate the window on rescuing both survivors, and
    add the rescue-into-bag counter.
- **Human/AI:** human observed during the playtest; the decision was joint; the
  builder (AI) will implement.
- **Status: RESOLVED (2026-09-23).** Increment 4 built + tested: flames relocated to
  jump-over obstacles **on** the platforms (real clearances 24–32 px — a first
  placement grazed at 5.4 px and was widened), and the exit is now **gated** on
  rescuing both survivors (touch-to-rescue + counter + locked/unlocked exit + a
  clarity HUD/HELP layer). Automated: **37/37**, route grabs both survivors, gating
  verified (`exit-locked-without-rescues`). Human playtest pending. See TEST-REPORT
  Increment 4, WORK-PROGRESS Entry 9.

## 2026-09-23 · Inspect-and-revise cycle #2 (Inc-4 playtest)
- **Observed:** rescuing a survivor has **no visible feedback** — the bag head was
  ~1.3 px and the "SAVED!" popup (in the Inc-4 spec) was never built, so it looks
  like collection failed even though the HUD checkbox flips. And the **platform
  flames don't read as lethal** (too small to signal danger).
- **Decided:** (a) draw the rescued survivors **visibly riding in the bag** (clear
  person head + dog head with ears, growing as you rescue); (b) add the **"SAVED!"
  popup** at the moment of rescue; (c) make **flames bolder/more vivid** so they read
  as hazards — **keeping the collision rects unchanged** so `flame-clearance-positive`
  still holds; (d) verify a rescued survivor is fully removed from the path.
- **Human/AI:** human observed in the playtest; decision joint; builder (AI) implements.
- **Status: RESOLVED (2026-09-23).** Built: big typed bag heads (person + dog w/ ears,
  growing per rescue), a rising/fading "SAVED!" popup at the rescue moment, bolder
  vivid flames (**visual only — collision rects unchanged**, so `flame-clearance-positive`
  held at 28 / 24 / 32 px), and a new `survivor-removed-on-rescue` check (rescued
  survivor stops monitoring + leaves the path). **38/38 automated, no weakened assertions.**

## 2026-09-23 · Inspect-and-revise cycle #3 (Inc-4 playtest)
- **Observed:** platform flames don't kill a walking player; rescued survivors don't
  vanish + the SAVED! popup and fire-escape unlock never render; the "02 / CLIMB &
  RESCUE" label is hidden behind a platform.
- **Root causes:** (1) the flame rects were placed at the platform surface (inside the
  platform body), not sticking up above it; (2) `session._draw()` was only queued at
  `_ready()`, so dynamic level visuals never refreshed (only the HUD redrew each frame).
- **Decided:** raise each platform flame rect by its height (stick up like the ground
  spike); add `queue_redraw()` to `session._physics_process`; move the hidden label; and
  add a "walk-into-flame-kills" test per flame (previous tests only jumped OVER).
- **Human/AI:** human found the visual/lethality bugs in playtest; AI diagnosed the
  redraw + rect-placement root causes and implements the fixes.
- **Status: RESOLVED (2026-09-23).** Raised the 3 climb flame rects to stick up above
  the surface (P1 y268 / P3 y196 / P4 y160) — `walk-into-flame-P1/P3/P4` now assert
  DYING (fire kills a walking player). Added `queue_redraw()` to
  `session._physics_process` so the level's own draw refreshes every frame (rescued
  survivors vanish, SAVED! animates, exit unlocks). Moved the hidden "02" label. Route
  still completes (0 deaths, both rescued); real jump clearances to the taller flames:
  P1 14.1 / P3 10.1 / P4 17.8 px. **41/41 automated, no weakened assertions.** Rendering
  itself is human-verified (headless tests can't see pixels).
