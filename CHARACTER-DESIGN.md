# Character Design — Learning Notes & Options

> A personal reference for redesigning the Walker Jumpman character. Explains how
> Godot draws the character, decodes what every line of the current code does to
> the visual, the rules we must respect, and a menu of character ideas to choose
> from. This is a learning/planning doc — not a graded deliverable.

Related: [WALKER-JUMPMAN-NOTES.md](WALKER-JUMPMAN-NOTES.md) (whole-project map).
The character code lives in `godot/features/player/player.gd`.

---

## Part 1 — The fundamentals (how drawing works here)

### 1.1 The coordinate system (read this twice)
Godot 2D is **not** like math class:

- **+X = right, −X = left** (normal)
- **+Y = DOWN, −Y = UP** ⚠️ (flipped from math — this is the #1 beginner trap)
- Every number in the character's `_draw()` is **local** — measured from the
  character's own origin `(0,0)`, not from the screen.

**Where is `(0,0)`?** At the character's **feet** (bottom-center). So to draw the
body you move **upward = negative Y**. Anything with a *smaller* (more negative)
Y is *higher* on screen.

### 1.2 The collider — the invisible physics boundary
Defined in `player.gd` `_ready()`:

```gdscript
shape.size = Vector2(18, 28)          # 18 wide, 28 tall
collider.position = Vector2(0, -14)   # centered 14px above the feet
```

That makes an invisible **18×28 rectangle** — this is what *physics* actually
uses (floors, walls, spikes, the goal). The drawing space looks like this:

```
         x=-9      x=0      x=+9
          |         |        |
   y=-28  +---------+--------+   <- top of collider (head height)
          |                  |
          |   you draw the   |
          |   character in   |
          |   this box       |
          |                  |
   y=0    +---------O--------+   <- FEET = origin (0,0)
                    ^
              position lives here (bottom-center)
        ==============floor==============
```

### 1.3 The golden rule: physics vs. paint
- **Collider = physics.** Invisible. It's what collides. For the visual step we
  must **NOT change it** (assignment rule).
- **`_draw()` = cosmetics.** Pure paint. It has **zero** effect on collision.
  You could draw a dragon and physics would still treat it as an 18×28 box.
- **Therefore:** the drawn **body/mass must line up with that 18×28 box** so what
  the player sees matches what the physics does. Decorative bits (ears, tail,
  antenna, scarf) *may* poke outside the box — that's good for silhouette — but
  the main body should fill it, with the feet at `y=0`. A tiny sprite floating in
  the corner of the box = "misleading visual/collision mismatch" = lost points.

### 1.4 Draw order matters
Shapes drawn **later paint over** earlier ones (like stacking paper). So draw
**back-to-front**: body first, then details (eyes, sash) on top.

### 1.5 The drawing toolbox
| Function | Makes | Use for |
|---|---|---|
| `draw_rect(Rect2(x,y,w,h), color)` | filled rectangle | body, limbs, blocks |
| `draw_colored_polygon(PackedVector2Array([...]), color)` | any polygon | **triangles → ears, tails, beaks, plumes** |
| `draw_circle(center, radius, color)` | circle | round eyes, wheels, helmets |
| `draw_line(a, b, color, width)` | line | antenna, whiskers, legs |

Colors: `Color("rrggbb")` (hex string) or `Color(r,g,b)` with 0–1 floats.
`Rect2(x, y, w, h)` = top-left corner at `(x,y)`, then `w` wide and `h` tall.

---

## Part 2 — The ORIGINAL character, decoded line by line

The starter is "a guy in a box." Here is the actual `_draw()` (`player.gd:70-80`)
with what each line paints. Remember: `(0,0)` is the feet, up is negative Y.

```gdscript
var ink  := Color("25354a")   # dark navy  (outlines)
var blue := Color("287baf")   # blue       (body fill)

# stride = a walk wobble: a sine wave, but ONLY when on the ground and moving.
var stride := sin(tick * 0.7) * 2.0   if on floor and |velocity.x| > 8   else 0.0
```

| # | Code | Covers (x, y) | What you SEE |
|---|---|---|---|
| ① | `draw_rect(Rect2(-9,-27,18,24), ink)` | x −9…+9, y −27…−3 | Dark navy **body block** — fills the full collider width; the outline. |
| ② | `draw_rect(Rect2(-7,-25,14,20), blue)` | x −7…+7, y −25…−5 | Blue **inner fill**, inset 2px inside ① → leaves a 2px navy **border** (the outline trick). |
| ③ | `draw_rect(Rect2(-10,-18,20,4), orange)` | x −10…+10, y −18…−14 | Orange **sash/belt** across the torso (pokes 1px past the body each side). |
| ④ | `draw_rect(Rect2(-6,-4,5,4+stride), ink)` | x −6…−1, from y −4 down | **Left leg** — its length grows/shrinks with `stride`. |
| ⑤ | `draw_rect(Rect2(2,-4,5,4-stride), ink)` | x 2…7, from y −4 down | **Right leg** — opposite phase to the left → a **walk cycle**. |
| ⑥ | `draw_rect(<1 if facing>0 else −6>, -24, 5,5, cream)` | 5×5 near top | **Eye white** — jumps to the **left or right side** of the head based on facing. |
| ⑦ | `draw_rect(<4 if facing>0 else −6>, -23, 2,3, ink)` | 2×3 | **Pupil** — sits at the outer edge → looks in the facing direction. |

### The two "smart" variables you get for free
- **`facing`** = `+1` (right) or `−1` (left). Auto-updated whenever you move
  (`player.gd:59`). Use it to flip any **asymmetric** feature (a single eye, a
  tail, a sword). Lines ⑥/⑦ show the pattern: `x = <value> if facing > 0 else <other>`.
- **`tick`** = a frame counter that ticks up every physics step. Feed it to
  `sin(tick * speed) * amount` to make something **wobble/animate** (that's how
  the legs walk). Optional polish, not required.

### Why this one "reads sensibly"
The drawn body (①/②, x −9…+9, y −27…−3) almost exactly fills the 18×28 collider,
and the legs (④/⑤) reach down to the feet at `y=0`. So the picture and the
physics box agree. **That's the bar we have to keep** with any new design.

---

## Part 3 — The rules for OUR redesign (from the assignment)

1. **Keep the collider** (18×28 at offset `(0,-14)`) and **movement tuning** —
   do **not** edit `_ready()`'s collider or `tuning.gd` for this step.
2. Must **read clearly in 4 states**: facing **left**, facing **right**,
   **standing**, and **jumping**. → asymmetric features must flip with `facing`;
   check it still looks right in the air.
3. **No misleading mismatch** — body fills the box, feet at `y=0`.
4. **Silhouette beats color.** ~8 of 15 points = "distinct visual identity."
   The biggest lever is the **outline shape**: add shapes that stick *out* of the
   box (ears, tail, antenna, plume). A recolored box has the *same* silhouette as
   the original = weak.
5. **It's tiny** (~18×28 logical px ≈ a thumbnail). Budget: **3–5 bold features**,
   strong contrast, no fine detail.
6. Pick something **you'll enjoy explaining** in the film — you narrate *why*.

---

## Part 4 — Character options to consider

Each option lists: the **silhouette change** (the points-winner), the **facing
cue** (how we show left/right), the **tools** we'd use, and a rough **difficulty**.
Sketches are facing right; ASCII is only a rough feel.

### A. 🦊 Fox  *(strong silhouette, great facing cue)*
- **Silhouette:** two triangle **ears** out the top + a triangle **tail** out the back.
- **Facing cue:** tail flips to the back side; eyes/snout point forward.
- **Tools:** `draw_colored_polygon` (ears, tail, snout) + rects (body) + small eyes.
- **Difficulty:** medium. **Best all-round pick.**
```
   /\   /\      ears (triangles, poke above box)
  ( o  o )      directional eyes
  [######]      body fills the box
   ||  ||  <|   legs + tail (flips with facing)
  ----O----     feet @ y=0
```

### B. 🤖 Robot  *(clean, techy, easy facing)*
- **Silhouette:** an **antenna** (line + tip) out the top; boxy paneled body.
- **Facing cue:** a single big **directional eye** slides toward the facing side.
- **Tools:** `draw_line` + `draw_circle` (antenna, eye) + rects (panels, treads).
- **Difficulty:** easy–medium.
```
      |         antenna
    [====]
    [ (o)]->    single glowing eye (moves with facing)
    [####]      paneled body
    [#||#]
     || ||      tread / stub legs
    ---O---
```

### C. 🥷 Ninja  *(dynamic, action-y)*
- **Silhouette:** a **headband with a trailing tie** streaming out the back.
- **Facing cue:** the tie streams *behind*; a visor slit points forward.
- **Tools:** `draw_colored_polygon` (tie) + rects (body, visor, belt).
- **Difficulty:** medium.
```
   [====]~~~     headband tie (trails behind, flips)
   ( ---- )      visor slit (eyes)
   [######]      body
   [##--##]      belt / sash
    /|  |\
   ---O---
```

### D. 🐸 Frog  *(cute, bold, unmistakable)*
- **Silhouette:** two big **domed eyes** poking above the head; wide low body.
- **Facing cue:** pupils slide to the facing side; body can lean slightly.
- **Tools:** `draw_circle` (eyes/pupils) + rects/polygon (wide body, legs).
- **Difficulty:** easy–medium.
```
   (O)  (O)      big eyes bulge above the box
  [########]     wide green body
  [########]
   J      L      splayed legs
   ---O---
```

### E. ⚔️ Knight  *(readable, thematic)*
- **Silhouette:** a **helmet plume** out the top + a **shield** on one side.
- **Facing cue:** shield sits on the facing side; visor slit points forward.
- **Tools:** rects (armor, shield) + `draw_colored_polygon` (plume) + a visor line.
- **Difficulty:** medium–hard (most parts → tightest at this size).
```
     /|          plume
   [====]
   [|--|]        helmet visor slit
   [####]D       body + shield (on facing side)
   [####]
    || ||
   ---O---
```

### F. 🚀 Astronaut  *(distinct dome silhouette)*
- **Silhouette:** a round **helmet dome** (breaks the square outline) + a **backpack** box on the back.
- **Facing cue:** visor highlight faces forward; backpack sits behind.
- **Tools:** `draw_circle` (helmet) + rects (suit, backpack) + a visor arc.
- **Difficulty:** medium.
```
    (===)        round helmet dome
   [( o )]       visor + face
  P[#####]       suit body + backpack (P, behind)
   [#####]
    || ||
   ---O---
```

### G. 🐤 Bird / Chick  *(the beak IS the facing cue)*
- **Silhouette:** a **beak** poking out the front + a **head tuft** + a wing.
- **Facing cue:** the **beak** points in the facing direction — super clear.
- **Tools:** `draw_colored_polygon` (beak, tuft, wing) + rects (body) + eye.
- **Difficulty:** easy–medium.
```
    ^            head tuft
  ( o >          eye + beak (points where you face)
  [####]w        round body + wing
   J  L
  ---O---
```

### Quick extras (if none above grab you)
- **🐱 Cat** — like the fox but rounder; ears + curling tail.
- **👻 Ghost** — wavy polygon bottom instead of feet (floaty), two eyes; softer silhouette.
- **🟢 Slime/Blob** — dome body + drips + two eyes; add a squash-wobble with `tick`.
  (Weaker silhouette change unless we add drips/spikes — riskier for points.)

---

## Part 5 — How to choose

Ask yourself:
1. **Does it change the silhouette?** (Something poking out of the box.) — most points.
2. **How do I show facing?** (A tail, beak, single eye, or shield that flips.)
3. **Will it read at thumbnail size?** (3–5 bold shapes, high contrast.)
4. **Can I explain *why* I designed it this way?** (You narrate this in the film.)

**Top recommendations for a first-timer:** **Fox (A)**, **Robot (B)**, or
**Bird (G)** — each has a bold silhouette, an obvious facing cue, and is
comfortable to build with these tools.

> Decision log:
> - **Chosen concept:** 📮 **Postman** (Iteration 2) — for the "Postman's Rush" theme.
> - **Why:** cap + mailbag give a strong silhouette; fits the game identity and
>   gives a story to narrate in the film.
> - **Key silhouette element:** cap crown + forward brim (top/front) + mailbag (back).
> - **Facing cue:** brim + eye lead; mailbag + strap trail.
> - **Prior idea:** Iteration 1 was a 🐤 Chick (see Part 6). Never coded;
>   superseded when we adopted the Postman's Rush theme.

---

## Part 6 — Iteration 1: Chick (idea proposal — SUPERSEDED)

Status: **superseded by Iteration 2 (Postman).** Kept for honest history — this
was never written to `player.gd`. We switched to a postman after adopting the
"Postman's Rush" theme. The design reasoning below still transfers 100%.

### The thinking (design → shapes)
Every feature does one of three jobs:

| Job | Features | Purpose |
|---|---|---|
| **Silhouette** (wins points) | tuft (top), beak (front) | break the rectangular box outline |
| **Facing cue** (flips L/R) | beak, eye, wing | show which way we're moving |
| **Mass** (fills the box) | round body, legs | keep drawing aligned with the 18×28 physics box |

### Box placement map (up = −Y, feet at y=0)
```
        x=-9     x=0     x=+9
 y=-28  ┄┄┄┄┄ ╱▲╲ ┄┄┄┄┄    tuft feathers poke ABOVE the box  (silhouette)
 y=-22   ╭───────────╮
         │  👁    ▶▶▶ │     eye (front) + beak pokes out front (facing cue)
 y=-13   │ w   BODY   │     round yellow body fills box · wing on BACK
         │    belly   │
 y=-5    ╰──┐     ┌───╯
 y=0        ██   ██          two orange legs reach the feet
        ═══════════════ floor
```

### Proposed `_draw()` (replaces `player.gd:70-80`)
```gdscript
func _draw() -> void:
    # ---- palette ----
    var body_col := Color("f4c542")   # chick yellow
    var belly    := Color("ffe08a")   # lighter belly
    var ink      := Color("25354a")   # navy outline (matches the game)
    var orange   := Color("ef8a3b")   # beak + legs
    var f := facing                    # +1 = right, -1 = left (auto-updated when moving)

    # waddle: legs bob ONLY when walking on the ground (reuses the tick trick)
    var stride := sin(float(tick) * 0.7) * 2.0 if is_on_floor() and absf(velocity.x) > 8 else 0.0

    # ① LEGS (behind body): two orange stubs down to the feet (y=0)
    draw_rect(Rect2(-4, -5, 3, 5 + stride), orange)
    draw_rect(Rect2( 1, -5, 3, 5 - stride), orange)

    # ② HEAD TUFT (silhouette): 3 feathers poking out the top
    draw_colored_polygon(PackedVector2Array([Vector2(-4,-21), Vector2(-3,-27), Vector2(-1,-21)]), ink)
    draw_colored_polygon(PackedVector2Array([Vector2(-1,-22), Vector2( 0,-29), Vector2( 2,-22)]), ink)
    draw_colored_polygon(PackedVector2Array([Vector2( 2,-21), Vector2( 3,-27), Vector2( 5,-21)]), ink)

    # ③ BODY: round yellow blob filling the collider (outline, then fill, then belly)
    draw_circle(Vector2(0, -13), 9.0, ink)
    draw_circle(Vector2(0, -13), 7.5, body_col)
    draw_circle(Vector2(0, -10), 4.5, belly)

    # ④ WING on the BACK side (flips with facing)
    draw_colored_polygon(PackedVector2Array([Vector2(-6*f,-15), Vector2(-1*f,-13), Vector2(-6*f,-9)]), Color("e3b230"))

    # ⑤ EYE on the FRONT side (navy dot + tiny white highlight)
    draw_circle(Vector2(3.0*f, -17), 1.7, ink)
    draw_circle(Vector2(3.6*f, -17.6), 0.6, Color("ffffff"))

    # ⑥ BEAK poking out the FRONT (the clearest facing cue)
    draw_colored_polygon(PackedVector2Array([Vector2(6*f,-16), Vector2(11*f,-14), Vector2(6*f,-12)]), orange)
```

### Code → visual map
| # | Block | What you'll see | Job |
|---|---|---|---|
| ① | legs | two orange stubs at the bottom, waddling when walking | mass + animation |
| ② | tuft | 3 navy feather-tips above the head | **silhouette** |
| ③ | body | round yellow blob filling the box, lighter belly | mass (collision alignment) |
| ④ | wing | triangle on the **back** side, flips when turning | facing |
| ⑤ | eye | navy dot on the **front** of the face | facing |
| ⑥ | beak | orange triangle poking out the **front**, flips when turning | **silhouette + facing** |

### Why it respects the rules
- Body (③) fills the 18×28 box and legs reach `y=0` → picture matches physics box.
- `f = facing` flips beak/eye/wing → correct facing **left and right**.
- `stride` gated on ground+movement → correct **standing, walking, jumping**.
- **Collider, movement, tuning untouched** → controls/retry/tests unchanged.

### Open tweaks to consider before applying
- Colors (yellow/orange shades), keep or drop the wing, rounder vs. chunkier body,
  eye size/style. Cheap to change on paper — decide before writing to code.

---

## Part 7 — Iteration 2: Postman (CHOSEN, proposed — NOT yet applied)

Theme: **"Postman's Rush"** — a mail carrier delivering along a route to a post
office. Character: a **postman with a mailbag**. Status: **design proposal** —
not yet written to `player.gd`.

**Provenance:** original geometric drawing inspired by the generic cartoon-postman
concept (blue uniform + peaked cap + satchel). Stock images were viewed only as
reference and are **NOT imported/copied** (to be logged in `SOURCES.md`).

### Box placement map (up = −Y, feet at y=0)
```
        x=-9     x=0     x=+9
 y=-29  ┄┄┄ [ crown ] ┄┄┄        navy cap crown (pokes above)  <- silhouette
 y=-24     [===brim==>]           brim points FORWARD           <- silhouette + facing
 y=-25   ( face  o )              skin face + eye (front)       <- facing
 y=-17   [  shirt (blue) ] \      uniform + strap across chest
 y=-11   [===belt=====] [BAG]     belt · mailbag on the BACK    <- silhouette + facing
 y=-10   [  trousers  ] [BAG]
 y=-4        || ||                 legs (waddle when walking)
 y=0    ========feet========
```

### Proposed `_draw()` (replaces `player.gd:70-80`)
```gdscript
func _draw() -> void:
    # ---- palette (ORIGINAL geometric drawing — no imported art) ----
    var uniform := Color("2f6db0")   # postal-blue shirt
    var trouser := Color("22314a")   # navy trousers + cap
    var ink     := Color("1b2a3f")   # outline
    var skin    := Color("e8b98f")   # face
    var bag_col := Color("a9743f")   # brown mailbag
    var flap    := Color("7d5227")   # bag flap + strap + belt
    var gold    := Color("f2c94c")   # cap badge + buckle
    var f := facing                   # +1 right, -1 left

    var stride := sin(float(tick) * 0.7) * 2.0 if is_on_floor() and absf(velocity.x) > 8 else 0.0

    # ① LEGS (navy) to the feet, waddle when walking
    draw_rect(Rect2(-5, -4, 3, 4 + stride), trouser)
    draw_rect(Rect2( 2, -4, 3, 4 - stride), trouser)

    # ② BODY (uniform): outline, blue shirt, navy trousers, belt
    draw_rect(Rect2(-9, -19, 18, 15), ink)      # outline
    draw_rect(Rect2(-7, -17, 14, 7), uniform)   # shirt
    draw_rect(Rect2(-7, -10, 14, 6), trouser)   # trousers
    draw_rect(Rect2(-8, -11, 16, 2), flap)      # belt

    # ③ STRAP across chest (front shoulder -> back hip)
    draw_line(Vector2(5*f, -17), Vector2(-6*f, -10), flap, 2)

    # ④ MAILBAG on the BACK hip (mirrors with facing)
    var bag_left := -12.0 if f > 0 else 5.0
    draw_rect(Rect2(bag_left-1, -14, 9, 10), ink)      # outline
    draw_rect(Rect2(bag_left, -13, 7, 8), bag_col)     # bag body
    draw_rect(Rect2(bag_left, -13, 7, 3), flap)        # flap
    draw_rect(Rect2(bag_left+3, -11, 1, 2), gold)      # buckle

    # ⑤ HEAD (skin) with outline
    draw_rect(Rect2(-6, -26, 12, 8), ink)
    draw_rect(Rect2(-5, -25, 10, 6), skin)

    # ⑥ CAP: crown + forward brim + gold badge (brim mirrors with facing)
    draw_rect(Rect2(-7, -30, 14, 6), ink)          # crown outline
    draw_rect(Rect2(-6, -29, 12, 5), trouser)      # crown
    var brim_x := -1.0 if f > 0 else -10.0
    draw_rect(Rect2(brim_x, -24, 11, 2), trouser)  # brim forward
    draw_rect(Rect2(-2, -27, 4, 2), gold)          # badge

    # ⑦ EYE on the front of the face
    draw_circle(Vector2(2.5*f, -22), 1.2, ink)
```

### Code → visual map
| # | Paints | Job |
|---|---|---|
| ① | two navy legs, waddle when walking | mass + animation |
| ② | blue shirt + navy trousers + belt, filling the box | mass (collision alignment) |
| ③ | brown strap diagonally across the chest | theme + facing |
| ④ | brown mailbag on the **back** hip (flips with facing) | **silhouette + facing** |
| ⑤ | skin face | head |
| ⑥ | navy cap: crown + **forward brim** + gold badge | **silhouette + facing** |
| ⑦ | eye on the **front** of the face | facing |

### Why it respects the rules
- Body (②) + head (⑤) + legs fill the 18×28 box, feet at `y=0` → picture matches physics.
- Cap/brim (top/front) and mailbag (back) poke out for silhouette but the solid
  body stays aligned to the collider.
- `f = facing` flips brim/eye/bag/strap → correct facing **left and right**.
- `stride` gated on ground+movement → correct **standing, walking, jumping**.
- **Collider, movement, tuning untouched** → controls/retry/tests unchanged.

### Open tweaks to consider before applying
- Uniform shade (postal blue vs. teal), bag on back vs. front hip, add a small
  envelope in the front hand (very on-theme but pokes ~3px past the box), badge
  style. Cheap to change on paper — decide before writing to code.


