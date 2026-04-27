# Automated Health Check

Executed by the daily cron job via `health-check-cron.sh`.
Run all steps in order. Stop and log clearly if any step fails.

This script is parameterized — it reads your repo and GitHub host from
`architecture/Claude-Environment-Management-Project.md` so no values need
to be hardcoded here. Works for both github.com and GitHub Enterprise.

---

## Step 0 — Read configuration

Read the following values from `architecture/Claude-Environment-Management-Project.md`:

```bash
ARCH="$HOME/Documents/Claude/architecture/Claude-Environment-Management-Project.md"
DATE=$(date +%Y-%m-%d)

REPO=$(grep "GitHub repo" "$ARCH" \
  | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3); print $3}' \
  | head -1)

GH_HOST_RAW=$(grep "GH_HOST value" "$ARCH" \
  | awk -F'|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3); print $3}' \
  | head -1)

# Normalize: blank / "(leave blank..." / "github.com" entries → empty string
if echo "$GH_HOST_RAW" | grep -qiE "blank|github\.com|standard|\(|^$"; then
  GH_HOST=""
else
  GH_HOST="$GH_HOST_RAW"
fi

echo "Repo:    $REPO"
echo "GH_HOST: ${GH_HOST:-github.com (default)}"
echo "Date:    $DATE"
```

Use `$REPO`, `$GH_HOST`, and `$DATE` in every subsequent step.

For GitHub Enterprise (non-empty GH_HOST), prefix all `gh` commands with
`GH_HOST=$GH_HOST` and all `git push` commands with
`GH_HOST=$GH_HOST git -c credential.helper='!gh auth git-credential'`.

For github.com (empty GH_HOST), use `gh` and `git push` directly.

---

## Step 1 — Create today's GitHub issue

```bash
if [ -n "$GH_HOST" ]; then
  ISSUE_URL=$(GH_HOST=$GH_HOST gh issue create \
    --title "audit: health check — $DATE" \
    --body "Automated daily health check." \
    --repo "$REPO")
else
  ISSUE_URL=$(gh issue create \
    --title "audit: health check — $DATE" \
    --body "Automated daily health check." \
    --repo "$REPO")
fi

ISSUE_NUMBER=$(echo "$ISSUE_URL" | grep -oE '[0-9]+$')
echo "Issue #$ISSUE_NUMBER: $ISSUE_URL"
```

---

## Step 2 — Mark download watch start time

```bash
touch /tmp/hc-watch-start
```

---

## Step 3 — Open claude.ai and submit health check

Use Claude-in-Chrome to:

1. Navigate to `https://claude.ai/new`
2. Wait for the message input (contenteditable div) to appear
3. Inject the health check prompt via JavaScript — substitute `$ISSUE_NUMBER`
   and `$DATE` with their actual values before injecting:

```javascript
const prompt = `[paste the prompt block below with substitutions applied]`;
const el = document.querySelector('[contenteditable="true"]');
el.focus();
el.textContent = prompt;
el.dispatchEvent(new InputEvent('input', {
  bubbles: true, cancelable: true, inputType: 'insertText', data: prompt
}));
```

4. Find and click the Send button:

```javascript
const btns = Array.from(document.querySelectorAll('button'));
const send = btns.find(b =>
  b.getAttribute('aria-label') === 'Send message' ||
  b.textContent.trim() === 'Send message'
);
send ? (send.click(), 'submitted') : 'send button not found'
```

**Prompt block to inject** (substitute ISSUE_NUMBER and DATE before injecting):

```
Run the Claude environment health check for issue ISSUE_NUMBER. Execute each step in order.

**Step 1: Memory Export**
- Export current memory edits (Layer 2) using the memory_user_edits tool with command "view"
- Write out the auto-generated memories (Layer 1 / userMemories block) verbatim
- Output as: DATE-memory-edits.md
- Output as: DATE-auto-memories.md

**Step 2: Skills Audit**
- List all SKILL.md files present under /mnt/skills/ across all scopes (public, organization, user, examples, private)
- Compare against the current skills/Skills-Inventory.md baseline
- Report: new skills found, skills removed, skills that appear changed
- Output updated Skills-Inventory.md if changes are found

**Step 3: Connector Status**
- Run tool_search for each connector listed in connectors/Claude-Connectors-Reference.md
- Report: reachable (yes/no), tool count, any new or missing tools vs. last snapshot
- Output updated DATE-connectors.md snapshot if changes found
- Output updated Claude-Connectors-Reference.md if status changed

**Step 4: Model Check**
- Report: model name, model version, knowledge cutoff date, today's date

**Step 5: Summary**
- Total changes found by area (memory, skills, connectors)
- List of all output files produced
- Draft CHANGELOG.md entry for today
- Suggested commit message using the audit: prefix

**Output instructions:**
Produce all output files as a zip download named health-check-DATE.zip.
Name files clearly so the ingest script can place them by naming convention.
Do not attempt to write to the filesystem directly.
```

---

