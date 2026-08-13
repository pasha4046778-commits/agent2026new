---
name: project-backup-system
description: "Nightly backup layout after 2026-07-29 rewrite — FP mysqldump via beget-fp, local Vaultwarden/hab snapshots; GitHub push of workspace broken since ≥2026-07-01, waiting for new PAT from Pavel"
metadata: 
  node_type: memory
  type: project
  originSessionId: 51b4561f-d3b0-43cf-aeab-b0ac57659f38
  modified: 2026-08-13T15:38:14.565Z
---

Backup layout (rewritten 2026-07-29 after Latvia decommission):

- Cron 19:25 UTC `scripts/mirror-vps-backups.sh` (rewritten): (1) FrutPed MySQL via `ssh beget-fp mysqldump` — creds parsed from `/root/secrets/fp-db-creds.php` (extracted from backed-up config.php, chmod 600); (2) Vaultwarden online `sqlite3 .backup` + rsa_key/attachments tar; (3) hab.db online snapshot. Destinations `/root/backups/{fp-db-mirror,vaultwarden-mirror,hab-mirror}/`, keeps 30, log `logs/vps-backups-mirror.log`. Old version had pointed at dead VPS 85.198.84.47 — FP dumps were missing 2026-05-12→07-29.
- Cron 18:55 UTC `scripts/backup-shared-memory.sh` — daily git commit+push of workspace to github.com/pasha4046778-commits/agent2026new. **FIXED 2026-07-29**: push had been failing since ≥2026-07-01 (empty `/root/.git-credentials`); Pavel issued fine-grained PAT `paganel-backup` (repos agent2026new + fp-site, Contents R/W, **expires ~2027-07-29 — remind Pavel to renew in early July 2027**). Stored as `https://pasha4046778-commits:<PAT>@github.com` in `/root/.git-credentials` (chmod 600, helper=store); backlog pushed, master==origin. The PAT also covers fp-site — можно возобновить зеркало кода FrutPed.

- **2026-08-13: агентная память включена в GitHub-автосохранение** (просьба Павла — «добавить тему ИИ Креатор в автосохранение»). backup-shared-memory.sh теперь перед коммитом зеркалит `/root/.claude/projects/-root--openclaw-workspace/memory/` → `shared-memory/claude-memory/` (rsync -a --delete), и оно попадает в ночной пуш (path shared-memory/ уже отслеживается). Т.е. вся моя память (MEMORY.md + заметки, вкл. диалоги по темам) бэкапится в приватный репо agent2026new каждую ночь. Прогнал вручную — закоммичено и запушено.

**Why:** off-host copy of shared-memory exists only via that GitHub push. Related: [[reference-vps-latvia]], [[feedback-ii-creator-save-dialogs]]
