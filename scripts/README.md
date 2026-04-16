# Scripts Directory

Structured prompts for maintaining your Claude environment knowledge base. Paste these into a Claude Code session pointed at your `claude-environment` repo.

## Available Scripts

| Script | Purpose | Cadence |
|--------|---------|---------|
| `setup.md` | Initialize a new claude-environment repo | Once — initial setup |
| `health-check.md` | Full environment audit (auto or manual mode) | Biweekly / Monthly |
| `health-check-ingest.md` | Ingest manual health check zip into repo and GitHub Issue | After each manual health check |
| `health-check-ingest-prep.md` | Streamlined ingest — fill ZIP_PATH + ISSUE_NUMBER at top | After each manual health check (use with health-check-prep skill) |
| `export-memory.md` | Memory state snapshot | Biweekly or after changes |
| `memory-dream.md` | Post-health-check Layer 1 review + Layer 2 population plan | Post-health-check, as needed |
| `memory-populate.md` | Execute approved Layer 2 action list from a Dream session | After Dream session approval |
| `memory-audit.md` | Monthly memory governance — intent vs. state, action list | Monthly or when responses feel off |
| `release.md` | Cut a release — tag, GitHub Release, milestone close, Deploy comments | When ready to release batched PRs |
| `apply-release.md` | Apply a framework release to your environment | When framework tags a new release |
| `global-bootstrap.md` | Set up `~/.claude/CLAUDE.md` so environment loads in every session | Once, during initial setup |

> **Memory governance — three tiers:**
> - **Quick check:** `/memory-status` — Layer 2 view + Layer 1 pulse + inline fixes. 30 seconds.
> - **Advisory:** `/memory-assistant` — full analysis with intent coverage, conversation-aware suggestions, and prioritized recommendations. 3-5 minutes.
> - **Periodic governance:** `memory-dream.md` → `memory-populate.md` — systematic post-health-check review with population planning and version-controlled exports. 15-20 minutes.

> **Tip:** Use the `health-check-prep` skill in any session (Cowork, Claude Code, or web) to generate the issue creation command and ready-to-paste claude.ai prompt, then use `health-check-ingest-prep.md` for the ingest step.

## Usage

1. Open a Claude Code CLI session in your `claude-environment` directory
2. Paste the contents of the relevant script as your first message
3. Claude executes each step, produces output files, commits, and pushes

## Customizing the Scripts

These scripts are starting points. As you learn more about your environment, extend them:
- Add connector-specific checks to the health check
- Add project inventory steps
- Add preference export steps
- Tune the commit message format to your convention
