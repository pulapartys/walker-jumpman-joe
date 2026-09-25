# SUBMISSION — Assignment 1: Extend Walker Jumpman

> Canvas submission note. Canvas, GitHub, and the film all refer to the same submitted
> revision. The **submitted commit SHA is the final documentation commit** — recorded in the
> Canvas note (a commit cannot embed its own hash).

- **Assignment:** Assignment 1 — Extend Walker Jumpman (CSYE 7270, Fall 2026)
- **Student:** Sreeja Pulaparty (pulaparty.s@northeastern.edu)
- **Project name:** walker-jumpman-joe — "Firefighter Rescue"
- **GitHub repository:** https://github.com/pulapartys/walker-jumpman-joe
- **Submitted commit SHA:** the final documentation commit on `main` (this commit adds the
  film docs + links; its hash is pasted into the Canvas note — a commit can't contain its own SHA).
- **Game-source revision shown in the film:** **`c18abe0`** (Merge PR #4, on `main`). The
  game source is unchanged since; later commits only add documentation. Source-snapshot
  build_id `c01e5a18bd6d6e8ece9bd61d0bd1790f5b6f90e7c09d51ed98ce6e45b4f52106`.
- **Godot version and operating system:** Godot 4.7.2.stable.official.ed1daf0bf ·
  macOS 26 (Apple Silicon)
- **Final film URL and filename:** `claude-liam-walker-jumpman-joe-walkthrough.mp4` —
  [Northeastern SharePoint (course media)](https://northeastern-my.sharepoint.com/:f:/g/personal/pulaparty_s_northeastern_edu/IgAvhraS3cKYQp7qPLGMYkTFAaoX6uyCtB3XiVJu-IHtnno?e=fcMLKf).
  (MP4 kept out of GitHub; the film's beat sheet / script / coverage / evidence are in `film/`.)
- **Final film SHA-256:** `b1257c496b07f9fcca1d37eb601828ed1dd1410b909d1478d837b49e6f46fd1b`

## Summary of my changes
Extended the starter's "First Steps" slice into **"Firefighter Rescue"** — a two-building
firefighter run:
- **Character:** replaced the "guy in a box" with a **firefighter** (helmet, turnout coat +
  reflective stripe, air tank, rescue bag with rescued survivors' heads, a pale rim light).
  Original geometric drawing; the **18×28 collider and movement tuning are unchanged** (jump
  rise still 56.07 px).
- **Two-building level:** kept the original approach (reskinned) so its route stays usable,
  then extended into **Building 1** (climb → window rescue), a **descent**, a **burning-street
  jump**, and **Building 2** (a second climb → **rooftop fire escape** finish). Fire =
  stick-up hazards that kill on touch. The finish is moved to the far rooftop so the new
  section must be completed to win.
- **The hose (new decision + input `W`):** a large **blocking fire** sits between the
  firefighter and a **visible trapped person** — lethal and path-blocking until put out.
  Tap **W** in range → water pours and the fire **progressively extinguishes** (full → half
  at ~2 s → gone at ~4 s); the kill-zone shrinks with the flames but the base stays lethal
  until fully out, so you can't rescue through it. `W` is a new additive input; existing
  controls are untouched.
- **Rescue + gated exit:** **touch to rescue** the person (B1) and the dog (B2); the exit
  **only completes once both are rescued** (locked/unlocked, "SAVED!" popup, HUD objective).
- **Countdown timer:** a **40 s** per-level limit (human-playtested); running out fails the
  attempt and resets.
- **Readability pass (drawing only):** light-brown facades, half as many beige windows,
  recognizable person/dog survivors in dark window openings, bigger HELP! bubbles, `W: hose`
  control hint — no collision/tuning/position change.
- Preserved controls, movement/jump tuning, collision, and the pause/retry/completion flow.

**Decision points the extension adds (the "clear player decision or challenge"):** fire-vs-safe
climb jumps; the **hose as a timed commitment** (the lit fire can't be run past or rescued
through, so you must spend ~4 s putting it out to reach the person); the burning-street risk
jump; and the **gated exit that forces rescuing both** — the rooftop escape won't unlock until
the person *and* the off-path dog are saved, so you can't skip the second climb.

## Known limitations
- **One level** — the multi-level "someday" vision (Level 2, downtown/stormy themes) is
  documented but **not built** (out of scope for this window).
- **No vertical camera** — the climbs are designed to fit the existing X-only camera.
- The fire escape completes **on foot** (a grounded touch), not a literal mid-air
  jump-through — a documented design choice to keep the finish fair.
- The hose is **auto-aimed and auto-completing** once started — a deliberate simplification.
- **No audio, no exported build** (source release).
- The character went chick → postman → **firefighter**; the earlier **postman** predictions
  live only in git history (commit `8672fe3`), not in the current CHANGE-BRIEF (an honest
  pivot, logged in the revisions log).
- The explainer film's gameplay is a **scripted-input capture** (labeled in the film), not a
  live human run; the required human playtest is in `TEST-REPORT.md` / `FRICTIONAL.md`.

## Verification at a glance
- **Automated:** **50 checks** pass (`test_game.gd` **41** + `test_keyboard.gd` **9**) on the
  real engine, including the hose suite (extinguish, half-size-still-kills, rescue-blocked,
  resets-on-retry) and the full two-building route with 0 deaths — see `TEST-REPORT.md`.
- **Human playtest:** iterative per-increment + the two-building/hose playtests — see
  `TEST-REPORT.md`.
- **Honest log:** `FRICTIONAL.md` (inspect-and-revise cycles incl. the hose reviewer flags
  and the readability pass).
