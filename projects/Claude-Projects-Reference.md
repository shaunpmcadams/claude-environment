# Claude Projects Reference

**Version:** 1.0.0
**Last Updated:** 2026-04-12
**Parent Doc:** `architecture/Claude-Operating-Architecture.md`

---

## What Projects Are

Claude Projects are containers that group conversations under shared context — system prompt (project instructions), uploaded knowledge files, and isolated memory scope.

## Scoping Decision Framework

### Use a Project When:
- Work spans multiple conversations over days or weeks
- You need persistent instructions across related conversations
- Context isolation matters
- Reference files should be persistently available
- The work has its own vocabulary or behavioral rules

### Use Standalone Chat When:
- Task is one-off or exploratory
- You want Claude's full general memory
- No distinct context requirements

## Project Inventory

| Project Name | Purpose | Status |
|-------------|---------|--------|
| *(populate as projects are created)* | | |

## Instructions Best Practices

- Be specific and concise
- Front-load the most important rules
- State what TO do, not just what NOT to do
- Include key vocabulary and definitions
- Version instructions locally when updating

## Relationship to Memory

- Project memory is isolated from standalone memory
- Memory edits (Layer 2) likely do not apply inside projects
- Use project instructions for rules that must apply inside projects
