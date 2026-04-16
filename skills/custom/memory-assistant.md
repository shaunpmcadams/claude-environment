# memory-assistant

Comprehensive memory advisor — current state analysis, intent coverage check, conversation-aware suggestions, and inline fixes. Works in any session: Cowork, claude.ai, or Claude Code.

For a quick status check without the full analysis, use `/memory-status` instead.

**Invoke:** `/memory-assistant`

---

## Step 1 — Preflight

Check all three before proceeding. Stop on any failure and explain which check failed and why it matters.

- [ ] **Not incognito** — Memory is disabled in incognito sessions; this skill has nothing to read or write
- [ ] **Not inside a Project** — Projects use scoped memory; Layer 2 edits made here may not reflect your main account memory
- [ ] **`memory_user_edits` tool is available** — Call it with command `"view"` as a probe; if the tool is unavailable or returns an error, stop here

If all three pass, proceed to Step 2.

---

## Step 2 — Current State

### Layer 2 View

Call `memory_user_edits` with command `"view"`.

Report:
- **Slots used:** N/30
- **All entries:** indexed list showing each entry's number and full content
- **Flags (if any):**
  - DUPLICATE — two entries carry the same fact
  - CONTRADICTION — two entries make conflicting claims
  - OVERLAP — entries are distinct but redundant enough to waste a slot

### Layer 1 Pulse

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

### Status Block

Output:

```
CURRENT STATE
─────────────────────────────────────
Layer 2:  N/30 slots used
Layer 1:  N accurate | N flagged
          INACCURATE: N  STALE: N  IMPRECISE: N
Layer 2:  [No issues] or [DUPLICATE: N  CONTRADICTION: N  OVERLAP: N]
─────────────────────────────────────
```

> **Note:** The Layer 1 Pulse is a best-effort scan from in-session context. Layer 1 has ~100 entries; only what is visible or inferable here is assessed. For a complete audit, use `scripts/memory-dream.md` after a health check.

---

## Step 3 — Intent Coverage

Ask the user:

> "Do you have your `memory-intent.md` content handy? Paste it below and I'll check how well your Layer 2 reflects your declared intent. Or say **'skip'** to move on."

Wait for user response.

### If intent is provided:

Compare each intent category against current Layer 2 entries. For each item in the intent document, classify:

| Classification | Meaning |
|----------------|---------|
| **Covered** | Intent item has a matching Layer 2 entry that accurately represents it |
| **Missing** | Intent item has no Layer 2 coverage and Layer 1 doesn't reliably handle it |
| **Drifted** | A Layer 2 entry exists for this item but no longer matches the current intent |
| **Wrong layer** | Content is in Layer 2 but the intent document says it belongs in Preferences, Styles, or Project Instructions |

Output as a coverage table:

```
INTENT COVERAGE
─────────────────────────────────────
Category                    Status
─────────────────────────────────────
[Intent item summary]       Covered / Missing / Drifted / Wrong layer
[Intent item summary]       Covered / Missing / Drifted / Wrong layer
...
─────────────────────────────────────
Covered: N  |  Missing: N  |  Drifted: N  |  Wrong layer: N
```

### If skipped:

Note: "Intent coverage was not assessed. For a richer analysis, run `/memory-assistant` again with your `memory-intent.md` content — it's the most valuable part of this check."

Proceed to Step 4.

---

## Step 4 — Conversation Scan

Review the current conversation context — everything discussed in this session so far.

Identify facts, preferences, or patterns that meet all three criteria:

1. **Stable** — not transient project status, not one-time context, not something that will change next week
2. **Cross-session** — would be useful for Claude to know in future conversations, not just this one
3. **Not already covered** — not present in Layer 2 and not reliably captured in Layer 1

For each candidate, propose:

```
SUGGESTION [N]:
  Proposed text:  "[exact Layer 2 edit text, ≤500 chars]"
  Category:       [identity / working-model / behavioral / correction / exclusion]
  Rationale:      [one sentence — why this is worth a Layer 2 slot]
```

If no candidates are found: "No new memory candidates identified from this conversation."

> **What makes a good suggestion:** A single, stable fact that applies broadly across sessions. Not project status, not formatting preferences (those belong in Preferences/Styles), not something Claude already handles accurately via Layer 1.

---

## Step 5 — Recommendations

### Summary Block

```
MEMORY ASSISTANT REPORT — YYYY-MM-DD
─────────────────────────────────────────────────
Layer 2:      N/30 slots used
Layer 1:      N accurate | N flagged
Intent:       N covered | N missing | N drifted | [skipped]
Suggestions:  N new candidates from this conversation
─────────────────────────────────────────────────
```

### Prioritized Action List

Consolidate all findings into a single numbered list, grouped by priority:

**Group 1 — Fixes** (from Step 2)
Corrections for Layer 1 inaccuracies (Layer 2 overrides) and Layer 2 structural issues (duplicates, contradictions).

**Group 2 — Intent Gaps** (from Step 3, if intent was provided)
Additions to close coverage gaps between declared intent and current Layer 2 state.

**Group 3 — New Suggestions** (from Step 4)
Candidates identified from the current conversation. Each includes exact proposed text.

**Group 4 — Housekeeping** (from Steps 2 and 3)
Wrong-layer moves (Layer 2 content that belongs in Preferences/Styles/Project Instructions), overlap consolidations, and slot optimizations.

For each action, provide:
- Action number
- Action type (add / update / delete / move)
- Exact text for Layer 2 edits
- One-sentence rationale

If no actions are recommended: "Your memory looks healthy. No changes recommended at this time."

### Prompt

> "Would you like me to execute any of these? Reply **'fix all'**, **'fix [numbers]'** to select specific items, or **'skip'**."

Wait for user response.

---

## Step 6 — Execute

### If the user requests fixes ('fix all' or 'fix [numbers]'):

1. **Build the execution list** from approved items only

2. **Execute in order:**
   - Deletions first — call `memory_user_edits` for each deletion, confirm before proceeding
   - Updates — call `memory_user_edits` for each update, confirm before proceeding
   - Additions in priority order — call `memory_user_edits` for each addition, confirm before proceeding
   - If slot limit reached during additions: stop and report which items were set vs. remaining

3. **Report:**

```
CHANGES APPLIED
─────────────────────────────────────
Deleted:   N entries
Updated:   N entries
Added:     N entries
Skipped:   N (reason for each)

Layer 2 after:  N/30 slots used
─────────────────────────────────────
```

### If the user skips:

> "No changes made. Your options for follow-up:
> - **Quick recheck:** Run `/memory-status` anytime for a fast Layer 2 view
> - **Full governance:** Run `memory-dream.md` after your next health check for a systematic Layer 1 review and population plan
> - **Run again:** Re-invoke `/memory-assistant` anytime — especially after substantive conversations where new memory candidates are likely"
