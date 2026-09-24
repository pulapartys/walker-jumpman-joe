# SUBMISSION — Assignment 1: Extend Walker Jumpman

> Canvas submission note. Canvas, GitHub, and the film must all refer to the same
> submitted revision. Fields marked _(TBD)_ are filled at final submission (after the
> film is rendered and the final documentation commit is made).

- **Assignment:** Assignment 1 — Extend Walker Jumpman (CSYE 7270, Fall 2026)
- **Student:** Sreeja Pulaparty (pulaparty.s@northeastern.edu)
- **Project name:** walker-jumpman-joe — "Firefighter Rescue"
- **GitHub repository:** https://github.com/pulapartys/walker-jumpman-joe
- **Submitted commit SHA:** _(TBD — the final documentation commit)_
- **Game-source revision shown in the film:** _(TBD — the game-source commit the
  capture was recorded from; will differ from the final submission commit, which only
  adds film documentation and does not change the game source)_
- **Godot version and operating system:** Godot 4.7.2.stable.official.ed1daf0bf ·
  macOS 26 (Apple Silicon)
- **Final film URL and filename:** _(TBD — stored in course media storage; MP4 kept
  out of GitHub, linked from the README)_
- **Final film SHA-256:** _(TBD — `shasum -a 256 <film>.mp4`)_

## Summary of my changes
Extended the starter's "First Steps" slice into **"Firefighter Rescue"**:
- **Character:** replaced the "guy in a box" with a **firefighter** (helmet, turnout
  coat, air tank, rescue bag with rescued survivors' heads). Original geometric drawing;
  the 18×28 collider and movement tuning are unchanged.
- **Level:** kept the original approach (reskinned) so its route stays usable, then
  extended into a **5-platform climb** to a **fire-escape window** finish. Fire =
  jump-over hazards that stick up on the platforms.
- **Rescue + gated exit:** **touch to rescue** a person (on the climb) and a dog (on a
  risk/reward detour ledge); the exit **only completes once both are rescued**
  (locked/unlocked, "SAVED!" popup, HUD objective).
- **Countdown timer:** a 30 s per-level limit (tuned from 50 s after playtesting); running out fails the attempt and resets.
- Preserved controls, movement/jump tuning, collision, and the pause/retry/completion flow.

## Known limitations
- **One level** — the multi-level "someday" vision (Downtown/Stormy/Christmas Rush) and
  a Level 2 are documented but **not built** (out of scope for this window).
- **No vertical camera** — the climb is designed to fit the existing X-only camera.
- **P3's flame jump** clears by ~10 px (the tightest margin) — jumpable but precise.
- The fire escape completes **on foot** (a grounded touch), not a literal mid-air
  jump-through — a documented design choice to keep the finish fair.
- **No audio, no exported build** (source release). The film is delivered separately.
- The character went chick → postman → **firefighter**; the earlier **postman**
  predictions live only in git history (commit `8672fe3`), not in the current
  CHANGE-BRIEF (an honest pivot, logged in the revisions log).

## Verification at a glance
- **Automated:** 44 checks pass (`test_game.gd` 35 + `test_keyboard.gd` 9) on the real
  engine — see `TEST-REPORT.md`.
- **Human playtest:** iterative + a final consolidated pass — see `TEST-REPORT.md`.
- **Honest log:** `FRICTIONAL.md` (3 inspect-and-revise cycles).
