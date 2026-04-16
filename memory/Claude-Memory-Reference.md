# Claude Memory Reference

**Version:** 2.0.0
**Last Updated:** 2026-04-13
**Parent Doc:** `architecture/Claude-Operating-Architecture.md`

---

## The Three Layers

### Layer 1: Auto-Generated Memories
- Narrative text synthesized by Anthropic's backend from conversation history
- Updates ~24 hours after conversations end, recency-biased
- Cannot directly edit — influence through conversations and Layer 2 edits

### Layer 2: Memory Edits
- Up to 30 entries, 500 characters each
- Managed via `memory_user_edits` tool or settings UI
- Use for: corrections, factual additions, exclusions, behavioral nudges

### Layer 3: Conversation Context
- Everything in the current conversation — highest fidelity, ephemeral
- When conversation ends, only what Layer 1 decides to extract persists

---

## Scoping Rules

| Context | Layer 1 | Layer 2 | Layer 3 |
|---------|---------|---------|---------|
| Standard chat | ✓ | ✓ | ✓ |
| Project chat | Project memory instead | Likely not injected | ✓ |
| Incognito | ✗ | ✗ | ✓ but not saved |

---

## Memory Edits — Template

**Capacity:** ___ of 30 used

| # | Edit Content |
|---|-------------|
| 1 | *(your first memory edit)* |

*Populate this table during your first health check.*

---

## Export Strategy

- **Edits:** `exports/edits/YYYY-MM-DD-memory-edits.md`
- **Auto-memories:** `exports/auto/YYYY-MM-DD-auto-memories.md`
- Diff via `git diff` between successive exports to track what changed

---

## Memory Intent Document

Before managing memory edits, declare your intent. `memory/memory-intent-template.md` provides the structure:

- Declares what belongs in memory, what belongs elsewhere, and what to exclude
- Serves as the audit baseline — compare current memory state against declared intent at each review
- The Memory Edit Allocation section provides a budget framework with suggested categories
- Fill in your own version and store it in your personal environment (e.g., `claude-environment/memory/memory-intent.md`)

---

## What Belongs Where

| Content type | Destination |
|-------------|-------------|
| Stable identity, working model, frameworks/IP | Memory edits |
| Behavioral style, formatting, response length | Profile Preferences |
| Tone, voice, writing characteristics | Styles |
| Active project context, goals, stakeholders | Project Instructions or Project Knowledge |
| Repo-specific or tool-specific rules | CLAUDE.md |
| Current sprint status, milestones, anything weekly | Prefer Project Instructions/Knowledge; memory summary may capture naturally — don't use memory edit slots |
| Credentials, client names, sensitive info | Never — in any layer |

---

## How to Audit Memory

Run `scripts/memory-audit.md` monthly, or whenever responses feel miscalibrated.

- **Works in:** any regular claude.ai conversation — web, desktop app, mobile app
- **Does not apply to:** incognito chats (memory inactive; profile preferences and styles still apply); Claude Code (uses a separate CLAUDE.md-based system with its own `/memory` command)
- **Cowork within Projects:** behavior not fully validated — treat as experimental; run from your individual account context, not a shared session
- **Note:** memory availability varies by account type and organization settings; the prompt works where Claude memory is active
- Takes 5–10 minutes and produces a numbered action list executable on any device

---

## How to Influence the Memory Summary

*Observed patterns — framework heuristics, not documented guarantees*

One pattern is clearly documented: telling Claude what you want it to remember can update the memory summary directly from chat and apply immediately to the next conversation.

Two additional patterns have been observed in practice but are not published product guarantees:

1. **End-of-session summary:** For important conversations, asking Claude to summarize what's worth retaining before ending may increase that session's contribution to the next memory summary refresh.
2. **Consistency:** Preferences reinforced across multiple conversations may be retained more reliably than those stated once.

For active project context — goals, stakeholders, current work — prefer Project Instructions or Project Knowledge. These mechanisms are designed for that content and do not rely on the memory summary refresh cycle.

---

## What Makes a Good Memory Edit

**Good — single stable fact, applies broadly:**
- `Senior Engineer at Acme Corp.` — identity anchor
- `Prefers test-driven development. Push back if tests are skipped.` — behavioral nudge with enforcement
- `Primary stack: Python, FastAPI, PostgreSQL.` — structural context

**Poor — wrong layer, too volatile, or too large:**
- `Currently working on Project X, targeting June launch` — volatile; belongs in Project Instructions
- `Prefers concise responses, no bullet points, direct tone` — belongs in Profile Preferences
- Long multi-sentence specifications — too large; memory edits should be a single focused fact

---

## Maintenance

| Activity | Frequency | Tool |
|----------|-----------|------|
| Quick status check | As needed | `/memory-status` — 30-second Layer 2 view + Layer 1 pulse |
| Advisory analysis | As needed, especially after substantive conversations | `/memory-assistant` — intent coverage + conversation suggestions + prioritized fixes |
| Export edits and memory summary | Every 2–4 weeks (via health check) | `scripts/health-check.md` |
| Diff against previous export | Each export cycle | Compare via `git diff` on committed exports |
| Full governance review | Post-health-check | `scripts/memory-dream.md` → `scripts/memory-populate.md` |
| Full audit against memory intent | Monthly (via `scripts/memory-audit.md`) | `scripts/memory-audit.md` |
| Review before adding a new edit | Every time — check if an existing edit can be retired first | Manual or `/memory-status` |
