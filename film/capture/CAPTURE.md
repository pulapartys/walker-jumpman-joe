# CAPTURE.md — how the gameplay footage was recorded, edited, and verified

**Game:** walker-jumpman-joe ("Firefighter Rescue") · **Student/designer:** Sreeja Pulaparty
**Repo:** https://github.com/pulapartys/walker-jumpman-joe · game-source commit **c18abe0**
(source unchanged since; later doc commits do not touch game source)

## Engine & settings
- **Godot 4.7.2.stable.official.ed1daf0bf** (Compatibility / GL renderer), macOS (Apple M1, Metal).
- **Capture method:** Godot **Movie Maker**, recording the real rendered viewport at **native
  3840×2160** (the capture copy's `window/size/window_width/height_override` set to 6× the
  640×360 logical base, for crisp integer scaling). Exact command:
  ```
  godot --path <capture-copy>/godot --write-movie run-01.avi --fixed-fps 60 \
        --script res://tests/capture_run2.gd
  ```
  Then AVI → H.264 MP4 via ffmpeg 9.0.2 (`-c:v libx264 -crf 18 -pix_fmt yuv420p`).
- Movie Maker is **offline rendering, not evidence of real-time FPS.**

## Input method — scripted-input (labeled; NOT a human playtest)
Both runs are driven by a deterministic input driver that dispatches **real `InputEventKey`
events** through `Input.parse_input_event` (the same path a keyboard uses) into the real
`main.tscn`. The driver runs once per 60 Hz physics tick (a `Node` with `_physics_process`,
priority −100) and only **observes `player.position`/state to time inputs, like a player.**
It does **not** teleport, set completion, disable collisions, or call any test-only shortcut.
Coverage `method` is `scripted-input`. (Sreeja's own human playtests are in the repo's
`TEST-REPORT.md` / `FRICTIONAL.md`; a scripted route does not replace them.)

- **run-01.mp4** — full clean playthrough (20.73 s): approach → B1 climb → **hose the fire**
  (progressive extinguish) → rescue person → descent → burning street → B2 climb → rescue dog →
  gated rooftop exit → completion → replay. Driver reported `state=COMPLETE, deaths=0, marks=13`.
- **run-02.mp4** — genuine failure + recovery (6.32 s): jump the step → walk into the flame →
  **die** ("The fire got you.", retries=1) → automatic respawn → clear the step + flame → stop.
  Driver reported `deaths=1`.
- Input logs: `run-01-inputs.jsonl`, `run-02-inputs.jsonl` (one `{tick, action, pressed}` per event).
- Driver scripts (in the isolated capture copy, not the shipped game): `capture_run2.gd`,
  `capture_fail2.gd`.

## Post-capture editing (in the film)
- Gameplay is cut into per-beat clips at **true speed**. Where the narration runs longer than
  the action, each clip appends either a **held final frame** or a **clearly-labeled
  "SLOW-MOTION REPLAY"** of the same action (a burned-in overlay). The underlying action is
  **never silently slowed to look real-time**; the normal-speed pass is always shown first.
- No gameplay was faked, and the game was not edited to hide a defect.

## Verification / QC (see also `_qc/REPORT.md` — the toolkit's Gate V output)
- **Coverage contract** (`./art godot-waikthrough --check`) → **PASS**: 9 implemented features
  + 1 planned; captures verified native **3840×2160** (16:9); clip SHA-256s + input logs
  present; every evidence `beat_id` exists with narration; time ranges in bounds.
- **GATE T (typography):** the designed/bookend beats (B00, B01, B08, B09, B9C, B10) **PASS**
  (confirmed with `type_check.py --skip-pixels`). The gameplay beats (B02–B07) are **real Godot
  capture**, exempt from GATE T's designed-typography checks — the flags there are the *game's
  own HUD* (full-width bars, small labels), not the film's typography; each was inspected by eye
  and is legible at 4K. (Not relabeled as a source report to evade checks.)
- **Gate V (visual):** **0 blockers / 0 majors**, with per-beat, diff-reviewable declarations:
  `full_bleed` on the gameplay beats (edge-to-edge game footage by design), `sparse_by_design`
  on the sparse bookend cards, and `contrast_regions` on B06 (the HUD's high-contrast cream
  bars — the global heuristic trips only because the light-brown building fills that frame).
- **Human backstop:** every beat frame was reviewed by eye (see `_qc/montage.png`).

## Hashes
- Source-snapshot `build_id`: `c01e5a18bd6d6e8ece9bd61d0bd1790f5b6f90e7c09d51ed98ce6e45b4f52106`
  (SHA-256 over the sorted per-file SHA-256s of `game/session.gd`, `game/main.tscn`,
  `features/player/player.gd`, `features/player/tuning.gd`, `ui/hud.gd`,
  `levels/first_steps.json`; tests/ and `.uid` excluded).
- Capture files: run-01.mp4 `9c0e9ea5…c4cc7d78ba` · run-02.mp4 `834eb5dd…e726dde7994cc1`.
- Final film `claude-liam-walker-jumpman-joe-walkthrough.mp4`:
  `b1257c496b07f9fcca1d37eb601828ed1dd1410b909d1478d837b49e6f46fd1b`.
