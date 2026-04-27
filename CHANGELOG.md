# Claude Environment — Change Log

---

## v2.11.0 — 2026-04-27

### MINOR: Layer 2 automation — daily health check via cron + Claude-in-Chrome

Applied from claude-operating-framework v3.1.0.

- `scripts/auto-health-check.md`: new orchestration prompt — 8-step automated health check (create issue → open claude.ai via Claude-in-Chrome → submit prompt → wait for response → click download button → ingest ZIP → post to GitHub issue → commit + push). Reads REPO and GH_HOST from architecture config at runtime. Works for github.com and GitHub Enterprise.
- `scripts/health-check-cron.sh`: new cron wrapper — restores macOS PATH, reads config, validates prerequisites, logs to `.health-check.log`, calls `claude --dangerously-skip-permissions`.
- `README.md`: Automated Health Check section added with setup instructions.

**To activate:** `chmod +x scripts/health-check-cron.sh` → `crontab -e` → add `0 9 * * * /full/path/to/scripts/health-check-cron.sh`.

---

## v2.10.0 — 2026-04-19

### Layer 2 memory cross-platform sync

- Add `memory/layer2-current.md` mirror file (auto-refreshed by memory skills)
- Import `layer2-current.md` into `CLAUDE.md` via `@`-syntax for Claude Code access
- Update `memory-status` and `memory-assistant` skills to emit sync content
- Update `export-memory.md` to produce 3rd file (`layer2-current.md` overwrite)
