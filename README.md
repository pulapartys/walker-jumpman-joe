# walker-jumpman-joe — Firefighter Rescue

**A 2D platformer built by extending the Walker Jumpman "First Steps" starter · Godot 4.7.2 / typed GDScript**

You're a **firefighter** racing a 40-second countdown across **two burning buildings**:
climb the first, **hose the fire** blocking a trapped person's window and pull them out,
**cross the burning street**, climb the second to rescue a trapped dog, and **jump off the
rooftop fire escape** before the fire — or the clock — wins. This is **Assignment 1
(Extend Walker Jumpman)** for CSYE 7270.

- **Author:** Sreeja Pulaparty (pulaparty.s@northeastern.edu)
- **Starter credit:** extended from **[nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman)** (the "First Steps" slice). This repo keeps the starter's control/retry engine, state machine, collider, and movement tuning, and builds the firefighter theme, the two-building level, the rescue + hose mechanics, and the timer on top.
- **Engine:** Godot **4.7.2.stable.official.ed1daf0bf** (Compatibility / GL renderer), macOS. No .NET runtime, no external assets.
- **Final film:** _(link TBD — the Brutalist explainer is rendered separately and stored in course media; the MP4 is kept out of GitHub and linked here + in SUBMISSION.md)_

## Run it
1. Install **Godot 4.7.2** (Compatibility build) and open **`godot/project.godot`** in the editor.
2. Press **▶ Play** (top-right). Or from the repo root: `godot --path godot`.
   - The `walker-jumpman.command` launcher expects Godot in `/Applications`; if yours is elsewhere, use the editor or the CLI above.

## Controls
| Action | Keys |
|---|---|
| Move | **A / D** or **← / →** |
| Jump (one fixed-height jump) | **Space** |
| **Hose the fire** (when near the blocking fire) | **W** |
| Retry attempt | **R** |
| Pause / resume | **Esc** or **P** |
| Start / confirm | **Enter** |
| Back to menu | **M** (paused or after finishing) |

**Goal:** In **Building 1**, climb to the trapped **person's** window — a large fire blocks
the path, so **tap W to hose it** (it shrinks over ~4 s), then walk across and rescue them.
Drop down, **jump the burning street** to **Building 2**, climb it to rescue the trapped
**dog**, then reach the **rooftop fire escape** — it only opens once **both** are saved.
Touch fire or fall = death + instant retry. Run out of the **40 s** clock = the attempt fails.

## What I changed (vs. the starter)
- **Character → firefighter** (`features/player/player.gd` `_draw()`): red helmet, turnout
  coat + reflective stripe, air tank, rescue bag (rescued survivors ride as visible heads),
  plus a pale **rim light** so the dark suit reads against dark surfaces. Original geometric
  drawing; **collider and movement tuning unchanged** (jump rise still 56.07 px).
- **Spikes → fire** (`game/session.gd`): flames as stick-up hazards that kill on touch.
- **Two-building level** (`levels/first_steps.json` + `session.gd`): the original ground
  approach is kept (reskinned, still a usable route), then extended into **Building 1**
  (climb + window rescue), a **descent**, a **burning-street jump**, and **Building 2** (a
  second climb) to a **rooftop fire escape** finish. Multiple new jump landings; decorative
  facades behind the data-driven ledges; the finish is moved to the far rooftop so the new
  section must be completed to win.
- **The hose — a new decision + input** (`W` = "water"): a large **blocking fire** stands
  between the firefighter and a **visible trapped person**. It's lethal and blocks the path
  until put out. Tap **W** in range → water pours and the fire **progressively extinguishes**
  (full → half at ~2 s → gone at ~4 s); the kill-zone shrinks with the flames but the base
  stays lethal until fully out, so you **can't rescue through it**. `W` is a *new, additive*
  input — existing controls are untouched.
- **Rescue mechanic + gated exit:** touch to rescue (person + dog); the fire escape is
  **gated** on rescuing both (locked/unlocked visuals, "SAVED!" popup, HUD objective,
  heads-in-bag).
- **Countdown timer:** a **40 s** per-level limit (human-playtested); the HUD counts down
  (red under 10 s); hitting 0 fails the attempt and resets.
- **Readability pass (drawing only):** very light-brown facades with **half as many beige
  windows** (so the only orange on screen is the actual fire), recognizable **waving-person**
  and **dog** survivors in dark window openings, bigger **HELP!** bubbles with pointer tails,
  and a `W: hose` control hint. No collision/tuning/position change.
- **Preserved:** controls, movement/jump tuning, the 18×28 collider, and the pause/retry/completion flow.

## Decisions the level asks you to make
Not just empty floor — the extension is built around real choices under the 40 s clock:
- **Fire vs. safe** — most climb jumps put a flame in the arc; risk the tighter hop over fire or take the slower, safer line.
- **The hose — a timed commitment** — the lit fire **can't be run past or rescued through**, so you must **decide to spend ~4 s hosing it** to reach the trapped person, at a cost to the clock.
- **The burning street** — a committed ground-level jump over fire between the two buildings.
- **Rescue BOTH, not just the easy one** — the rooftop fire escape **does not unlock until the person *and* the dog are saved**, so you can't rush past the off-path dog; you must climb Building 2 and complete the whole route to win.

## Tests
**50 automated checks** on the real engine (mechanics + real-keyboard input):
```bash
godot --headless --path godot --script res://tests/test_game.gd      # 41 checks
godot --headless --path godot --script res://tests/test_keyboard.gd  #  9 checks
```
Exit code 0 = all pass. Details + human playtests: **[TEST-REPORT.md](TEST-REPORT.md)**.

## Known limitations
- **One level** — the multi-level "someday" vision (a Level 2, downtown/stormy themes) is
  documented but **not built** (out of scope for this window).
- **No vertical camera** — the climbs are designed to fit the existing X-only camera.
- The fire escape completes on a **grounded touch**, not a literal mid-air jump-through
  (a documented design choice to keep the finish fair).
- The hose is **auto-aimed and auto-completing** once started (tap W in range) — there is no
  manual aiming; a deliberate simplification.
- **No audio; source release only** (no exported build).
- The **Brutalist explainer film is not yet rendered** — it is the remaining deliverable and
  will be linked here + in SUBMISSION.md once produced.

## Project docs
- **[CHANGE-BRIEF.md](CHANGE-BRIEF.md)** — predictions written *before* each build step (+ honest revisions log).
- **[TEST-REPORT.md](TEST-REPORT.md)** — automated results + human playtests per increment + the current build at a glance.
- **[FRICTIONAL.md](FRICTIONAL.md)** — the honest log (inspect-and-revise cycles, human vs. AI).
- **[SOURCES.md](SOURCES.md)** — starter/asset/tool credit + the human/AI contribution split.
- **[WORK-PROGRESS.md](WORK-PROGRESS.md)** — a code-change log (what changed and why).
- **[CHARACTER-DESIGN.md](CHARACTER-DESIGN.md)** — character design reasoning and iterations.
- **[SUBMISSION.md](SUBMISSION.md)** — the Canvas submission metadata block.

_Sreeja's game and Sreeja's ideas — she decides what to build and how to modify it, and manually plays and retries after every change; the AI is a supporting tool that implements and checks her authorized changes._
