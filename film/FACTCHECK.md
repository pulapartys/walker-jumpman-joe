# FACTCHECK.md — every on-screen / narrated claim traced to source

Game source: `pulapartys/walker-jumpman-joe` @ c18abe0 (build_id c01e5a18…). Starter:
`nikbearbrown/walker-jumpman`. Claims below are verifiable in the code, the level JSON, or the
game repo's TEST-REPORT.md.

| Claim (narration / on-screen) | Source of truth |
|---|---|
| Extension of Nik Bear Brown's walker-jumpman starter | `README.md`, `SOURCES.md`; starter repo credited |
| Designer / author: Sreeja Pulaparty | `README.md`, `SOURCES.md`, `SUBMISSION.md` |
| GitHub: pulapartys/walker-jumpman-joe | repo URL |
| One fixed-height jump, no double-jump | `features/player/player.gd` + `tuning.gd`; test `fixed-jump-and-no-double`, `held-jump-no-bounce` |
| 18×28 collider, movement tuning unchanged | `player.gd` collider; `tuning.gd`; jump rise 56.07 px identical to baseline (TEST-REPORT) |
| New control **W = "water"**, additive (existing controls untouched) | `session.gd` `_setup_input()` `"water":[KEY_W]`; keyboard test 9/9 |
| 40-second countdown, a value in the level JSON | `levels/first_steps.json` `"time_limit": 40`; HUD counts down; tests `timer-expiry-fails`, `route-beats-timer` |
| Level is data-driven (JSON → runtime bodies/areas) | `session.gd` reads `first_steps.json` (solids/hazards/survivors/finish) → StaticBody2D + Area2D |
| Flames are hazards that kill on touch | `session.gd` hazard Area2D; tests `walk-into-flame-B1L1/B2L1/B2L2` (DYING) |
| Hose: progressive extinguish full→half(2s)→gone(4s) | `session.gd` `EXTINGUISH_TICKS=240`, `fire_height()`; tests `hose-extinguishes-fire`, `half-size-fire-still-kills` |
| One `fire_height()` drives both the flames AND the kill zone | `session.gd`: `_draw()` and the collision check both call `fire_height()` |
| Base stays lethal until fully out (can't rescue through a half fire) | test `half-size-fire-still-kills` (t=2s, extinguish_ticks=120 → DYING, person not rescued) |
| Rescue = Area2D overlap, gated so it can't fire while dying | `session.gd` rescue loop guarded by `if not fatal:` |
| Rooftop exit gated: overlap + on-floor + all-rescued | `session.gd` `goal.overlaps_body(player) and player.is_on_floor() and all_rescued`; test `exit-locked-without-rescues` |
| No lives; touch fire/fall → dying → instant retry | `session.gd` state machine + `restart_attempt()`; tests `respawn`, `twenty-retries` |
| Fifty automated checks, all green | TEST-REPORT.md: `test_game.gd` 41 + `test_keyboard.gd` 9 = 50/50 |
| Route completes in ~17 s (under the 40 s clock) | scripted route `complete-real-route` / `route-beats-timer` |
| A couple of flame jumps are tight (precise) | TEST-REPORT flame clearances (~10 px climb); flagged as a limitation |
| One level; a second is planned, not built | `README.md` / `SUBMISSION.md` known limitations; coverage feature `second-level` = planned |

**Labeling:** the B00 composer prompt is an **illustrative reconstruction** of Sreeja's design
brief, not a historical transcript. All gameplay is **scripted-input capture** (see CAPTURE.md),
not a human playtest.
