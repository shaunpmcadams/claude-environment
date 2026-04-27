#!/bin/bash
# health-check-cron.sh
# Daily automated health check for your claude-environment repo.
# Reads REPO and GH_HOST from architecture/Claude-Environment-Management-Project.md
# at runtime — no hardcoded values.
#
# Setup:
#   chmod +x scripts/health-check-cron.sh
#   crontab -e  →  add: 0 9 * * * /full/path/to/scripts/health-check-cron.sh
#
# macOS note: cron requires Full Disk Access for bash/cron in
#   System Settings → Privacy & Security → Full Disk Access
#
# Log: ~/Documents/Claude/.health-check.log

set -euo pipefail

# --- Configuration (edit if your env lives somewhere other than ~/Documents/Claude) ---
WORKING_DIR="$HOME/Documents/Claude"
# -------------------------------------------------------------------------------------

LOG_FILE="$WORKING_DIR/.health-check.log"
PROMPT_FILE="$WORKING_DIR/scripts/auto-health-check.md"
ARCH_FILE="$WORKING_DIR/architecture/Claude-Environment-Management-Project.md"

# Restore PATH stripped by cron
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$PATH"

# Read REPO from architecture config
REPO=$(grep "GitHub repo" "$ARCH_FILE" \
  | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3); print $3}' \
  | head -1)
export REPO

# Read and normalize GH_HOST from architecture config
GH_HOST_RAW=$(grep "GH_HOST value" "$ARCH_FILE" \
  | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3); print $3}' \
  | head -1)

if echo "$GH_HOST_RAW" | grep -qiE "blank|github\.com|standard|\(|^$"; then
  export GH_HOST=""
else
  export GH_HOST="$GH_HOST_RAW"
fi

# Log header
{
  echo ""
  echo "================================================"
  echo "[$(date)] Starting automated health check"
  echo "[$(date)] Repo: $REPO | GH_HOST: ${GH_HOST:-github.com (default)}"
} >> "$LOG_FILE"

# Preflight checks
if ! command -v claude &>/dev/null; then
  echo "[$(date)] ERROR: claude CLI not found in PATH" >> "$LOG_FILE"
  exit 1
fi

if [ ! -f "$PROMPT_FILE" ]; then
  echo "[$(date)] ERROR: Prompt not found: $PROMPT_FILE" >> "$LOG_FILE"
  exit 1
fi

if [ -z "$REPO" ]; then
  echo "[$(date)] ERROR: Could not read REPO from $ARCH_FILE" >> "$LOG_FILE"
  exit 1
fi

cd "$WORKING_DIR" || exit 1

# Run
claude --dangerously-skip-permissions -p "$(cat "$PROMPT_FILE")" >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

echo "[$(date)] Health check finished — exit code: $EXIT_CODE" >> "$LOG_FILE"
exit $EXIT_CODE
