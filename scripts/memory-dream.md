# Memory Dream — Structured Prompt

**When to run:** After a health check, when Layer 1 may contain inaccuracies or Layer 2 slots are underutilized.  
**Where to run:** Regular claude.ai conversations (web, desktop, mobile) — NOT incognito or Claude Code sessions.

---

## Block 1 — Preflight

BEFORE STARTING:
1. Confirm this is not an incognito chat. Memory is not active in incognito — stop and restart in a regular conversation.
2. Confirm you are working with standalone account memory (not a Project). This script targets account-level Layer 1 and Layer 2 only.
3. Confirm memory is active. If you are unsure, check Settings → Capabilities before proceeding.

---

## Block 2 — Context (fill in all three fields before pasting)

```
LAYER 1 AUTO-MEMORIES EXPORT:
[Paste the full contents of your YYYY-MM-DD-auto-memories.md file from your last health check]

MY MEMORY INTENT:
[Paste the full contents of your memory/memory-intent.md file]

CURRENT LAYER 2 EDITS:
[Paste the full contents of your YYYY-MM-DD-memory-edits.md file from your last health check]
```

---

## Block 3 — Dream Instructions

Execute each step in order. Do not skip steps.

**Step 1 — Layer 1 Accuracy Review**
Compare the Layer 1 export against the Memory Intent.
For each entry in the Layer 1 export:
- Flag entries that contradict a declared fact in the Intent (label: INACCURATE — one sentence explanation)
- Flag entries that reference context likely stale per the Intent's "Current Focus" or "Never Retain" sections (label: STALE — one sentence explanation)
- Flag entries that are potentially correct but imprecise or misleadingly phrased (label: IMPRECISE — one sentence explanation)
- Count accurate, well-formed entries (label: ACCURATE — report count only, do not list individually)

Output: numbered list of flagged entries only.

**Step 2 — Layer 2 Current State Review**
Review each current Layer 2 edit against the Memory Intent.
For each edit:
- Is it still accurate and necessary?
- Does it overlap with or duplicate a Layer 1 entry?
- Is it a candidate for deletion (superseded, stale, or no longer needed)?

Mark each as KEEP, UPDATE, or DELETE with one-sentence rationale.

**Step 3 — Layer 2 Population Plan**
Using the Layer 2 Edit Allocation strategy from the Memory Intent, propose which unused slots to fill.
Rules:
- Each proposed edit: single focused fact, 500 characters or fewer
- Priority order: (1) corrections for INACCURATE Layer 1 entries, (2) STALE overrides, (3) gaps in "Always Retain" coverage, (4) behavioral nudges, (5) exclusions
- Do not propose edits for content Layer 1 already handles accurately — don't burn slots redundantly
- Propose no more than 10 new edits unless the intent clearly warrants more

Output: numbered list of proposed edits, each with:
- Proposed text (ready to use verbatim)
- Category (correction / structural / behavioral / exclusion)
- Priority rank (1 = highest)
- Rationale (one sentence)

**Step 4 — Numbered Action List**
Consolidate all findings into an immediately executable numbered action list, grouped in this order:
1. Deletions: "In Settings → Memory, delete the Layer 2 edit containing: [partial quote]"
2. Updates: "Update existing Layer 2 edit containing [partial quote] to: [new exact text]"
3. Layer 1 corrections: "Say this in chat to correct Layer 1 immediately: [exact text]"
4. Layer 1 deletions via Settings: "In Settings → Memory, delete the auto-memory containing: [partial quote]"
5. Additions (in priority order): "Add new Layer 2 edit (Priority N): [exact text]"

**Step 5 — Reinforcement Reminder**
Produce a short block (under 200 words) the user can paste into their next claude.ai conversation after completing the action list. This anchors corrections and new edits. Format:

```
REINFORCEMENT REMINDER (say this in your next claude.ai conversation):
"[Restate the most important corrected facts as direct declarations. Reference any new Layer 2 edits by topic. Keep under 200 words.]"
```
