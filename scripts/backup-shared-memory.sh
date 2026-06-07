#!/usr/bin/env bash
# Daily backup of workspace content to origin (GitHub).
# Runs from cron at 23:55 UTC+5 (= 18:55 UTC).
# Covers: shared-memory/, research/, strategy/, brand/.
# Excluded (по дизайну): avatar/, backups/, exports/, logs/, и всё что в .gitignore.

set -euo pipefail

WS=/root/.openclaw/workspace
LOG=/root/.openclaw/workspace/logs/paganel-backup.log
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

PATHS=(shared-memory/ research/ strategy/ brand/)

mkdir -p "$(dirname "$LOG")"

cd "$WS"

# Stage tracked paths.
git add "${PATHS[@]}" 2>>"$LOG" || { echo "[$TS] git add failed" >>"$LOG"; exit 1; }

if git diff --cached --quiet -- "${PATHS[@]}"; then
  echo "[$TS] no workspace changes to commit" >>"$LOG"
  # Reset the index to keep it clean.
  git reset --quiet -- "${PATHS[@]}" 2>>"$LOG" || true
else
  git -c user.name="Paganel" -c user.email="paganel@bot.openclaw.local" \
      commit -m "Daily workspace backup ($TS)" >>"$LOG" 2>&1
  echo "[$TS] committed" >>"$LOG"
fi

# Try to push (handles previously unpushed commits too).
if git push origin master >>"$LOG" 2>&1; then
  echo "[$TS] push ok" >>"$LOG"
else
  echo "[$TS] push FAILED" >>"$LOG"
  exit 1
fi
