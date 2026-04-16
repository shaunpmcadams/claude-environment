# Claude Styles Reference

**Version:** 1.0.0
**Last Updated:** 2026-04-12
**Parent Doc:** `architecture/Claude-Operating-Architecture.md`

---

## What Styles Are

Claude's style feature customizes how Claude writes — tone, structure, formality. Distinct from preferences (broader behavior) and project instructions (scoped to a project).

## Active Styles

| Style Name | Purpose | Default? |
|-----------|---------|----------|
| *(none documented yet)* | | |

## Design Principles

- Be specific about what you want
- Provide examples when possible
- Don't overload a single style
- Test across different content types

## Relationship to Other Areas

- **Preferences** set the floor, **styles** add the flavor
- **Project instructions** take precedence for project-scoped work
- Individual **prompts** can override the active style
