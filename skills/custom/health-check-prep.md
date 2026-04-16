# Health Check Prep — Skill

Guides you through the manual health check pre-flight and generates the ready-to-paste claude.ai prompt. Works in any session — Cowork, Claude Code, web, or desktop.

When invoked, execute these steps in order:

---

**Step 1 — Read environment config**

Read `architecture/Claude-Environment-Management-Project.md` to get:
- GitHub repo (claude-environment)
- GH_HOST value
- Health check run type

If run type is `auto`:
  Print: "Auto mode is configured — issue creation is handled directly in claude.ai. No prep needed."
  Stop.

---

**Step 2 — Issue creation command**

Get today's date in YYYY-MM-DD format.

Print the exact command for the user to run in their terminal:

If GH_HOST is set:
```
GH_HOST=[value] gh issue create \
  --repo [repo] \
  --title "audit: health check — YYYY-MM-DD" \
  --label "audit" \
  --body "Manual health check — YYYY-MM-DD"
```

If GH_HOST is not set:
```
gh issue create \
  --repo [repo] \
  --title "audit: health check — YYYY-MM-DD" \
  --label "audit" \
  --body "Manual health check — YYYY-MM-DD"
```

Print: "Run the command above in your terminal. Note the issue number it returns — you will need it in the next step."

---

**Step 3 — Prompt output**

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
