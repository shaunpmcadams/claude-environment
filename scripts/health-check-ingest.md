# Health Check Ingest — Structured Prompt

**Manual mode only.** Paste into a **Claude Code session** in `~/Documents/Claude/` after downloading the zip from a manual health check run in claude.ai.

Replace `ISSUE_NUMBER` with the issue number you created before running the health check.
Replace `ZIP_PATH` with the full path to the downloaded zip file (e.g. `~/Downloads/files.zip`).

> **Note:** The zip filename from claude.ai may vary. Use whatever path your browser downloaded it to.

```
Process the health check zip from ZIP_PATH for issue ISSUE_NUMBER.

Read the environment configuration from architecture/Claude-Environment-Management-Project.md to get:
- GitHub repo (claude-environment)
- GH_HOST value (blank for github.com, hostname for enterprise)

Then execute in order:

**Step 1: Unzip**
Unzip ZIP_PATH to a temporary directory.

**Step 2: Post each file as a GitHub Issue comment**
Post each file from the zip as a separate comment on issue ISSUE_NUMBER in the claude-environment repo.
Use GH_HOST if set: GH_HOST=[value] gh issue comment ISSUE_NUMBER --repo [repo] --body "..."
One comment per file. Use the filename as the comment header.

**Step 3: Place files in correct repo locations**
Use these naming conventions to determine placement:
- *memory-edits* → memory/exports/edits/
- *auto-memories* → memory/exports/auto/
- Skills-Inventory.md → skills/
- *connectors.md (snapshot)* → connectors/snapshots/
- Claude-Connectors-Reference.md → connectors/
- HEALTH-CHECK-SUMMARY* → repo root

If a file already exists at the destination, overwrite it.

**Step 4: Close the issue**
Post a closing comment: "Health check complete. Files committed to repo."
Close the issue.

**Step 5: Commit and push**
git add all placed files
git commit -m "audit: health check — YYYY-MM-DD"
git push

**Step 6: Clean up**
Delete the temporary unzip directory.
Delete ZIP_PATH.
```
