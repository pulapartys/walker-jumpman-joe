# SOURCES — walker-jumpman-joe

> Credit for the starter, assets, tools, and collaborators, plus an explicit
> account of what the **AI** contributed vs. what the **human** decided, checked,
> changed, or rejected. This is the "I can explain it" record.

- **Assignment:** Assignment 1 — Extend Walker Jumpman (CSYE 7270, Fall 2026)
- **Student / author:** Sreeja Pulaparty (pulaparty.s@northeastern.edu)
- **Project:** walker-jumpman-joe — a "Firefighter Rescue" extension of the starter.

## Starter (credited)
- **[nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman)** — the
  "First Steps" playable slice (Godot 4.7.2 / typed GDScript). Our project is an
  **extension** of that starter: we kept its control/retry engine, its state machine,
  its collider and movement tuning, and its original ground route (reskinned), and
  built the firefighter theme, the two-building level (climb → hose → rescue → burning
  street → second climb → rooftop escape), the rescue + **hose (extinguishable fire)**
  mechanics, the countdown timer, and a readability/figure repaint on top.
- The starter's original design docs (`GDD.md`, `GAME-BRIEF.md`, `LEVEL-DESIGN.md`,
  `BUILD-REPORT.md`, etc.) remain in the repo as the starter's package.

## Assets & provenance
- **All game visuals are original geometric drawing** in code (`draw_rect`,
  `draw_line`, `draw_circle`, `draw_colored_polygon`) — the firefighter, flames,
  survivors, fire-escape window, HUD. **No imported art, sprites, or textures.** No
  recovered assets, no AI image generation, no paid asset service.
- **Font:** Godot's built-in `ThemeDB.fallback_font` (engine default).
- **Audio:** none in the game.

## Tools
- **Godot 4.7.2.stable.official.ed1daf0bf** (Compatibility/GL renderer) — engine.
- **Claude Code** (Anthropic, Claude Opus 4.8) — the AI pair-builder.
- **git / GitHub** — version control ([pulapartys/walker-jumpman-joe](https://github.com/pulapartys/walker-jumpman-joe)).
- **Brutalist `godot-waikthrough` skill** (nikbearbrown/brutalist.art) — for the
  required explainer film. Runs on the **free/local tier** (Kokoro voice, Manim,
  Remotion, faster-whisper); **no purchased API credits or paid keys used.**

## Human vs. AI — who did what

**The short version:** this is **Sreeja's game and Sreeja's ideas.** Sreeja used the AI
(Claude Code) as a **supporting tool** to build those ideas — reading through all the
design docs, **deciding what code to add and how to modify the game**, then **manually
playing, testing, and retrying the game after every change** to judge what worked, what
didn't, and what to improve or reject next.

### Human (Sreeja Pulaparty) — author, decision-maker, and tester
- **The ideas are hers:** the game concept and theme (chick → postman → **Firefighter
  Rescue**), the character, the level design, the dog detour, the gated fire escape, and
  the countdown — every design decision.
- **Read through all the docs and decided the plan:** worked through the starter's
  README/GDD/build report and our own CHANGE-BRIEF / TEST-REPORT / WORK-PROGRESS, then
  **decided what to add and how to modify the game** at each step and directed the AI tool
  accordingly. Nothing was built without her go-ahead.
- **Manually tested after every change:** played and **retried** the game each time, then
  came up with the next **improvement, rejection, or "that didn't work."** This drove three
  inspect-and-revise cycles — flames that didn't kill a walking player, rescues with no
  visible payoff, a stale redraw — that the automated tests could never have caught.
- **Owned the process:** the git workflow (branch, reviewed PRs, merged to `main`), the
  scope calls (rejected an over-scoped Level 2 + vertical camera), and the submission.

### AI (Claude Code, Opus 4.8) — the supporting tool
Under Sreeja's direction, the AI **implemented her decisions** in GDScript (the firefighter
drawing, level data, and the flame/rescue/gating/timer systems), **ran the automated
checks**, **traced the jump physics** she asked to be verified, and **helped diagnose** the
issues she found while playtesting. It drafted the docs from her decisions and her **real**
observations (no invented playtest results), and — for the planned film — will drive the
capture + render toolkit under her direction (narration is the toolkit's local Kokoro
voice, not a person). It is a tool that executes and checks; the judgment, the testing, and
the direction are hers.

### What the human accepted / modified / rejected (examples)
- **Rejected** an over-scoped plan (Level 2 + vertical camera + lever) as out of scope
  for the assignment window — kept it as a documented "someday" vision.
- **Modified** the character choice twice (chick → postman → firefighter) before coding.
- **Rejected** the AI's hand-computed reachability numbers, requiring a real-engine
  measurement — which then caught a 0.07 px flame graze (single-building) and a −8.6 px
  street-jump clip (two-building).
- **Rejected** the hose's first fire placement (a 0.3 px die-on-landing margin) and its
  **bot-tuned timer**, and required a *visible* trapped person behind the fire; directed the
  fix to a ~40 px safe landing runway and a **human-tuned 40 s** limit.
- **Directed** the readability pass over several rounds from playing + screenshots (lighter
  buildings, fewer/beige windows, a clearly-a-person + clearly-a-dog, fix the text overflow).
- **Accepted** the AI's diagnoses (mid-jump finish → `is_on_floor()`; stale visuals →
  `queue_redraw()`; one shared `fire_height()` so the hose visual and kill-zone match) after
  the fixes were tested.

## "I can explain it" — where the reasoning lives
- **Predictions before code:** `CHANGE-BRIEF.md`
- **What was tested + how it played:** `TEST-REPORT.md`
- **What each code change is and why:** `WORK-PROGRESS.md`
- **Honest struggle + inspect-and-revise cycles:** `FRICTIONAL.md`
- **Character design reasoning:** `CHARACTER-DESIGN.md`
