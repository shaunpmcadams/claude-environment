# Claude Environment Management — Project Reference

**Version:** 2.1.0
**Last Updated:** 2026-04-12
**Repository:** claude-environment (local git repo)
**Project Type:** Claude Code cloud — ongoing environment stewardship
**Purpose:** Govern the local Claude knowledge base, keep all reference docs current, detect and respond to changes in Claude's systems, and continuously improve how you work with Claude.

---

## Git Strategy

### Commit Conventions

| Prefix | Use |
|--------|-----|
| `audit:` | Health check results and periodic exports |
| `update:` | Reference doc content updates |
| `add:` | New files, knowledge areas, prompts |
| `fix:` | Corrections |
| `detect:` | Changes detected in Claude's systems |
| `archive:` | Retiring outdated content |
| `auto:` | Commits from automation |

---

## Environment Configuration

| Setting | Value |
|---------|-------|
| GitHub instance | github.com |
| GitHub repo (claude-environment) | [your-github-username]/claude-environment |
| GH_HOST value | *(blank — personal github.com)* |
| Health check run type | manual |

**Run types:**
- `auto` — GitHub MCP connector available in claude.ai; health check creates issue, posts comments, closes it directly
- `manual` — No GitHub MCP in claude.ai; health check produces zip download; Claude Code ingest step posts to issue and commits files

*Update here if your connector setup changes.*

---

## Global Bootstrap

`~/.claude/CLAUDE.md` (User instructions scope) loads in every Claude Code session across all projects. A single `@` import makes this environment available regardless of working directory:

```
@~/Documents/Claude/CLAUDE.md
```

Set up automatically during `scripts/setup.md`. Verify with `/memory` — the environment CLAUDE.md should appear in the loaded files list.

---

## Automation Architecture

### Layer 1: Structured Prompts (Current)
Paste health check prompt into Claude Code session. Claude audits, produces files, commits, pushes.

### Layer 2: Session Automation (Near-term)
Claude Code session with CLAUDE.md encoding the full protocol. Say "run the health check" and Claude knows what to do.

### Layer 3: Autonomous Pipeline (Future)
n8n workflow calling Claude API on schedule, auto-committing, sending Slack summary.

---

## Health Check Protocol

### Light Pass (Every 2 Weeks)
1. Memory export — edits + auto-memories, diff against previous
2. Skills audit — compare /mnt/skills/ against inventory
3. Connector status — tool_search for each service
4. Model check — name, version, cutoff
5. Commit with `audit:` prefix

### Full Audit (Monthly)
Light pass plus: preferences, styles, project inventory, prompt library, context window assessment, architecture review.

---

## Project Rules

1. Commit after every meaningful change
2. Use conventional commit prefixes
3. Exports are commits, not just files
4. Update "Last Updated" date when modifying reference docs
5. Don't delete — git tracks history
6. Push after every session
7. Review automated commits

---

## Roadmap

### Phase 1: Foundation
- [x] Initialize git repo
- [x] Populate initial files
- [ ] Run first health check

### Phase 2: Populate and Stabilize (Weeks 2–4)
- [ ] Export and commit current preferences
- [ ] Export and commit first auto-memories snapshot
- [ ] Document all active projects
- [ ] Resolve open questions about memory scoping

### Phase 3: Automation (Months 1–2)
- [ ] Establish biweekly health check cadence
- [ ] Build custom skills for your workflow

### Phase 4: Autonomous Pipeline (Months 2–3)
- [ ] Design n8n workflow for autonomous health checks
- [ ] Implement automated export → commit → push pipeline
