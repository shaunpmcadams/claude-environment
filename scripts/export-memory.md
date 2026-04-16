# Memory Export — Structured Prompt

Paste the block below into a **claude.ai conversation** (not Claude Code). The `memory_user_edits` tool and `userMemories` block are only available in claude.ai sessions.

After claude.ai writes the export files, open a Claude Code session in your `claude-environment` directory and run:
```
git add memory/exports/ && git commit -m "audit: memory export — YYYY-MM-DD" && git push
```

```
Export my complete Claude memory state as two files.

**File 1: Memory Edits (Layer 2)**
- Use memory_user_edits tool with command "view" to retrieve all current edits
- Save the full output as: memory/exports/edits/YYYY-MM-DD-memory-edits.md
- Include total edit count and remaining capacity in the file header

**File 2: Auto-Generated Memories (Layer 1)**
- Write out the userMemories block verbatim — do not summarize or paraphrase
- Save as: memory/exports/auto/YYYY-MM-DD-auto-memories.md
- Include export timestamp in the file header

After saving both files, run git diff to show what changed since the last export. Do not commit — that step happens in Claude Code.
```
