# Setup — Structured Prompt

Paste into a **Claude Code session** opened in your freshly cloned `claude-environment` directory.

**Fill in the four variables below before pasting:**

```
GITHUB_USERNAME:       [your GitHub username]
GITHUB_INSTANCE:       github.com
GH_HOST_VALUE:                           # leave blank for github.com; set to hostname for enterprise (e.g. moser-consulting.ghe.com)
HEALTH_CHECK_RUN_TYPE: manual            # auto = GitHub MCP available in claude.ai / manual = no GitHub MCP
```

---

```
Initialize this claude-environment repo. Use the values below — do not prompt me for them.

GITHUB_USERNAME: [GITHUB_USERNAME]
GITHUB_INSTANCE: [GITHUB_INSTANCE]
GH_HOST_VALUE: [GH_HOST_VALUE]
HEALTH_CHECK_RUN_TYPE: [HEALTH_CHECK_RUN_TYPE]

Execute each step in order. Stop and report clearly if any step fails.

**Step 0: Preflight**
Run: gh auth status
If this fails, stop immediately and print:
  "gh is not authenticated. Run 'gh auth login' and retry setup."
Confirm we are in the correct claude-environment directory (run: pwd).

**Step 1: Create directory structure**
Create the following directories. Add a .gitkeep file to each leaf directory.
  memory/exports/edits/
  memory/exports/auto/
  skills/custom/
  projects/instructions/
  connectors/snapshots/
  preferences/exports/
  prompts/system-prompts/
  prompts/templates/
  prompts/patterns/
  styles/
  scripts/

**Step 2–3: Reference docs and CLAUDE.md**
All reference docs and CLAUDE.md are already present in this repository. Proceed to Step 4.

**Step 4: Write environment configuration**
In architecture/Claude-Environment-Management-Project.md, fill in the Environment Configuration table:
  - "GitHub instance" value → GITHUB_INSTANCE
  - "GitHub repo (claude-environment)" value → GITHUB_USERNAME/claude-environment
  - "GH_HOST value" value → GH_HOST_VALUE (leave blank if empty)
  - "Health check run type" value → HEALTH_CHECK_RUN_TYPE

**Step 5: Create .gitignore**
Create .gitignore with:
  .DS_Store
  *.local
  files.zip
  files-review/
  *.pdf

**Step 6: Set up global bootstrap**
Determine the absolute path to CLAUDE.md in the current directory (use `pwd`/CLAUDE.md).
Check if ~/.claude/CLAUDE.md exists.
  - If it does not exist: create it with content: @[absolute-path-to-CLAUDE.md]
  - If it exists but does not contain that path: append the line
  - If it already contains it: print "Global bootstrap already configured"

**Step 7: Initial commit and push**
git add .
git commit -m "add: initialize claude-environment"
git push

If push fails (no upstream set), run:
git push -u origin main

**Step 8: Print next steps**
Print the following summary:

---
Setup complete.

Your claude-environment is initialized. Run: pwd to confirm your local path.
GitHub repo: GITHUB_USERNAME/claude-environment
Health check run type: HEALTH_CHECK_RUN_TYPE

Next step — run your first health check:
1. Open claude.ai in a new conversation
2. Paste the prompt from scripts/health-check.md
[If HEALTH_CHECK_RUN_TYPE is manual, add:]
3. Download the zip when done
4. Return here and paste scripts/health-check-ingest.md, filling in the issue number and zip path
---
```
