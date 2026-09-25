# PROMPTS — on-screen composer text + audio engine

**Audio:** Kokoro (local, free), voice `am_onyx` ("Liam, in for Bear"). No paid TTS. Durations
are measured from the generated MP3s and are the master clock.

**B00 — ClaudeComposerAsk (typed prompt; illustrative reconstruction of Sreeja's design brief):**
> "Please use Walker to convert my game design document into a playable Godot project.
> Firefighter Rescue: race a 40-second countdown across two burning buildings, hose a fire to
> reach a trapped person, cross a burning street, save a dog, and escape off the roof once
> everyone is safe."

**B09 — ClaudeComposerAsk (Your Turn prompt):**
> "Clone pulapartys/walker-jumpman-joe. Add a second blocking fire on the path to the dog, then
> re-check: does the 4-second hose still fit inside the 40-second clock?"

**B10 — ClaudeTitleOutro (spoken title, per OUTRO-LOCK):**
> "Firefighter Rescue: Extending Walker Jumpman. At Nik Bear Brown." — then 1s silence, no music.

Full narration for every beat is in `SCRIPT.md`; each beat's `narration_text` lives in
`beat_sheet.json`.
