# Claude Connectors Reference

**Version:** 1.0.0
**Last Updated:** 2026-04-12
**Parent Doc:** `architecture/Claude-Operating-Architecture.md`

---

## Active Connectors

| Connector | MCP Server URL | Session Scope | Tool Count | Status |
|-----------|---------------|--------------|------------|--------|
| **Slack** | `https://mcp.slack.com/mcp` | claude.ai + Claude Code | 12 (claude.ai) / 14 (Claude Code) | ✅ Operational |
| **Excalidraw** | `https://mcp.excalidraw.com/mcp` | claude.ai + Claude Code | 1 via tool_search + 1 native | ✅ Operational |
| **Atlassian** | `https://mcp.atlassian.com/v1/sse` | claude.ai only | 0 | ⚠️ Connected, tools not resolving |
| **Atlassian Rovo** | `https://mcp.atlassian.com/v1/mcp` | claude.ai only | 0 | ⚠️ Connected, tools not resolving |
| **n8n** | `https://agents.coretech.ms/mcp-server/http` | claude.ai only | 0 | ⚠️ Connected, tools not resolving |
| **Lucid** | `https://mcp.lucid.app/mcp` | ❓ Unknown | 0 | ❌ Not resolving in any session |

*Last audited: 2026-04-12. See `connectors/snapshots/2026-04-12-connectors.md` for full probe log.*

## Established Patterns

### Slack Canvas Creation
Use `slack_create_canvas` with fully composed content. Create new canvas when errors accumulate rather than patching.

### Tool Discovery
Always call `tool_search` before using any connector tool.

### Slack DMs
Use `slack_search_users` to find user ID, then use user_id as channel_id.

## Known Limitations

- Compute sandbox has no network — connectors work through MCP layer only
- Cannot create drafts in Slack Connect channels
- One draft per Slack channel
- MCP tools cannot be called from artifacts
- Tools may be rate-limited
