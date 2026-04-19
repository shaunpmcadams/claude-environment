---
name: memory-status
description: >
  Quick Claude memory health check — shows Layer 2 slots used (N/30), lists all memory edits,
  flags duplicates and contradictions, assesses Layer 1 accuracy, and offers inline fixes.
  Use this skill whenever the user asks about their memory status, what Claude remembers about them,
  how many memory slots they're using, whether their memory is healthy, or wants to check or fix
  their Layer 2 edits. Also trigger on "check my memory", "memory health", "what do you remember
  about me", "how many slots", "memory check", "show my memory", "Layer 2 status".
  This is the quick 30-second check. For a full advisory with intent coverage and conversation
  suggestions, use memory-assistant instead.
---

# Memory Status — Quick Check

A fast Layer 2 view + Layer 1 accuracy pulse + optional inline fixes. Takes about 30 seconds.

For a comprehensive advisory (intent coverage, conversation suggestions, prioritized recommendations), use `/memory-assistant` instead.

## Step 1 — Preflight

Check all three before proceeding. Stop on any failure and explain which check failed and why it matters.

- **Not incognito** — Memory is disabled in incognito sessions. If you cannot detect memory context or the user confirms they're in incognito, stop and explain: "Memory is not available in incognito. Open a standard claude.ai conversation to use this skill."
- **Not inside a Project** — Projects use scoped memory that doesn't reflect account-level state. If you detect project-scoped memory or the user confirms they're in a Project, stop and explain: "This skill reads account-level memory, which isn't accessible inside a Project. Open a standalone claude.ai conversation instead."
- **`memory_user_edits` tool is available** — Call it with command `"view"` as a probe. If the tool is unavailable or returns an error, stop and explain: "The memory_user_edits tool isn't available in this session. This skill requires it to read Layer 2 state."

If all three pass, proceed to Step 2.

## Step 2 — Layer 2 State

Call `memory_user_edits` with command `"view"`.

Report:
- **Slots used:** N/30
- **All entries:** indexed list showing each entry's number and full content
- **Flags (if any):**
  - DUPLICATE — two entries carry the same fact
  - CONTRADICTION — two entries make conflicting claims
  - OVERLAP — entries are distinct but redundant enough to waste a slot

If no entries exist yet, note "Layer 2 is empty (0/30 slots used)" and continue to Step 3.

## Step 3 — Layer 1 Pulse

Without calling any tool, review what you know about the user from your in-session Layer 1 memory — the auto-generated memories injected into this conversation.

For each Layer 1 entry that is relevant or verifiable in this session, assess:

| Label | Meaning |
|-------|---------|
| **ACCURATE** | Appears correct and current |
| **INACCURATE** | Contradicts something you know or have been told |
| **STALE** | May have been true before but appears outdated |
| **IMPRECISE** | Directionally correct but too vague to be useful |

Report:
- Count of ACCURATE entries (do not list them)
- Full detail on every flagged entry — what it says, why it's flagged

This is a best-effort scan from in-session context. Layer 1 has ~100 entries; only what is visible or inferable here is assessed.

## Step 4 — Status Summary

Output a concise status block:

```
MEMORY STATUS — YYYY-MM-DD
─────────────────────────────────────
Layer 2:  N/30 slots used
Layer 1:  N accurate | N flagged
          INACCURATE: N  STALE: N  IMPRECISE: N
Layer 2:  [No issues] or [DUPLICATE: N  CONTRADICTION: N  OVERLAP: N]
─────────────────────────────────────
```

Then ask: "Would you like me to fix any of these now? Reply **'fix all'**, **'fix [numbers]'** to select specific items, or **'skip'**."

Wait for the user's response before proceeding.

## Step 5 — Inline Fix

**If the user requests fixes ('fix all' or 'fix [numbers]'):**

1. Build the action list from approved items:
   - For INACCURATE Layer 1 entries → add a Layer 2 override that states the correct fact
   - For STALE Layer 1 entries → add a Layer 2 override with the current accurate version
   - For IMPRECISE Layer 1 entries → add a Layer 2 entry with a sharper, more useful version
   - For DUPLICATE Layer 2 entries → delete the weaker or older one
   - For CONTRADICTION Layer 2 entries → delete the incorrect one, keep or update the correct one
   - For OVERLAP Layer 2 entries → consolidate into one entry if possible

   **Tier-aware rules:** If entries are tagged `[P0]`, `[P1]`, or `[P2]`, apply these constraints regardless of other recommendations:
   - Never recommend deleting or consolidating a `[P0]` entry — skip it and note "protected (P0)" unless the user explicitly requests it
   - Consolidate `[P1]` entries before recommending deletion
   - `[P2]` entries are expendable — recommend these first when slots are needed
   - Tier tags take precedence over slot-pressure heuristics

2. Execute in order: deletions first → updates → additions

3. After each action: call `memory_user_edits` to confirm the change took effect before proceeding to the next

4. Report:
   ```
   FIXES APPLIED
   ─────────────────────────────────────
   Deleted:  N entries
   Updated:  N entries
   Added:    N entries
   Skipped:  N (reason)

   Layer 2 after: N/30 slots used
   ─────────────────────────────────────
   ```

5. **Emit layer2-current.md sync content** (only if Layer 2 changed):

   Produce a complete ready-to-save `memory/layer2-current.md` body reflecting the NEW Layer 2 state, filtered by tier:
   - Include every `[P0]` and `[P1]` entry
   - Include untagged entries (conservative default)
   - Exclude `[P2]` entries unless the user explicitly requested they be synced
   - Preserve the file header and replace only the "Current entries" section
   - Update the "Last synced" line to today's date

   Present the content as a copy-pasteable markdown block titled "**layer2-current.md sync content — save to `memory/layer2-current.md` in your claude-environment repo**". If the session has GitHub MCP available, also offer: "I can commit this directly via GitHub MCP — confirm with 'commit it'."

**If the user skips:**

"No changes made. For a comprehensive review — including intent coverage and conversation suggestions — run `/memory-assistant`. For a full systematic governance review, run `memory-dream.md` after your next health check."
