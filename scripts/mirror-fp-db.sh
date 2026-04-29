#!/usr/bin/env bash
# Mirror fp.babichnail.online DB dumps from VPS to this host.
# Pulls all new *.sql.gz from VPS:/root/backups/fp.babichnail.online/db/
# into local mirror, keeps all (files are tiny).

set -euo pipefail

LOCAL_DIR=/root/backups/fp-db-mirror
LOG=/root/.openclaw/workspace/logs/fp-db-mirror.log
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

mkdir -p "$LOCAL_DIR" "$(dirname "$LOG")"

# Pull via rsync over SSH (idempotent, only new/changed files transferred)
if rsync -az --partial \
    -e "ssh -i /root/.ssh/paganel_vps_ed25519 -p 49222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/root/.ssh/known_hosts_paganel" \
    'root@85.198.84.47:/root/backups/fp.babichnail.online/db/*.sql.gz' \
    "$LOCAL_DIR/" >>"$LOG" 2>&1; then
  COUNT=$(ls -1 "$LOCAL_DIR"/*.sql.gz 2>/dev/null | wc -l)
  echo "[$TS] mirror ok, $COUNT files locally" >> "$LOG"
else
  echo "[$TS] mirror FAILED" >> "$LOG"
  exit 1
fi
