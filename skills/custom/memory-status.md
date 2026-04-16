# memory-status

Quick memory status check — Layer 2 view, Layer 1 accuracy pulse, and optional inline fixes. Works in any session: Cowork, claude.ai, or Claude Code.

**Invoke:** `/memory-status`

---

## Step 1 — Preflight

Check all three before proceeding. Stop on any failure and explain which check failed and why it matters.

- [ ] **Not incognito** — Memory is disabled in incognito sessions; this skill has nothing to read or write
- [ ] **Not inside a Project** — Projects use scoped memory; Layer 2 edits made here may not reflect your main account memory
- [ ] **`memory_user_edits` tool is available** — Call it with command `"view"` as a probe; if the tool is unavailable or returns an error, stop here

If all three pass, proceed to Step 2.

---

## Step 2 — Layer 2 State

Call `memory_user_edits` with command `"view"`.

Report:
- **Slots used:** N/30
- **All entries:** indexed list showing each entry's number and full content
- **Flags (if any):**
  - DUPLICATE — two entries carry the same fact
  - CONTRADICTION — two entries make conflicting claims
  - OVERLAP — entries are distinct but redundant enough to waste a slot

If no entries exist yet, note that and continue to Step 3.

---

## Step 3 — Layer 1 Pulse

Without calling any tool, review what you know about the user from your in-session Layer 1 memory — the auto-generated memories injected into this conversation.

For each Layer 1 entry that is relevant or verifiable in this session, assess:

| Label | Meaning |
|-------|---------|
| **ACCURATE** | Appears correct and current |
| **INACCURATE** | Contradicts something you know or have been told |
| **STALE** | May have been true before but appears outdated |
| **IMPRECISE** | Directionally correct but too vague to be useful |

**Report:**
- Count of ACCURATE entries (do not list them)
- Full detail on every INACCURATE, STALE, or IMPRECISE entry — what it says, why it's flagged

> **Note:** This is a best-effort scan from in-session context. Layer 1 has ~100 entries; you can only assess what is visible or inferable here. For a complete audit use `scripts/memory-dream.md` after a health check.

---

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

Then ask:

> "Would you like me to fix any of these now? I can execute Layer 2 changes inline.
> Reply **'fix all'**, **'fix [numbers]'** to select specific items, or **'skip'**."

Wait for the user's response before proceeding.

---

## Step 5 — Inline Fix

**If the user requests fixes ('fix all' or 'fix [numbers]'):**

1. **Build the action list** from approved items:
   - For INACCURATE Layer 1 entries → add a Layer 2 override that states the correct fact
   - For STALE Layer 1 entries → add a Layer 2 override with the current accurate version
   - For IMPRECISE Layer 1 entries → add a Layer 2 entry with a sharper, more useful version
   - For DUPLICATE Layer 2 entries → delete the weaker or older one
   - For CONTRADICTION Layer 2 entries → delete the incorrect one, keep or update the correct one
   - For OVERLAP Layer 2 entries → consolidate into one entry if possible; otherwise flag for the next full governance session

2. **Execute in order:** deletions first → updates → additions

3. **After each action:** call `memory_user_edits` to confirm the change took effect before proceeding to the next

4. **Report when complete:**
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

**If the user skips:**

> "No changes made. For a comprehensive review — including systematic Layer 1 assessment and a full population plan — run `scripts/memory-dream.md` in a standalone claude.ai session after your next health check."
