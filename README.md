# Claude Environment

Your personal Claude knowledge base — version-controlled memory governance, custom skills, health checks, and environment configuration. Clone it, run setup, make it yours.

**Version:** 2.6.2

---

## What This Does

Claude has systems that shape how it responds to you: memory, skills, projects, connectors, styles, and preferences. Left unmanaged, these drift and become opaque. This repo gives you:

- **Version-controlled memory state** — timestamped exports of what Claude remembers about you, diffable over time
- **Memory skills** — check your memory health, identify what's worth remembering, and fix inaccuracies from any claude.ai session
- **Health checks** — periodic audits that snapshot your entire Claude environment
- **A structured workflow** for reviewing and improving how Claude works for you over time

## Prerequisites

- [Claude](https://claude.ai) Pro account or higher (required for memory, projects, and styles)
- [GitHub](https://github.com) account
- [Git](https://git-scm.com)
- [Claude Code](https://claude.ai/code) CLI installed
- [GitHub CLI](https://cli.github.com) (`gh`) installed and authenticated (`gh auth login`)

---

## Getting Started

### Step 1 — Create your repo

Click **Use this template** above → create a new **private** repository. Name it whatever you want (`claude-environment` is the convention).

Clone it locally:
```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git ~/Documents/Claude
cd ~/Documents/Claude
```

### Step 2 — Run setup

Open a Claude Code session in your cloned directory:
```bash
claude
```

Open `scripts/setup.md`, fill in the four variables at the top, and paste the entire file into Claude Code. Setup takes about 2 minutes — Claude configures your environment, sets up the global bootstrap, and makes the initial commit.

### Step 3 — Run your first health check

1. Open a new conversation at [claude.ai](https://claude.ai) (not inside a Project)
2. Open `scripts/health-check.md` and paste the prompt
3. Download the zip when done
4. Back in Claude Code, open `scripts/health-check-ingest-prep.md`, fill in the zip path and issue number at the top, and paste it

You now have a baseline snapshot of your Claude environment.

### Step 4 — Set up your Memory Management Project

Follow the guide at `memory/Memory-Management-Project-Setup.md`. Takes 5 minutes:
1. Create a Project in claude.ai called "Memory Management"
2. Paste the provided project description and instructions
3. Add 5 files from your GitHub repo
4. Try the first starter prompt

---

## Skills

Three custom skills in `skills/custom/`. These are structured prompts that Claude follows step-by-step.

| Skill | What it does | Time |
|-------|-------------|------|
| `/memory-status` | Quick check — Layer 2 slots used, Layer 1 accuracy pulse, inline fixes | 30 seconds |
| `/memory-assistant` | Full advisory — intent coverage analysis, conversation-aware suggestions, prioritized recommendations | 3-5 minutes |
| `/health-check-prep` | Generates the health check issue command and ready-to-paste prompt | 2 minutes |

### How to use a skill

**Option A — Cowork / Project (recommended for repeat use):**
Add the skill file to a Project's knowledge in claude.ai. Invoke by name in that project's conversations.

**Option B — Any claude.ai conversation:**
Open the skill file, copy its full contents, paste into a new standalone conversation at claude.ai. Claude follows the steps.

**Option C — Claude Code:**
Say: `Run the skill at skills/custom/memory-status.md`

> **Important:** Memory skills that read or edit Layer 2 (`/memory-status`, `/memory-assistant`) must run in a **standalone claude.ai conversation** — not inside a Project. Projects have scoped memory that doesn't reflect your account-level state.

---

## Memory Governance — Three Tiers

| Tier | Tool | When |
|------|------|------|
| **Quick check** | `/memory-status` | Anytime — "what's my state right now?" |
| **Advisory** | `/memory-assistant` | After substantive conversations — "what should I remember?" |
| **Periodic governance** | `memory-dream.md` → `memory-populate.md` | After health checks — systematic review + population planning |

### How memory governance works

Claude has two memory layers:
- **Layer 1** — auto-generated from your conversations (~100 entries, refreshed every ~24 hours, read-only)
- **Layer 2** — 30 user-editable slots, 500 characters each, managed via `memory_user_edits`

This environment adds observability (timestamped exports), correction (Layer 2 overrides for Layer 1 errors), and intent-driven population (your declared intent drives what gets persisted). See `memory/Claude-Memory-Reference.md` for the full technical reference.

---

## Scripts

Structured prompts in `scripts/`. Paste into claude.ai or Claude Code sessions.

| Script | Purpose | Cadence |
|--------|---------|---------|
| `health-check.md` | Full environment audit | Every 2-4 weeks |
| `health-check-ingest-prep.md` | Ingest health check output into repo | After each health check |
| `memory-dream.md` | Layer 1 review + Layer 2 population plan | After health checks |
| `memory-populate.md` | Execute approved Layer 2 action list | After Dream approval |
| `memory-audit.md` | Intent vs. state comparison | Monthly |
| `export-memory.md` | Memory state snapshot | Every 2-4 weeks |

See `scripts/README.md` for the full list and detailed usage.

---

## Ongoing Maintenance

| When | What to do |
|------|-----------|
| **Every 2-4 weeks** | Run health check → review with `/memory-assistant` → commit and push |
| **After substantive conversations** | Run `/memory-assistant` to identify facts worth persisting |
| **Monthly** | Run `memory-audit.md` to compare state against intent |
| **Every session** | Commit and push any changes |

---

## Directory Structure

```
├── architecture/          Environment configuration + operating architecture
├── memory/                Memory reference, system design, intent template, exports
│   └── exports/           Timestamped Layer 1 + Layer 2 snapshots
├── skills/                Skills reference + inventory
│   └── custom/            Memory and health check skills
├── scripts/               Health check, memory governance, and setup prompts
├── projects/              Projects reference + exported instructions
├── connectors/            Connectors reference + capability snapshots
├── styles/                Styles reference
├── preferences/           Preferences reference + exports
├── prompts/               Reusable prompt templates
└── CLAUDE.md              Environment instructions (auto-loaded in Claude Code)
```

---

## Feedback

Found a bug, got stuck during setup, or have a suggestion? [Open an issue](../../issues) on your repo or reach out directly.

---

## What This Is NOT

- Not a Claude Code extension or plugin — it's structured prompts and skills you paste into conversations
- Not fully automated (yet) — you run scripts and skills manually
- Not a team tool — designed for individual Claude users managing their own environment
- Not required — Claude works fine without it. This is for people who want it to work *better* over time
