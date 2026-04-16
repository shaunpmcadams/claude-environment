# Memory Intent — Template

**Last Updated:** YYYY-MM-DD
**Purpose:** Declare what Claude should and should not retain about you across sessions.
Use as a baseline for auditing memory drift and guiding memory edit decisions.

---

## Identity — Always Retain

*(Role, organization, background — the facts that anchor who you are)*

## Working Model — Always Retain

*(Development tools, repo structure, workflow patterns — how you work with Claude)*

## Frameworks and IP — Always Retain

*(Methodologies, proprietary frameworks, intellectual property —
things that must not be misattributed or forgotten)*

## Technical Context — Always Retain

*(Tool stack, integrations, accounts — the technical environment Claude operates in)*

## Behavioral Preferences — Via Profile Preferences or Styles, Not Memory

*(Communication style, formatting rules, interaction patterns —
these belong in Profile Preferences or Styles settings, not memory edits)*

## Current Focus — Track for Audit; Prefer Project Instructions or Project Knowledge

*(Active projects and priorities — useful for audit comparison, but this content usually
belongs in Project Instructions or Project Knowledge rather than memory edits.
The memory or project summary may also capture this naturally within the relevant scope.
Only add a manual memory edit if important context is consistently dropped.)*

## Never Retain

*(Sensitive information, transient status, credentials — explicit exclusions)*

---

## Memory Edit Allocation

**Current edits (___ used; treat your total as a practical budget —
Anthropic has not published hard limits):**

| # | Content | Category |
|---|---------|----------|
| | | |

**Suggested budget by category:**

| Category | Suggested edits | Purpose |
|----------|----------------|---------|
| Identity & standards | 1–2 | Who you are, branding |
| Working model | 2–3 | How you work with Claude |
| Behavioral nudges | 2–3 | Methodology enforcement |
| Corrections | 2–3 | Override inaccurate memory summary entries |
| Exclusions | 1–2 | Topics to keep out |
| Reserved | Remainder | Future needs |

---

## Audit Protocol

During each memory review, compare current memory state against this intent:

1. **Coverage** — Are the "Always Retain" items present in the memory summary?
2. **Accuracy** — Are retained facts correct and current?
3. **Exclusions** — Has anything from "Never Retain" appeared in memory?
4. **Drift** — Has the memory summary dropped anything important since the last review?
5. **Action** — Add memory edits only for items the memory summary cannot retain reliably.
