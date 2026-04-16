# Health Check — Structured Prompt

Before running, check your `health_check_run_type` in `architecture/Claude-Environment-Management-Project.md`.

---

## Auto Mode (`run type: auto`)

*Requires GitHub MCP connector in claude.ai.*

Paste the prompt block below into a **claude.ai conversation**. Claude will create the GitHub issue, run all steps, post results as comments, and close the issue. No downloads, no Claude Code step required.

---

## Manual Mode (`run type: manual`)

*Works for any deployment. No GitHub MCP needed.*

**Step 1:** Create a GitHub issue in your `claude-environment` repo:
- Title: `audit: health check — YYYY-MM-DD`
- Note the issue number

**Step 2:** Paste the prompt block below into a **claude.ai conversation**, replacing `ISSUE_NUMBER` with your issue number.

**Step 3:** claude.ai will offer a zip download when done. Save it — you'll need the path for the next step.

**Step 4:** Open a Claude Code session in `~/Documents/Claude/` and paste the prompt from `scripts/health-check-ingest.md`, replacing `ISSUE_NUMBER` and `ZIP_PATH`.

---

## Prompt Block

```
Run the Claude environment health check for issue ISSUE_NUMBER. Execute each step in order.

**Step 1: Memory Export**
- Export current memory edits (Layer 2) using the memory_user_edits tool with command "view"
- Write out the auto-generated memories (Layer 1 / userMemories block) verbatim
- Output as: YYYY-MM-DD-memory-edits.md
- Output as: YYYY-MM-DD-auto-memories.md

**Step 2: Skills Audit**
- List all SKILL.md files present under /mnt/skills/ across all scopes (public, organization, user, examples, private)
- Compare against the current skills/Skills-Inventory.md baseline
- Report: new skills found, skills removed, skills that appear changed
- Output updated Skills-Inventory.md if changes are found

**Step 3: Connector Status**
- Run tool_search for each connector listed in connectors/Claude-Connectors-Reference.md
- Report: reachable (yes/no), tool count, any new or missing tools vs. last snapshot
- Output updated YYYY-MM-DD-connectors.md snapshot if changes found
- Output updated Claude-Connectors-Reference.md if status changed

**Step 4: Model Check**
- Report: model name, model version, knowledge cutoff date, today's date

**Step 5: Summary**
- Total changes found by area (memory, skills, connectors)
- List of all output files produced
- Draft CHANGELOG.md entry for today
- Suggested commit message using the audit: prefix

**Output instructions:**

If run type is AUTO (GitHub MCP available):
- Create a GitHub issue titled "audit: health check — YYYY-MM-DD" in the claude-environment repo
- Post each step result as a separate comment on the issue
- Close the issue with the Step 5 summary as the final comment

If run type is MANUAL:
- Produce all output files as a zip download
- Name files clearly so the ingest script can place them by naming convention
- Do not attempt to write to the filesystem directly
```
