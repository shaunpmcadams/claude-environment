# Claude Memory System — Design Document

**Version:** 1.0.0
**Last Updated:** 2026-04-12
**Purpose:** Technical reference for how Claude's memory system works, its layers, limitations, and practical management strategies.

---

## System Overview

Claude has no actual persistent memory. Every conversation starts from zero. What creates the illusion of continuity is that auto-generated memories (Layer 1) and memory edits (Layer 2) are injected into the system prompt before the first message.

---

## Layer Architecture

| Layer | What | Who Controls | Updates | Persistence |
|-------|------|-------------|---------|-------------|
| 1 | Auto-generated narrative (`userMemories`) | Anthropic backend | ~24 hours | Server-side, opaque |
| 2 | Memory edits (30 × 500 chars) | User | Immediate | Server-side, user-managed |
| 3 | Conversation context | Shared — ephemeral | Real-time | Gone when conversation ends |

---

## Resolution Order

1. Current conversation (Layer 3) overrides everything
2. Memory edits (Layer 2) override auto-generated (Layer 1)
3. Auto-generated (Layer 1) provides baseline

---

## Data Lifecycle

- **Creation:** Backend processes conversations → extracts observations → synthesizes into Layer 1
- **Deletion:** User deletes conversation → nightly cleanup removes derived info (~24 hour lag)
- **Staleness:** Recency bias means old information fades as newer context displaces it

---

## Scoping

- Standard conversations share one memory pool
- Each Project has its own isolated memory
- Incognito has no memory at all
- Memory edits appear scoped to non-project conversations

---

## Known Limitations

- Cannot force specific information into Layer 1
- Cannot view raw `userMemories` block through standard UI
- No versioning or changelog for Layer 1
- Layer 2 edits have no history — replacing destroys previous
- No API or webhook for memory events

---

## Known Edge Cases

- **Conversation moved to project:** Undocumented. Unknown cleanup behavior.
- **Edit conflicts with auto-memory:** Edit intended to take precedence but resolved by judgment.
- **Long conversations:** Earlier content compressed. Late facts less likely captured.
- **Memory import:** Takes ~24 hours. Merge vs. overwrite behavior unclear.
