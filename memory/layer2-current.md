# Layer 2 — Current State (Cross-Platform Mirror)

**Purpose:** This file mirrors the current state of Claude's Layer 2 memory (`memory_user_edits`) so that it is visible in Claude Code sessions, not just on claude.ai surfaces.

**How it works:**
- Claude.ai reads Layer 2 directly via `memory_user_edits` — this file is not needed there
- Claude Code does not have access to Layer 2, but it reads `CLAUDE.md`, which imports this file via `@memory/layer2-current.md`
- The result: a behavioral rule you declare once in Layer 2 applies everywhere you use Claude

**Maintenance:** This file is refreshed by the `memory-status` and `memory-assistant` skills after any Layer 2 change, and by the `export-memory.md` script during a full export. Do not hand-edit — changes will be overwritten on the next sync.

**Tier filter:**
- `[P0]` behavioral rules — always synced
- `[P1]` structural context — always synced
- `[P2]` reference facts — excluded by default (often claude.ai-specific; keeps CLAUDE.md focused)
- Untagged entries — synced as a conservative default until tagged

**Last synced:** _never — awaiting first sync_

---

## Current entries

_No entries synced yet. Run `/memory-status` or `/memory-assistant` on claude.ai, then commit the emitted content here._