## Step 3b — Wait for response to finish, then click the download button

**Important:** claude.ai presents a download button at the end of the response.
The ZIP does not appear in Downloads until this button is clicked.

Poll the active claude.ai tab every 20 seconds (up to 10 minutes) until the
response finishes streaming, then click the download button:

```javascript
// Check if response is still streaming
const stopBtn = document.querySelector('button[aria-label="Stop response"]');
const isStreaming = !!stopBtn;

// Find download button/link
const els = Array.from(document.querySelectorAll('a[href], button'));
const dlEl = els.find(el =>
  el.textContent.toLowerCase().includes('download') ||
  (el.href && (el.href.includes('.zip') || el.href.includes('health-check')))
);

JSON.stringify({ isStreaming, downloadFound: !!dlEl, href: dlEl?.href || null })
```

Once `isStreaming` is false and `downloadFound` is true, click the element:

```javascript
const els = Array.from(document.querySelectorAll('a[href], button'));
const dlEl = els.find(el =>
  el.textContent.toLowerCase().includes('download') ||
  (el.href && (el.href.includes('.zip') || el.href.includes('health-check')))
);
dlEl ? (dlEl.click(), 'clicked: ' + (dlEl.href || dlEl.textContent.trim()))
     : 'download button not found — check page manually'
```

If JavaScript cannot find the download element, use Claude-in-Chrome `find`
to search for "download zip button" and click it by ref ID.

---

## Step 4 — Wait for ZIP in Downloads

Poll `~/Downloads/` every 30 seconds for up to 15 minutes for a `.zip` file
newer than `/tmp/hc-watch-start`. The ZIP only appears after the download
button is clicked in Step 3b.

```bash
ZIP_PATH=""
for i in $(seq 1 30); do
  FOUND=$(find ~/Downloads -maxdepth 1 -name "*.zip" \
    -newer /tmp/hc-watch-start 2>/dev/null | head -1)
  if [ -n "$FOUND" ]; then
    ZIP_PATH="$FOUND"
    echo "ZIP found: $ZIP_PATH"
    break
  fi
  echo "Waiting for ZIP... attempt $i/30 ($(date +%H:%M:%S))"
  sleep 30
done

if [ -z "$ZIP_PATH" ]; then
  echo "ERROR: ZIP not found after 15 minutes."
  echo "Check: was the download button clicked in Step 3b?"
  exit 1
fi
```

---

## Step 5 — Ingest: unzip and place files

```bash
rm -rf /tmp/health-check-ingest/
mkdir -p /tmp/health-check-ingest/
unzip "$ZIP_PATH" -d /tmp/health-check-ingest/
```

Place each extracted file into the correct repo location
(`REPO_DIR=$HOME/Documents/Claude`):

| File pattern | Destination |
|---|---|
| `*memory-edits*` | `memory/exports/edits/` |
| `*auto-memories*` | `memory/exports/auto/` |
| `Skills-Inventory.md` | `skills/` |
| `*connectors.md` (snapshot) | `connectors/snapshots/` |
| `Claude-Connectors-Reference.md` | `connectors/` |
| Any remaining `.md` files | repo root |

Overwrite if a file already exists at the destination.

---

## Step 6 — Post files to GitHub issue and close it

```bash
REPO_DIR="$HOME/Documents/Claude"
INGEST_DIR=$(find /tmp/health-check-ingest -mindepth 1 -maxdepth 1 -type d | head -1)
[ -z "$INGEST_DIR" ] && INGEST_DIR="/tmp/health-check-ingest"

for FILE in "$INGEST_DIR"/*.md; do
  [ -f "$FILE" ] || continue
  FILENAME=$(basename "$FILE")
  if [ -n "$GH_HOST" ]; then
    GH_HOST=$GH_HOST gh issue comment "$ISSUE_NUMBER" \
      --repo "$REPO" --body "### $FILENAME

$(cat "$FILE")"
  else
    gh issue comment "$ISSUE_NUMBER" \
      --repo "$REPO" --body "### $FILENAME

$(cat "$FILE")"
  fi
done

if [ -n "$GH_HOST" ]; then
  GH_HOST=$GH_HOST gh issue close "$ISSUE_NUMBER" --repo "$REPO" \
    --comment "Health check complete. Files committed to repo."
else
  gh issue close "$ISSUE_NUMBER" --repo "$REPO" \
    --comment "Health check complete. Files committed to repo."
fi
```

---

## Step 7 — Commit and push

```bash
cd "$HOME/Documents/Claude"
git add memory/ skills/ connectors/ *.md 2>/dev/null || true
git commit -m "auto: health check — $DATE

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"

if [ -n "$GH_HOST" ]; then
  GH_HOST=$GH_HOST git -c credential.helper='!gh auth git-credential' push
else
  git push
fi
```

---

## Step 8 — Clean up

```bash
rm -rf /tmp/health-check-ingest/
rm -f /tmp/hc-watch-start
echo "Health check complete: $(date)"
```
