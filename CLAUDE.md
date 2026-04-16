# CLAUDE.md — Claude Environment

**Version:** 2.8.0

This is the private repo that holds the actual state of your Claude environment — populated reference docs, memory exports, skills inventories, connector status, preferences, and all personal configuration.

## What This Repo Is

Your personal Claude knowledge base. Everything here is specific to your account, your integrations, and your workflow. This is production — the source of truth for how Claude works for you.

## Key Rules

- This repo is PRIVATE — it contains personal memory exports, preferences, and account-specific details
- Commit after every health check, export, or configuration change
- Use conventional commit prefixes: audit:, update:, add:, fix:, detect:, archive:, auto:
- Never delete files — remove via commit so git retains history
- Push after every session

## Session Split: claude.ai vs. Claude Code

| Task | Run in |
|------|--------|
| Memory export (Layer 1 + 2) | claude.ai conversation |
| Skills audit (`/mnt/skills/`) | claude.ai conversation |
| Connector tool_search | claude.ai conversation |
| Model check | claude.ai conversation |
| Git commit + push | Claude Code CLI |

## Health Check Protocol

When asked to "run the health check":
1. Open a **claude.ai conversation** and paste the prompt from `scripts/health-check.md`
2. Claude exports memory, audits skills, checks connectors, reports model info, produces files
3. Open a **Claude Code session** in this directory and run:
   `git add . && git commit -m "audit: health check — YYYY-MM-DD" && git push`

## Structure

```
architecture/    Operating architecture + environment management project doc
memory/          Memory reference + system design + periodic exports
skills/          Skills reference + populated inventory
projects/        Projects reference + exported instructions
connectors/      Connectors reference + capability snapshots
styles/          Styles reference + definitions
preferences/     Preferences reference + exports
prompts/         Prompts reference + library
scripts/         Health check and export prompts
```

