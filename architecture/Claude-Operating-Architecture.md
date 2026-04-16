# Claude Operating Architecture

**Version:** 1.0.0
**Last Updated:** 2026-04-12
**Purpose:** Master reference for how all aspects of the Claude working environment fit together — what goes where, how the pieces interact, and the governing principles for organizing Claude-related knowledge.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Directory Structure](#2-directory-structure)
3. [Knowledge Areas](#3-knowledge-areas)
4. [Information Flow](#4-information-flow)
5. [Placement Rules](#5-placement-rules)
6. [Maintenance Cadence](#6-maintenance-cadence)
7. [Open Questions](#7-open-questions)

---

## 1. Overview

Claude's usefulness compounds over time, but only if the inputs that shape its behavior are deliberately managed. Those inputs span several distinct systems — memory, skills, projects, connectors, styles, preferences, prompts, and the architectural decisions that tie them together.

This document serves as the governing map. It defines what each knowledge area covers, where its reference materials live, how information flows between areas, and the rules for deciding where a new piece of information should be stored.

The local directory structure is the single source of truth for understanding and managing the Claude environment. It mirrors — but does not replace — the server-side systems that Anthropic operates. Its purpose is visibility, versioning, and intentional management of what would otherwise be opaque and scattered.

---

## 2. Directory Structure

```
claude-environment/
├── architecture/
├── memory/
│   └── exports/
│       ├── edits/
│       └── auto/
├── skills/
│   └── custom/
├── projects/
│   └── instructions/
├── connectors/
│   └── snapshots/
├── styles/
├── preferences/
│   └── exports/
├── prompts/
│   ├── system-prompts/
│   ├── templates/
│   └── patterns/
└── scripts/
```

---

## 3. Knowledge Areas

### Architecture
- **Scope:** The meta-layer. Design decisions about the overall Claude operating model.
- **Runtime Impact:** Indirect. Human-facing reference, not injected into Claude's context.

### Memory
- **Scope:** Claude's three-layer memory system — auto-generated memories, memory edits, and conversation context.
- **Runtime Impact:** Direct. Layers 1 and 2 are injected into every conversation's system prompt.

### Skills
- **Scope:** Skill files that guide how Claude performs specific tasks.
- **Runtime Impact:** Direct. Read from `/mnt/skills/` on demand.

### Projects
- **Scope:** Claude Projects as organizational units — instructions, knowledge files, scoped memory.
- **Runtime Impact:** Direct. Project instructions and files injected into every conversation within that project.

### Connectors
- **Scope:** MCP server integrations and external tool connections.
- **Runtime Impact:** Direct. Connected MCP servers expose tools Claude can call.

### Styles
- **Scope:** Claude's configurable writing style feature.
- **Runtime Impact:** Direct. Selected styles modify output behavior.

### Preferences
- **Scope:** Standing instructions about tone, formatting, feature usage, and behavior.
- **Runtime Impact:** Direct. Injected into system prompt as "user preferences."

### Prompts
- **Scope:** Reusable prompts, templates, and interaction patterns.
- **Runtime Impact:** Indirect. User-supplied at runtime.

---

## 4. Information Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude's Runtime Context                   │
│                                                               │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐  ┌────────────┐ │
│  │ Memory   │  │ Skills   │  │ Projects  │  │ Connectors │ │
│  │ (L1 + L2)│  │ (/mnt/)  │  │ (instruct │  │ (MCP tools)│ │
│  │          │  │          │  │  + files)  │  │            │ │
│  └──────────┘  └──────────┘  └───────────┘  └────────────┘ │
│  ┌──────────┐  ┌──────────┐                                  │
│  │ Styles   │  │ Prefs    │                                  │
│  │          │  │          │                                  │
│  └──────────┘  └──────────┘                                  │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐    │
│  │ Conversation Context (Layer 3)                        │    │
│  │ ← User messages, tool results, uploaded files,        │    │
│  │   pasted prompts                                      │    │
│  └──────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘

        ▲                           ▲
        │                           │
   Server-side                 User-supplied
   (Anthropic manages)         (You manage locally)
```

---

## 5. Placement Rules

| If the information is... | It goes in... |
|--------------------------|---------------|
| A fact about you that should persist across all conversations | **Memory edit** (Layer 2) |
| A behavioral rule or formatting preference | **Preferences** (settings) |
| A reusable prompt or template | **Prompts directory** |
| Specific to a single project's context | **Project instructions or uploaded file** |
| About what an integration can do | **Connectors reference** |
| A writing style definition | **Styles** (settings) |
| A record of what skills are available | **Skills inventory** |
| A design decision about how to organize any of the above | **Architecture directory** |

### Conflict Resolution

1. **Most specific scope wins.** Project-specific → project, not global memory.
2. **Persistence trumps convenience.** Memory edit or project instruction over hoping auto-memory retains it.
3. **Explicit beats implicit.** Written preference > inferred from conversation history.
4. **Local backup is always appropriate.** Export server-side state to your repo.

---

## 6. Maintenance Cadence

| Activity | Frequency |
|----------|-----------|
| Memory export and diff | Every 2–4 weeks |
| Skills inventory audit | Monthly or when starting substantial build work |
| Project inventory review | When creating/archiving projects |
| Connector status check | When integrations change or break |
| Preferences export | When changing preferences |
| Prompt library review | Quarterly |
| Architecture review | Quarterly |

---

## 7. Open Questions

1. **What happens to standalone memory when a conversation is moved into a project?** Anthropic does not document this. Needs empirical testing.
2. **Do memory edits (Layer 2) apply inside project conversations?** System instructions suggest they are scoped to non-project conversations only. Needs verification.
3. **How does the memory import feature interact with existing auto-generated memories?** Unclear whether they merge or overwrite.
4. **Can custom skills be persisted across sessions in claude.ai?** Lifecycle not well documented.
