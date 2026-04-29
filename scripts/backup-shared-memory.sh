#!/usr/bin/env bash
# Daily backup of shared-memory/ to origin (GitHub).
# Runs from cron at 23:55 UTC+5 (= 18:55 UTC).
# Touches ONLY shared-memory/ — no other workspace paths.

set -euo pipefail

WS=/root/.openclaw/workspace
LOG=/root/.openclaw/workspace/logs/paganel-backup.log
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

mkdir -p "$(dirname "$LOG")"

cd "$WS"

# Stage shared-memory only.
git add shared-memory/ 2>>"$LOG" || { echo "[$TS] git add failed" >>"$LOG"; exit 1; }

if git diff --cached --quiet -- shared-memory/; then
  echo "[$TS] no shared-memory changes to commit" >>"$LOG"
  # Reset the index to keep it clean (in case other paths were already staged by someone).
  git reset --quiet -- shared-memory/ 2>>"$LOG" || true
else
  git -c user.name="Paganel" -c user.email="paganel@bot.openclaw.local" \
      commit -m "Daily shared-memory backup ($TS)" >>"$LOG" 2>&1
  echo "[$TS] committed" >>"$LOG"
fi

# Try to push (handles previously unpushed commits too).
if git push origin master >>"$LOG" 2>&1; then
  echo "[$TS] push ok" >>"$LOG"
else
  echo "[$TS] push FAILED" >>"$LOG"
  exit 1
fi
