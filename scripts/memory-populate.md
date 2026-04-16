# Memory Populate — Structured Prompt

**When to run:** After approving an action list from a Memory Dream session.  
**Where to run:** Regular claude.ai conversations — NOT incognito. Requires the memory_user_edits tool.

---

## Block 1 — Preflight

BEFORE STARTING:
1. Confirm this is not an incognito chat.
2. Confirm you are in a standalone account memory session (not a Project).
3. Confirm memory is active and the memory_user_edits tool is available. If the tool is not available, stop — this script requires it.
4. Call memory_user_edits with command "view" and record the current state before making any changes.

---

## Block 2 — Action List (fill in before pasting)

```
APPROVED ACTION LIST FROM DREAM SESSION:
[Paste the numbered action list from your memory-dream.md session output verbatim]

EXECUTE ONLY THESE ACTIONS: [yes / or specific numbers e.g. "1,2,4,7"]
```

---

## Block 3 — Execute Instructions

Execute each step in order. Stop and report clearly if any step fails.

**Step 1 — Pre-execution state**
Call memory_user_edits with command "view". Record current edit count and confirm slot availability for any planned additions.

**Step 2 — Execute deletions**
For each action marked as a deletion:
- Call memory_user_edits with command "delete" and the target edit
- Confirm deletion succeeded before proceeding
- If a deletion fails: report the failure and stop; do not proceed to additions

**Step 3 — Execute updates**
For each action marked as an update:
- Call memory_user_edits with command "update" and the new text
- Confirm the update succeeded

**Step 4 — Execute additions in priority order**
For each addition, in priority order (Priority 1 first):
- Call memory_user_edits with command "add" and the exact text from the action list
- Confirm each addition succeeded before proceeding
- If a slot limit is reached: stop and report which items were set vs. remaining

**Step 5 — Post-execution verification**
Call memory_user_edits with command "view" to capture final state. Confirm each intended change is reflected.

**Step 6 — Output summary**
Produce a summary in this format:

```
MEMORY POPULATE SUMMARY — YYYY-MM-DD

Actions executed: N of N requested
Layer 2 slots used: N of 30

COMPLETED:
[numbered list of actions that succeeded]

SKIPPED (not in execute list):
[numbered list if any]

FAILED:
[numbered list if any, with error details]

REMAINING AVAILABLE SLOTS: N

RECOMMENDED RE-RUN CADENCE:
[Based on remaining unused slots and Memory Intent:
- If >20 slots remain and Layer 1 is mostly accurate: no re-run until next health check
- If Layer 1 corrections were made via chat this session: re-run memory-dream.md after 2–3 conversations to check if Layer 1 has updated
- If population plan was partially executed: schedule a follow-up populate session within 1 week]
```
