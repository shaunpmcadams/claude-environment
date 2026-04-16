---
name: health-check-prep
description: >
  Generates the GitHub issue creation command and ready-to-paste health check prompt for
  manual-mode Claude environment health checks. Reads your environment configuration to
  determine run mode, constructs the correct gh CLI command (with GH_HOST if enterprise),
  and outputs the complete health check prompt with your issue number pre-filled.
  Use this skill when the user wants to run a health check, start an environment audit,
  prepare for a health check, or asks about health check prep. Also trigger on "health check",
  "run health check", "environment audit", "health check prep", "start health check",
  "audit my environment", "run the audit". This skill works in any session — Cowork,
  Claude Code, web, or desktop.
---

# Health Check Prep

Guides you through the manual health check pre-flight and generates the ready-to-paste claude.ai prompt. Works in any session.

## Step 1 — Read Environment Config

Read `architecture/Claude-Environment-Management-Project.md` to get:
- GitHub repo (claude-environment)
- GH_HOST value
- Health check run type

If run type is `auto`:
  Print: "Auto mode is configured — issue creation is handled directly in claude.ai via the GitHub MCP connector. No prep needed."
  Stop here.

If run type is `manual`: proceed to Step 2.

## Step 2 — Issue Creation Command

Get today's date in YYYY-MM-DD format.

Print the exact command for the user to run in their terminal:

**If GH_HOST is set:**
```
GH_HOST=[value] gh issue create \
  --repo [repo] \
  --title "audit: health check — YYYY-MM-DD" \
  --label "audit" \
  --body "Manual health check — YYYY-MM-DD"
```

**If GH_HOST is not set:**
```
gh issue create \
  --repo [repo] \
  --title "audit: health check — YYYY-MM-DD" \
  --label "audit" \
  --body "Manual health check — YYYY-MM-DD"
```

Print: "Run the command above in your terminal. Note the issue number it returns — you will need it in the next step."

## Step 3 — Prompt Output

Ask: "What issue number was created?"

Once the user provides the issue number:

1. Read the prompt block from `scripts/health-check.md` (the content inside the triple-backtick block at the bottom of the file)
2. Replace every occurrence of `ISSUE_NUMBER` with the provided number

Print the complete filled-in prompt between clear separator lines:

```
─────────────────────────────────────────
[full prompt block with issue number substituted]
─────────────────────────────────────────
```

Print:
"Copy the prompt above and paste it into a new claude.ai conversation.
When claude.ai finishes, download the zip file it produces.
Then open a Claude Code session in your claude-environment directory and paste `scripts/health-check-ingest-prep.md` with ZIP_PATH and ISSUE_NUMBER filled in at the top."
