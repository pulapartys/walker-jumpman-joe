# walker-jumpman-joe — Firefighter Rescue

**A 2D platformer built by extending the Walker Jumpman "First Steps" starter · Godot 4.7.2 / typed GDScript**

You're a **firefighter**: race a countdown up a burning building, **rescue the trapped
person and dog** into your bag, and **jump out the fire escape** before the fire — or
the clock — wins. This is **Assignment 1 (Extend Walker Jumpman)** for CSYE 7270.

- **Author:** Sreeja Pulaparty (pulaparty.s@northeastern.edu)
- **Starter credit:** extended from **[nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman)** (the "First Steps" slice). This repo keeps the starter's control/retry engine, collider, and movement tuning, and builds the firefighter theme on top.
- **Engine:** Godot **4.7.2.stable.official.ed1daf0bf** (Compatibility / GL renderer), macOS. No .NET runtime, no external assets.
- **Final film:** _(link TBD — stored in course media; MP4 kept out of GitHub)_

## Run it
1. Install **Godot 4.7.2** (Compatibility build) and open **`godot/project.godot`** in the editor.
2. Press **▶ Play** (top-right). Or from the repo root: `godot --path godot`.
   - The `walker-jumpman.command` launcher expects Godot in `/Applications`; if yours is elsewhere, use the editor or the CLI above.

## Controls
| Action | Keys |
|---|---|
| Move | **A / D** or **← / →** |
| Jump (one fixed-height jump) | **Space** |
| Retry attempt | **R** |
| Pause / resume | **Esc** or **P** |
| Start / confirm | **Enter** |
| Back to menu | **M** (paused or after finishing) |

**Goal:** climb the building, **rescue the person and the dog** (walk into them), then
reach the **fire escape** — it only opens once **both** are saved. Touch fire or fall =
death + instant retry. Run out of time = the attempt fails.

## What I changed (vs. the starter)
- **Character → firefighter** (`features/player/player.gd` `_draw()`): red helmet, turnout
  coat + reflective stripe, air tank, rescue bag. Rescued survivors ride in the bag as
  visible heads. Original geometric drawing; **collider and tuning unchanged**.
- **Spikes → fire** (`game/session.gd`): flames as stick-up hazards that kill on touch.
- **Extended level** (`levels/first_steps.json` + `session.gd`): the original approach is
  kept (reskinned, still a usable route), then extended into a **5-platform climb** with a
  **fire-escape window** finish. A **dog on a risk/reward detour ledge** off the top floor.
- **Rescue mechanic + gated exit:** touch to rescue (person + dog); the window is **gated**
  on rescuing both (locked/unlocked visuals, "SAVED!" popup, HUD objective, heads-in-bag).
- **Countdown timer:** a 30 s per-level limit (tuned down from 50 s after playtesting); the HUD counts down (red under 10 s); hitting
  0 fails the attempt and resets.
- Preserved: controls, movement/jump tuning, collision, and the pause/retry/completion flow.

## Tests
44 automated checks on the real engine (mechanics + real-keyboard input):
```bash
godot --headless --path godot --script res://tests/test_game.gd      # 35 checks
godot --headless --path godot --script res://tests/test_keyboard.gd  #  9 checks
```
Exit code 0 = all pass. Details + human playtest: **[TEST-REPORT.md](TEST-REPORT.md)**.

## Known limitations
- **One level** — the multi-level "someday" vision and a Level 2 are documented but **not
  built** (out of scope for this window).
- **No vertical camera** — the climb is designed to fit the existing X-only camera.
- **P3's flame jump** clears by ~10 px (the tightest margin) — jumpable but precise.
- The fire escape completes on a **grounded touch**, not a literal mid-air jump-through
  (a documented design choice to keep the finish fair).
- No audio; source release only (no exported build). The film is delivered separately.

## Project docs
- **[CHANGE-BRIEF.md](CHANGE-BRIEF.md)** — predictions written *before* each build step (+ honest revisions log).
- **[TEST-REPORT.md](TEST-REPORT.md)** — automated results + human playtests per increment + the consolidated final pass.
- **[FRICTIONAL.md](FRICTIONAL.md)** — the honest log (3 inspect-and-revise cycles, human vs. AI).
- **[SOURCES.md](SOURCES.md)** — starter/asset/tool credit + the human/AI contribution split.
- **[WORK-PROGRESS.md](WORK-PROGRESS.md)** — a code-change log (what changed and why).
- **[CHARACTER-DESIGN.md](CHARACTER-DESIGN.md)** — character design reasoning and iterations.
- **[SUBMISSION.md](SUBMISSION.md)** — the Canvas submission metadata block.

_Sreeja's game and Sreeja's ideas — she decides what to build and how to modify it, and manually plays and retries after every change; the AI is a supporting tool that implements and checks her authorized changes._
