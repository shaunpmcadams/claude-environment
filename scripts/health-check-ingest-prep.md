# Health Check Ingest (Prep) — Structured Prompt

Paste into a **Claude Code session** in your `claude-environment` directory.  
Fill in the two variables at the top before pasting.

```
ZIP_PATH:     [full path to downloaded zip, e.g. ~/Downloads/health-check-2026-04-14.zip]
ISSUE_NUMBER: [issue number created during health check prep]
```

---

```
Process the health check zip for issue ISSUE_NUMBER from ZIP_PATH.

Read the environment configuration from architecture/Claude-Environment-Management-Project.md to get:
- GitHub repo (claude-environment)
- GH_HOST value (blank for github.com, hostname for enterprise)

Then execute in order. Stop and report clearly if any step fails.

**Step 1: Unzip**
Unzip ZIP_PATH to a temporary directory (/tmp/health-check-ingest/).

**Step 2: Post each file as a GitHub Issue comment**
Post each file as a separate comment on issue ISSUE_NUMBER in the claude-environment repo.
Use GH_HOST if set: GH_HOST=[value] gh issue comment ISSUE_NUMBER --repo [repo] --body "..."
One comment per file. Use the filename as the comment header.

**Step 3: Place files in correct repo locations**
Use these naming conventions to determine placement:
- *memory-edits* → memory/exports/edits/
- *auto-memories* → memory/exports/auto/
- Skills-Inventory.md → skills/
- *connectors.md* (snapshot) → connectors/snapshots/
- Claude-Connectors-Reference.md → connectors/
- HEALTH-CHECK-SUMMARY* → repo root

If a file already exists at the destination, overwrite it.

**Step 4: Close the issue**
Post a closing comment: "Health check complete. Files committed to repo."
If GH_HOST is set: GH_HOST=[value] gh issue close ISSUE_NUMBER --repo [repo]
Else: gh issue close ISSUE_NUMBER --repo [repo]

**Step 5: Commit and push**
git add all placed files
git commit -m "audit: health check — YYYY-MM-DD"
If GH_HOST is set: git -c credential.helper='!gh auth git-credential' push
Else: git push

**Step 6: Clean up**
Delete the temporary directory /tmp/health-check-ingest/
Delete ZIP_PATH
```
