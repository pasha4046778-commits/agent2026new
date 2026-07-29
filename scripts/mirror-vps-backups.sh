#!/usr/bin/env bash
# Nightly data backups (rewritten 2026-07-29 after Latvia VPS decommission).
# Old version mirrored from decommissioned VPS 85.198.84.47 — dead since 2026-05-17.
# Now everything lives on this host except the FrutPed MySQL DB (Beget shared).
#
# What it does:
#   1. FrutPed DB    — mysqldump over `ssh beget-fp` (creds from /root/secrets/fp-db-creds.php)
#   2. Vaultwarden   — online sqlite3 .backup + attachments/keys tar (no downtime)
#   3. hab-site DB   — online sqlite3 .backup
# Destinations under /root/backups/, keeps last $KEEP snapshots of each.

set -uo pipefail

LOG=/root/.openclaw/workspace/logs/vps-backups-mirror.log
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
FTS="$(date -u +%Y-%m-%dT%H-%M-%SZ)"
KEEP=30

mkdir -p /root/backups/fp-db-mirror /root/backups/vaultwarden-mirror /root/backups/hab-mirror "$(dirname "$LOG")"

ok=0
fail=0

note() { echo "[$TS] $1" >>"$LOG"; }

prune() { # keep newest $KEEP files matching pattern
  ls -1t "$1" 2>/dev/null | tail -n +$((KEEP+1)) | xargs -r rm -f
}

# --- 1. FrutPed MySQL (Beget shared) ---
DBU=$(grep DB_USER /root/secrets/fp-db-creds.php | cut -d"'" -f4)
DBN=$(grep DB_NAME /root/secrets/fp-db-creds.php | cut -d"'" -f4)
DBP=$(grep DB_PASS /root/secrets/fp-db-creds.php | cut -d"'" -f4)
FP_OUT="/root/backups/fp-db-mirror/fruitpedicure-$FTS.sql.gz"
if ssh -o BatchMode=yes -o ConnectTimeout=20 beget-fp \
     "mysqldump --single-transaction -h localhost -u '$DBU' -p'$DBP' '$DBN' 2>/dev/null | gzip" \
     >"$FP_OUT" 2>>"$LOG" && [ -s "$FP_OUT" ] \
     && gzip -t "$FP_OUT" 2>>"$LOG"; then
  note "fp-db ok ($(stat -c%s "$FP_OUT") bytes)"
  prune '/root/backups/fp-db-mirror/fruitpedicure-*.sql.gz'
  ok=$((ok+1))
else
  rm -f "$FP_OUT"
  note "fp-db FAILED"
  fail=$((fail+1))
fi

# --- 2. Vaultwarden (local docker, online snapshot) ---
VW_TMP=$(mktemp -d)
VW_OUT="/root/backups/vaultwarden-mirror/vaultwarden-$FTS.tar.gz"
if sqlite3 /var/lib/vaultwarden/db.sqlite3 ".backup '$VW_TMP/db.sqlite3'" 2>>"$LOG" \
   && cp -a /var/lib/vaultwarden/rsa_key.pem "$VW_TMP/" 2>>"$LOG" \
   && { [ ! -d /var/lib/vaultwarden/attachments ] || cp -a /var/lib/vaultwarden/attachments "$VW_TMP/"; } \
   && tar czf "$VW_OUT" -C "$VW_TMP" . 2>>"$LOG"; then
  note "vaultwarden ok ($(stat -c%s "$VW_OUT") bytes)"
  prune '/root/backups/vaultwarden-mirror/vaultwarden-*.tar.gz'
  ok=$((ok+1))
else
  rm -f "$VW_OUT"
  note "vaultwarden FAILED"
  fail=$((fail+1))
fi
rm -rf "$VW_TMP"

# --- 3. hab-site SQLite ---
HAB_OUT="/root/backups/hab-mirror/hab-$FTS.db.gz"
HAB_TMP=$(mktemp)
if sqlite3 /var/lib/hab/hab.db ".backup '$HAB_TMP'" 2>>"$LOG" && gzip -c "$HAB_TMP" >"$HAB_OUT"; then
  note "hab-db ok ($(stat -c%s "$HAB_OUT") bytes)"
  prune '/root/backups/hab-mirror/hab-*.db.gz'
  ok=$((ok+1))
else
  rm -f "$HAB_OUT"
  note "hab-db FAILED"
  fail=$((fail+1))
fi
rm -f "$HAB_TMP"

note "done: $ok ok, $fail failed"
[[ $fail -eq 0 ]] || exit 1
