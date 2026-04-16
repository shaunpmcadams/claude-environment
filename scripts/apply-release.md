# Apply Release — Structured Prompt

Paste into a **Claude Code session** opened in your `claude-environment` directory to apply a new release from the upstream `claude-environment` repo.

**Fill in the target version before pasting:**

```
TARGET_VERSION: vX.Y.Z      # e.g. v2.9.0 — or leave blank to apply latest
```

---

```
Apply a claude-environment release to this installation. Use the value below.

TARGET_VERSION: [TARGET_VERSION]

## What this does

This script updates framework-owned files in this repo to match the target release.
It will NOT touch any user-owned content (memory exports, personal CLAUDE.md
customizations, project instructions, preferences exports, or personal prompts).

Execute each step in order. Stop and report clearly if any step fails.

---

## Step 1 — Resolve target version

If TARGET_VERSION is blank or "latest":
  Run: gh release view --repo shaunpmcadams/claude-environment --json tagName --jq '.tagName'
  Use the returned tag as the target version.

Otherwise use TARGET_VERSION as given.

Print: "Applying [TARGET_VERSION] to this installation."

---

## Step 2 — Show release notes

Run: gh release view [TARGET_VERSION] --repo shaunpmcadams/claude-environment --json body --jq '.body'

Print the release notes so the user can see what changed before any files are written.

---

## Step 3 — Fetch and write framework-owned files

For each file in the framework-owned list below, fetch it from the release tag and
write it to the corresponding local path.

Fetch command per file:
  gh api "repos/shaunpmcadams/claude-environment/contents/[PATH]?ref=[TARGET_VERSION]" --jq '.content' | base64 -d > [PATH]

Framework-owned files to update:
- README.md
- scripts/README.md
- scripts/setup.md
- scripts/apply-release.md
- scripts/health-check.md
- scripts/health-check-ingest.md
- scripts/health-check-ingest-prep.md
- scripts/export-memory.md
- scripts/memory-dream.md
- scripts/memory-populate.md
- scripts/memory-audit.md
- architecture/Claude-Operating-Architecture.md
- architecture/Claude-Environment-Management-Project.md
- memory/Claude-Memory-Reference.md
- memory/Claude-Memory-System-Design.md
- memory/Memory-Management-Project-Setup.md
- memory/memory-intent-template.md
- connectors/Claude-Connectors-Reference.md
- preferences/Claude-Preferences-Reference.md
- projects/Claude-Projects-Reference.md
- prompts/Claude-Prompts-Reference.md
- styles/Claude-Styles-Reference.md
- skills/Claude-Skills-Reference.md
- skills/custom/memory-status/SKILL.md
- skills/custom/memory-status.md
- skills/custom/memory-assistant/SKILL.md
- skills/custom/memory-assistant.md
- skills/custom/health-check-prep/SKILL.md
- skills/custom/health-check-prep.md

If a file returns a 404 (not present in this release), skip it and note it in the report.
Create any missing parent directories before writing files.

User-owned paths — NEVER read or overwrite:
- CLAUDE.md
- memory/memory-intent.md
- memory/exports/ (entire directory)
- connectors/snapshots/ (entire directory)
- preferences/exports/ (entire directory)
- projects/instructions/ (entire directory)
- prompts/patterns/ (entire directory)
- prompts/system-prompts/ (entire directory)
- prompts/templates/ (entire directory)
- skills/Skills-Inventory.md

---

## Step 4 — Update version in CLAUDE.md

Read CLAUDE.md and find the line containing the version string
(formatted as **Version:** X.Y.Z or **Framework version:** ... vX.Y.Z).
Replace the version number with [TARGET_VERSION] (strip the leading 'v' if the
existing format does not include it).

---

## Step 5 — Commit

Stage all changed files:
  git add -A

Commit:
  git commit -m "update: apply claude-environment [TARGET_VERSION]"

---

## Step 6 — Report

Print a summary:

APPLY RELEASE COMPLETE
─────────────────────────────────────
Applied:   [TARGET_VERSION]
─────────────────────────────────────
Updated:   N files
Skipped:   N files (not present in this release)
Protected: user-owned paths not touched
─────────────────────────────────────
Next: push to your remote (git push or your standard push command)
─────────────────────────────────────
```
