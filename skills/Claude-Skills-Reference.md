# Claude Skills Reference

**Version:** 1.0.0
**Last Updated:** 2026-04-12
**Parent Doc:** `architecture/Claude-Operating-Architecture.md`

---

## What Skills Are

Skills are instruction files (SKILL.md) in Claude's compute environment that guide how Claude performs specific tasks. They contain best practices, procedures, constraints, and quality standards.

## How Skills Work

- **Triggering:** Automatic (matched against request) or manual
- **Reading:** Claude reads SKILL.md on demand via `view` tool — not pre-loaded
- **Scope:** Session-scoped. Must be re-read each new conversation.

## Directory Structure

```
/mnt/skills/
├── public/          Anthropic-provided core skills
├── organization/    Organization-configured skills
├── user/            User-uploaded skills
├── examples/        Community/example skills
└── private/         Private skills
```

All directories are read-only.

## Overlap Between Scopes

Some skills exist in multiple scopes (e.g., `frontend-design` in public, organization, and user). Claude may read any version. Specify the path explicitly if you want a specific version.

## Creating Custom Skills

Use `/mnt/skills/examples/skill-creator/SKILL.md`:
1. Define purpose → 2. Draft SKILL.md → 3. Test → 4. Iterate → 5. Deploy

### Custom Skill Candidates

- **Six Ds Workflow Skill** — Enforce Discover → Dream → Design → Develop → Deploy → Drive
- **ARIA Development Skill** — Coordinator/specialist patterns and state management
- **Moser Document Skill** — Brand-compliant document generation
- **Daily Activity Summary Skill** — Six-category template with VP-level summary

## Maintenance

| Activity | Frequency |
|----------|-----------|
| Audit inventory | Monthly or when starting substantial work |
| Check for new/removed skills | Each health check |
| Evaluate custom skill candidates | When repeating procedural instructions |
