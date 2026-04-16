# Memory Management Project — Setup Guide

Set up a claude.ai Project that serves as your memory governance hub. This project gives you a persistent workspace for reviewing memory health, planning Layer 2 edits, and running memory skills — with all your reference docs pre-loaded.

---

## Step 1 — Create the Project

In [claude.ai](https://claude.ai), click **Projects** → **New Project**.

**Name:** `Memory Management`

**Description:**
```
Manage and improve how Claude works for me across all sessions. This project contains my memory exports, skills inventory, and environment configuration — all version-controlled in GitHub. Use the custom skills and scripts here to check memory health, identify what's worth remembering, fix inaccuracies, and keep my Claude environment aligned with my declared intent over time.
```

---

## Step 2 — Add Project Instructions

In the project settings, paste the following into **Project Instructions**:

```
You are my memory and environment management advisor.

## What this project is for
Reviewing, maintaining, and improving my Claude memory state and environment configuration. All environment files are version-controlled in my claude-environment repo.

## Important: Memory scope
This project has its own scoped memory. My account-level memory (Layer 1 + Layer 2) is only accessible in standalone conversations — NOT inside this project. When I need to run memory skills that read or edit Layer 2 via memory_user_edits, remind me to open a standalone claude.ai conversation (not in this project) and paste the skill content there.

## Available skills (in Project Knowledge)
- /memory-status — quick Layer 2 view + Layer 1 pulse + inline fixes (run in standalone conversation)
- /memory-assistant — full advisory with intent coverage + conversation suggestions (run in standalone conversation)
- /health-check-prep — generates issue creation command and health check prompt (can run here)

## Available scripts (in Project Knowledge)
- memory-dream.md — post-health-check Layer 1 review + Layer 2 population plan (run in standalone conversation)
- memory-populate.md — execute approved action list from Dream session (run in standalone conversation)
- memory-audit.md — monthly intent vs. state review (run in standalone conversation)

## How to help me
- When I ask about my memory state, guide me to the right tool for the situation
- When I bring health check exports, help me analyze them and plan next steps
- When I ask to review my memory intent, compare it against the latest exports in this project's knowledge
- When I need to run a skill that requires memory_user_edits, tell me exactly what to paste and where
- Always reference the three-tier model: quick check → advisory → periodic governance
```

> **If you use GitHub Enterprise or have custom settings**, add the following block at the end of the instructions, filled in with your values:
>
> ```
> ## My environment
> - Version: 2.6.2
> - Personal repo: [your GitHub instance and repo path]
> - Health check mode: [auto / manual]
> - Push command: [your git push command, if non-standard]
> ```

---

## Step 3 — Add Files from GitHub

Click **Add content** → **GitHub** → select your **claude-environment** repository.

Add these 5 files:

| File | Why |
|------|-----|
| `skills/custom/memory-status.md` | Quick memory check skill — Claude follows these steps when you ask for a status check |
| `skills/custom/memory-assistant.md` | Full advisory skill — intent coverage, conversation suggestions, prioritized fixes |
| `skills/custom/health-check-prep.md` | Generates the health check issue command and ready-to-paste prompt |
| `memory/memory-intent-template.md` | Your memory intent declaration — the baseline for coverage analysis |
| `memory/Claude-Memory-Reference.md` | Reference doc explaining the three layers, scoping rules, and maintenance cadence |

> **After your first health check:** Come back and add your populated `memory/memory-intent.md` (replacing the template). Also consider adding your latest memory exports (`memory/exports/edits/` and `memory/exports/auto/`) so Claude can reference them during planning conversations.

---

## Step 4 — First Conversations

### Starter prompt 1 — Orientation

Paste this into your first conversation in the project to confirm everything is loaded:

```
I just set up this Memory Management project. Can you confirm what files you have access to? Then give me a quick summary of:
1. What memory skills are available and where to run each one
2. What my current memory intent says I want Claude to remember
3. What my next step should be to get my memory into a healthy state
```

### Starter prompt 2 — Post-health-check review

After running a health check and committing the exports, start a new conversation:

```
I just ran a health check. Here are my latest exports:

LAYER 1 (auto-memories):
[paste contents of memory/exports/auto/YYYY-MM-DD-auto-memories.md]

LAYER 2 (edits):
[paste contents of memory/exports/edits/YYYY-MM-DD-memory-edits.md]

Compare these against my memory intent. What looks accurate, what's stale, and what's missing? Then tell me exactly what to paste into a standalone conversation to fix it.
```

### Starter prompt 3 — "Should I remember this?"

After any substantive conversation (in any project or standalone), open this project and ask:

```
I just had a conversation about [topic]. Here's what came up that might be worth persisting:

[paste relevant excerpt or summary]

Based on my memory intent and current Layer 2 state, is any of this worth adding as a memory edit? If so, give me the exact text to paste into a standalone conversation.
```

---

## How It All Fits Together

```
This Project (planning + analysis)
    │
    │  Review exports, compare against intent,
    │  plan Layer 2 changes, get advice
    │
    ▼
Standalone claude.ai conversation (execution)
    │
    │  Paste skill content (memory-status or memory-assistant)
    │  Claude calls memory_user_edits to view/edit Layer 2
    │
    ▼
Claude Code session (version control)
    │
    │  Commit memory exports to claude-environment repo
    │  Push to GitHub
    │
    ▼
Back to this Project (next review cycle)
```

The project is the hub. Standalone conversations are where edits happen (because `memory_user_edits` only works on account-level memory outside of projects). Claude Code handles the git operations.

---

## Maintenance

| When | What to do |
|------|-----------|
| After each health check | Add latest exports to project knowledge (or paste into conversation) |
| When memory intent changes | Update `memory-intent.md` in your repo and refresh the project knowledge file |
| When skills or scripts are updated | Re-add updated files from your GitHub repo to the project |
| Monthly | Start a conversation with starter prompt 2 to review state |
