# SCRIPT — walker-jumpman-joe walkthrough (walker mode) · Liam narration

Narrator: Liam (Kokoro `am_onyx`). Tone: confident, casual, technically aware — plain, not
praise-y. Credits Sreeja Pulaparty as the designer (lightly). Foregrounds the 40s clock, the
decision points, and the hose. Technical claims are all true to the code (collider, tuning,
data-driven JSON, `fire_height`, the input action, the gated finish). Timings synced later.

## B00 — ClaudeComposerAsk (illustrative reconstruction of Sreeja's design brief; NOT a transcript)
> "Please use Walker to convert my game design document into a playable Godot project.
> I'm Sreeja Pulaparty, and my idea is **Firefighter Rescue**: you're a firefighter racing a
> forty-second countdown across two burning buildings. Climb the first, hose down a fire
> blocking a trapped person's window and pull them out, jump the burning street, climb the
> second to save a trapped dog — and escape off the rooftop, which only opens once everyone
> is safe."

## B01 — What was built (plain; a scope correction, not praise)
> "Here's what came back — built on Nik Bear Brown's *walker-jumpman* starter, up on GitHub
> as Sreeja's **pulapartys / walker-jumpman-joe**. It's one level — not a whole game — but it
> runs start to finish, and the fire isn't scenery here; it's something you interact with.
> A firefighter, two burning buildings, a hose you use to clear a path, two rescues — a
> person and a dog — and a rooftop escape that only opens once both are safe, all on a
> forty-second clock. Fifty automated checks sit behind it."

## Gameplay body (riffs synced to the action — technical + tied to the idea)
- **Start + controls + clock:** "Controls: A and D to move, space for a single fixed-height
  jump — no double-jump — and W for the hose. The player's a CharacterBody2D with an
  eighteen-by-twenty-eight collider, and the starter's movement tuning is untouched, so the
  jump feels exactly like the original. The single jump is deliberate — every gap is sized to
  clear with exactly one. And the forty-second limit is just a value in the level's JSON,
  counting down the moment you move."
- **The climb — data-driven, fire vs. safe:** "The level is data-driven: one JSON file lists
  the platforms, the flames, the survivors, and the finish, and the game builds them at
  runtime as solid bodies and trigger areas. The flames are hazard areas that stick up into
  the jump arcs, so each ledge is a thread-the-needle decision — and the spacing's tuned so
  it's always *just* makeable."
- **The hose (the new control):** "To reach the trapped person there's a wall of fire in the
  window — it's lethal, and it blocks the rescue. So we added a new input action — 'water,'
  bound to W — without touching any existing control. Tap it near the fire and the hose pours
  for about four seconds while the fire burns down: full, half, gone. You're spending clock
  time to open the path."
- **Cause → effect (how it works):** "And here's the actual mechanism: instead of a fixed
  hitbox, the fire's height is recomputed every frame by one function — `fire_height` — and
  that same number both draws the flames and defines the kill zone. So the visual and the
  collision shrink in lockstep, and the base stays lethal until it hits zero. That's exactly
  why you can't sneak a rescue through a half-burned fire."
- **Rescue the person:** "Once it's out, the rescue is just an overlap — walk your collider
  into the survivor's trigger area and they're saved, gated so it only fires when you're not
  already dying. You can see them pop into the bag on your back."
- **Descent + burning street:** "Down off the building — a drop the geometry's tuned to catch
  — then one committed jump across a burning street, a ground-level gap with fire in it."
- **B2 climb + the dog:** "Second building, a second climb, and the dog — placed off the main
  line, so reaching it is a detour, not something you pass by accident."
- **The gated exit (the rule, in code):** "The finish is a trigger too, but with a condition:
  it only completes when you overlap it, on the ground, AND an 'all-rescued' flag is true.
  One survivor short and it stays locked and tells you to rescue everyone first. That gate is
  the whole design — both, or nothing."
- **Completion:** "Both saved, up onto the roof, and out — with time on the clock to spare."
- **Failure + recovery:** "Fall or touch fire and the state machine flips to a dying state,
  then drops you back at the start — no lives, no penalty screen, just an instant retry."

## Verdict (observed vs. untested vs. planned; decision-design as a plus)
> "The verdict: it all works, and I watched it — the firefighter, the climbs, the hose with
> its shrinking fire, both rescues, the gated exit, the timer, and all fifty checks green.
> The real strength is that it's built around *decisions* — the hose, the burning street, the
> go-get-both gate — instead of empty floor, and that's a genuine plus. Honest caveats: I
> can't speak to feel on other machines, and a couple of the flame jumps are tight — makeable,
> but precise. And it's one level; a second is planned, not built."

## Your Turn
> "Your turn — grab the repo, **pulapartys / walker-jumpman-joe**, and try one thing: drop a
> second fire on the way to the dog, and see whether that four-second hose still feels fair
> against the forty-second clock."

## Outro (OUTRO-LOCK — spoken, never scored)
> Liam re-reads the exact episode title, then: "At Nik Bear Brown." 1s tail hold. No music.
