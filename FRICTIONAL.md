# FRICTIONAL — honest log (walker-jumpman-joe)

> An honest record of what was actually tried, what went wrong, what I checked or
> changed in response, and who did what (human vs. AI). Retrospective notes are
> labeled. Nothing here is invented; unsuccessful attempts are kept.

- **Assignment:** Assignment 1 — Extend Walker Jumpman (CSYE 7270, Fall 2026)
- **Student:** Sreeja Pulaparty (pulaparty.s@northeastern.edu)
- **Engine:** Godot 4.7.2.stable · macOS

---

## 2026-09-22 → 09-23 · Project arc & how we worked (context)
- **Tried / expected:** as a first-time Godot user, I started by getting the starter to
  run and pass its tests, then explored what to build. I expected the character to be the
  hard part; it turned out to be the easy, isolated one, and the **level reachability +
  rendering** were where the real friction lived.
- **What changed:** the concept moved **chick → postman → firefighter** *before* any level
  code — I'd rather change direction on paper than in code. We shipped the postman first
  (commit `8672fe3`, PR #1), then pivoted to the firefighter (PR #2) because it gave a
  built-in decision and a natural moved finish.
- **How we worked (human/AI):** these are **my ideas** — I used the AI (Claude Code) as a
  **supporting tool** to build them. I read through all the docs, **decided what code to add
  and how to modify the game** at each step, and after **every change I manually played and
  retried the game** to see what worked, then came up with the next improvement, rejection,
  or "that didn't work." The AI implemented my decisions, ran the automated checks, and
  helped diagnose what I found; I accepted fixes only after testing them, and I rejected an
  over-scoped plan (Level 2 + vertical camera).
- **Learned:** automated tests verify *state/data, not pixels* — three of my most useful
  catches (flames not lethal, no rescue feedback, stale redraw) came from **playing**, not
  from the green test bar.

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

## 2026-09-23 · Increment 5 (countdown timer) — worked first try
- **Tried:** added a 50 s per-level `time_limit`; expiry → DYING "Out of time!" → retry.
- **What happened:** the first run failed **one** unexpected check — my new timer tests
  left the game `PLAYING` with `deaths=1`, which broke the later `replay-idempotent`
  (its `start_session()` no-ops when already PLAYING). **Reordered** the timer checks
  after it (no assertion weakened) → **44/44**. Honest note: this was a test-ordering bug
  I introduced, caught, and fixed — not a game bug.
- **Human/AI:** user requested Inc 5; AI implemented, hit the ordering bug, diagnosed and
  fixed it.

## 2026-09-24 · Inspect-and-revise cycle #4 (Inc-5 playtest — timer feel)
- **Observed (Sreeja's playtest):** at a 50 s limit the countdown felt **too long** — I
  finished **under 35 s every run**, so there was no real "beat the clock" pressure.
- **Decided:** tune the limit to **30 s** (my call). Trade-off noted: my more relaxed
  ~34 s runs may now time out — that's the intended pressure.
- **Changed:** `time_limit: 50 → 30` in `first_steps.json`. The scripted route still
  finishes in 12.55 s, so `route-beats-timer` still passes; **44/44**, no test changes
  needed (the checks read `level.time_limit`).
- **Human/AI:** I found the feel issue by playing and made the call; the AI applied the
  one-value change and re-ran the checks.

## 2026-09-24 · Two-building redesign (document-first, then build)
- **Tried / decided:** the single-building climb worked but felt like one idea. I decided to
  redesign the level into **two burning buildings** — rescue a person in Building 1, cross a
  **burning street** (a ground-level gap with a street flame), climb Building 2 to rescue the
  dog, and escape off the B2 rooftop. I asked for it to be **documented first** (CHANGE-BRIEF
  revision + predicted failure cases) before any code.
- **What happened / checked:** proposed platform coordinates with a reachability table, built
  it, then measured the **real** clearances on the engine. Two things the build caught that
  the paper model missed: (1) the descent from B1 landed near B1-ground's right edge, so the
  street jump took off right at the street flame (measured **−8.6 px** — a clip); (2) an early
  flame-vs-takeoff overlap. Fixed by moving the street flame deeper into the gap and giving the
  takeoff a runway → **street clearance +17–21 px**, route **0 deaths** to the B2 roof with
  both rescued.
- **Human/AI:** I set the two-building direction and the document-first gate and read the
  reachability proposal; the AI drew the layout, measured real clearances, and iterated on the
  street/flame geometry until the route survived. I re-played it after.
- **Traceable to:** PR #3 (two-building), `first_steps.json`, `route_driver.gd`, TEST-REPORT
  "two-building" section, WORK-PROGRESS Entry 13.

## 2026-09-24 · Inspect-and-revise cycle #5 (the hose — two reviewer flags)
- **Tried:** proposed a new mechanic — an **extinguishable blocking fire** (new input `W`)
  between the firefighter and the person — and posted exact numbers (fire rect, 50 px range,
  4 s duration, W wiring, tests) for review **before** building.
- **What the review caught (two real flaws):**
  - **Flag 1 — die-on-landing.** With the first placement the firefighter landed at ~1194
    still moving at 160 px/s and slid ~6.7 px, ending its collider at ~1209.7 with the fire at
    1210 — a **0.3 px** margin. You'd die just from *landing*, having done nothing wrong.
  - **Flag 2 — a bot-tuned timer.** I'd justified the timer with the *scripted route's* ~17 s.
    A human on a two-building level with a climb, a street crossing, a second climb, a 4 s
    hose, and normal fumbling takes far longer — a limit tuned to the bot is unfair.
- **Checked / changed:** repositioned so the fire visibly **blocks a visible person** (layout:
  **landing runway → fire → person**) with a verified **~40 px** clear runway (no slide-in);
  confirmed 0 deaths through the landing on the real engine. Set the timer **generously (80 s
  first)** and then tuned it **down from an actual human run to 40 s** — never from the bot.
- **Human/AI:** the reviewer (human) rejected the unfair landing math and the bot-tuned timer
  and required a *visible* trapped person; the AI recomputed the landing physics, repositioned
  fire/person, shifted Building 2 to keep reachability, and re-verified.
- **Traceable to:** PR #4, CHANGE-BRIEF hose section + revisions log, TEST-REPORT hose section,
  WORK-PROGRESS Entry 14.

## 2026-09-24 · Inspect-and-revise cycle #6 (progressive extinguish — matched collision)
- **Observed / decided:** an instant on/off fire felt flat. I asked for a **progressive**
  extinguish — full → **half height at t=2 s** → gone at **t=4 s** — with the **collision
  matching the visual at each stage**, but the **base staying lethal + blocking until fully
  out** (so you can't slip through the half-size fire, and the person is unreachable until
  t=4 s). Timer to 40 s.
- **Checked:** made **one** `fire_height()` drive *both* the drawing and the kill-zone, so they
  shrink together by construction. Added `half-size-fire-still-kills` — at t=2 s the fire is
  half height (`extinguish_ticks=120`) yet stepping in still → DYING with the person not
  rescued. `hose-extinguishes-fire` confirms still-lit at 3.5 s, out by ~4 s. **50/50**, no
  assertions weakened.
- **Human/AI:** I specified the staged behavior + the "base still blocks" rule and the tests I
  wanted; the AI implemented the shared height function, wired the collision, and added the
  half-size check.
- **Traceable to:** PR #4, `session.gd` `fire_height()`, `test_game.gd`
  (`half-size-fire-still-kills`), TEST-REPORT hose section.

## 2026-09-24 · Inspect-and-revise cycle #7 (readability / figures — from screenshots)
- **Observed (playing + screenshots):** the trapped **person read as a blob** and the **dog as
  a lump**, both camouflaged by solid-yellow window boxes; the dark firefighter blended into
  dark ledges; and the hose prompt + the "01 / TO THE BUILDINGS" label crowded the HELP! bubble
  and overflowed behind the start-menu card.
- **Decided / changed (drawing only):** redrew the **person** as a clear **waving human**
  (head + face, torso, raised arm, legs) and the **dog** with ears/snout/tail/four legs (bright
  fills + dark outlines); turned the rescue windows into **dark openings** so the figures pop;
  lightened facades to **very light brown** and **halved the windows** to **beige** (so the only
  orange left is the real fire); enlarged the HELP! bubbles with pointer tails; added a
  firefighter **rim light**; lifted the hose prompt + added a `W: hose` control hint; and hid the
  intro world-labels behind the menu card (fixed the overflow). Verified each in rendered
  screenshots (`evidence/screens/read-*.png`).
- **Human/AI:** I played, judged the readability, and gave specific art direction over several
  rounds (lighter buildings, fewer/beige windows, a clearly-a-person + clearly-a-dog, fix the
  overflow); the AI redrew the figures/facades and re-rendered for me to check. No
  collision/tuning/position changed; **50/50** held throughout.
- **Traceable to:** PR #4, `session.gd` `_draw()`, `player.gd` `_draw()`, `hud.gd`,
  `evidence/screens/read-b1-person.png` / `read-b2-dog.png` / `read-menu.png`, WORK-PROGRESS
  Entry 15.

---

## Traceability & the four Frictional elements
- **What I tried / what happened:** each entry above — real attempts and outcomes,
  including unsuccessful ones (the 0.07 px graze, the mid-jump finish, the invisible
  rescues, the test-ordering bug).
- **What I checked / changed / learned:** the "Checked/changed" and "Status: RESOLVED"
  lines, plus unresolved notes (P3's ~10 px margin flagged for playtest).
- **Human vs. AI:** the "Human/AI" line in every entry — the ideas, the decisions on what
  to build and how to modify the game, and the manual play-testing/retrying after each
  change are **Sreeja's**; the AI is the **supporting tool** that implemented those
  decisions, ran the checks, and helped diagnose what she found.
- **Traceability to commits / tests / observations:**
  - Postman milestone → commit **`8672fe3`** (PR #1, on `main`).
  - Firefighter Increments 1–4 → commit **`ccaa31b`** (PR #2, merge `1dfac3f`).
  - Increment 5 (timer) + evidence cleanup → PR #3 area (on `main`).
  - **Two-building redesign** → PR #3; **hose + progressive extinguish + readability pass** →
    PR #4 (merge **`c18abe0`**). The single-building climb above (P1–P5) was **superseded** by
    the two-building layout — those entries are retained as honest history.
  - Tests (in `godot/tests/test_game.gd`): `complete-real-route`, `flame-clearance-positive`,
    `reached-b2-roof-both-rescued`, `exit-locked-without-rescues`, `survivor-removed-on-rescue`,
    `walk-into-flame-B1L1/B2L1/B2L2`, `route-beats-timer` (40 s), `timer-expiry-fails`,
    `timer-resets-on-retry`, and the hose suite (`hose-extinguishes-fire`,
    `hose-out-of-range-noop`, `blocking-fire-kills-on-touch`, `half-size-fire-still-kills`,
    `person-rescue-blocked-until-extinguished`, `extinguish-resets-on-retry`). **50 total.**
  - Cross-refs: TEST-REPORT.md (per increment + current-build summary), WORK-PROGRESS.md
    (Entries 7–15). **Final timer = 40 s** (cycle #4's 30 s was later re-tuned; see cycles #5–6).
