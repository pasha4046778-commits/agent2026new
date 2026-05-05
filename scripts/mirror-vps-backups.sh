#!/usr/bin/env bash
# Mirror VPS backups to this host (offsite copy).
# Sources on VPS:
#   /root/backups/fp.babichnail.online/db/*.sql.gz       (DB dumps)
#   /root/backups/vaultwarden/vaultwarden-*.tar.gz       (Vaultwarden snapshots)
# Local destinations:
#   /root/backups/fp-db-mirror/
#   /root/backups/vaultwarden-mirror/

set -euo pipefail

LOG=/root/.openclaw/workspace/logs/vps-backups-mirror.log
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

mkdir -p \
  /root/backups/fp-db-mirror \
  /root/backups/vaultwarden-mirror \
  "$(dirname "$LOG")"

SSH_OPTS="-i /root/.ssh/paganel_vps_ed25519 -p 49222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/root/.ssh/known_hosts_paganel"

ok=0
fail=0

mirror() {
  local src=$1
  local dst=$2
  local label=$3
  if rsync -az --partial -e "ssh $SSH_OPTS" "root@85.198.84.47:$src" "$dst/" >>"$LOG" 2>&1; then
    local count
    count=$(ls -1 "$dst"/* 2>/dev/null | wc -l)
    echo "[$TS] $label ok, $count files locally" >> "$LOG"
    ok=$((ok+1))
  else
    echo "[$TS] $label FAILED" >> "$LOG"
    fail=$((fail+1))
  fi
}

mirror '/root/backups/fp.babichnail.online/db/*.sql.gz' /root/backups/fp-db-mirror      'fp-db'
mirror '/root/backups/vaultwarden/vaultwarden-*.tar.gz' /root/backups/vaultwarden-mirror 'vaultwarden'

[[ $fail -eq 0 ]] || exit 1
