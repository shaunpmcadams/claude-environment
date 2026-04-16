# Memory Audit

**When to run:** Monthly, or whenever Claude's responses feel miscalibrated.
**Where to run:** Any regular claude.ai conversation — web, desktop app, or mobile.
**Does not apply to:** Incognito chats, Claude Code sessions.

Paste this entire prompt into a claude.ai conversation after filling in Block 2.

---

## Block 1 — Preflight

*This block runs first. Do not skip.*

```
BEFORE STARTING:

1. Confirm this is not an incognito chat. Memory is not active in incognito
   conversations — stop and restart in a regular conversation.
   Note: profile preferences and styles may still apply even in incognito.

2. State whether you are auditing:
   (a) standalone account memory, or
   (b) this project's memory.
   These are separate scopes — do not mix them.
   If this conversation is inside a Project, you are auditing project memory,
   not your account-wide memory.

3. Check whether memory appears available in this conversation.
   If you cannot verify this from context, say so and instruct me to check
   Settings → Capabilities before proceeding.
   If memory appears paused, disabled, or unavailable, stop.
```

---

## Block 2 — My Memory Intent

*Fill this in before pasting. Every field is optional except Audit scope.*

```
MY MEMORY INTENT:

Audit scope: [standalone account memory / this project's memory]

Stable facts worth keeping in memory:
[Identity, working model, frameworks/IP, technical context —
things true across all or most sessions]

Response preferences (belong in Profile Preferences or Styles, not memory):
[Communication style, response length, formatting rules, interaction patterns]

Current project context (prefer Project Instructions or Project Knowledge over memory edits):
[Active projects, goals, stakeholders —
the memory or project summary may handle these naturally within scope]

Repo or tool-specific rules (belong in CLAUDE.md, not memory):
[Per-repo or per-tool instructions — or N/A if not using Claude Code]

Never save to memory:
[Client names, credentials, sprint status, anything transient or sensitive]

Suspected problems already happening:
[Optional — responses that feel off, context that keeps dropping, beliefs that seem wrong]
```

---

## Block 3 — Audit Instructions

*Fixed text — do not modify.*

```
Run the following six steps in order.

---

STEP 1 — SANITIZED MEMORY EXPORT

Review your current memory exactly as it appears in your context.
Provide a sanitized export:
- Preserve wording verbatim where safe
- Redact any content matching the "Never save" list above, or that appears
  sensitive — use [REDACTED: description of type] as a placeholder
- Label the memory summary and explicit memory edits when distinguishable;
  if that distinction is not visible in your context, say so

Do not print content I have marked as never-save.
If I need a full unredacted export for forensic review, I will explicitly ask:
"Export my memory verbatim in full."

---

STEP 2 — COMPARE AGAINST INTENT

For each item in MY MEMORY INTENT above:
- Is it represented in memory?
- Is the representation accurate?
- Does the memory summary or project summary contradict any intent item?

---

STEP 3 — FLAG PROBLEMS

Call out specifically:
- Entries referencing ended projects or outdated context (stale)
- Content from the "Never save" list that appears in memory —
  partial snippet or description only, not the full text
- Entries that are too long, pack multiple facts, or would be hard to maintain
- Content routed to the wrong destination:
  memory vs. Profile Preferences vs. Styles vs. Project Instructions
  vs. Project Knowledge vs. CLAUDE.md

---

STEP 4 — NUMBERED ACTION LIST

Produce numbered, immediately executable actions.
Branch based on the audit scope declared in MY MEMORY INTENT:

IF STANDALONE ACCOUNT MEMORY:
- "Say this in chat to update immediately: [exact text]"
  — for additions and corrections; applies to next conversation
- "In Settings, delete the memory edit that contains: [partial quote]"
  — for deletions; Settings is authoritative for removals
- "Move to Profile Preferences: [exact text to paste in Settings → Profile]"
- "Move to Styles: [style name and exact text]"
- "Move to Project Instructions for [project name]: [exact text]"
- "Move to Project Knowledge for [project name]: [description of what to add]"
- "Move to CLAUDE.md for [repo/tool name]: [exact text]"
- "Do not persist anywhere — re-introduce in conversation when relevant: [description]"

IF PROJECT MEMORY:
- "Say this in chat to update the project memory immediately: [exact text]"
- "In Project Settings, update Project Instructions: [exact text]"
- "Move to Project Knowledge: [description]"
- "Move to Profile Preferences: [exact text]"
  — for behavior/style content misrouted to project memory
- "Move to Styles: [style name and exact text]"
- "Move to CLAUDE.md for [repo/tool name]: [exact text]"
- "In a regular non-project chat, say this to add to account-level memory: [exact text]"
  — for facts that apply across all projects, not just this one
- "Do not persist anywhere: [description]"
- Note: if the project summary contains inaccurate entries, correct the source —
  update project instructions or remove/move chats that introduced the wrong context

---

STEP 5 — MEMORY REALIGNMENT

Only run this step if corrections were found in Steps 2–3.
Skip entirely if no corrections were needed.

State the accurate versions of any corrected facts as plain, direct declarations.

- Standalone scope: these help the memory summary align with corrected facts
  on its next refresh
- Project scope: these help the project summary align with corrected facts
  within this project's context

Format: "For the record: [accurate statement of fact.]"

---

STEP 6 — RECOMMENDED STEADY-STATE

Produce a target to maintain going forward — not just the result of today's cleanup:

- Standalone scope: list 3–8 ideal long-term memory edits based on the declared
  intent — each focused on a single fact and easy to maintain
- Project scope: list 3–8 ideal retained items, split across project summary
  context, Project Instructions, and Project Knowledge as appropriate

---

EMBEDDED RULES (apply throughout):

Privacy: when flagging "never save" content, use partial snippets or descriptive
references only — do not reproduce the content being flagged for removal.

Free-plan: do not search past chats; rely only on currently loaded memory and
the intent block above.
```
