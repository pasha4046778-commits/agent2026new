---
id: infra-vault-babichnail-online
type: infra
title: Vaultwarden — vault.babichnail.online
author: paganel
status: in_progress
created: 2026-05-05T18:50:00Z
updated: 2026-05-05T18:50:00Z
tags: [vaultwarden, secrets, hosting, docker]
relates_to: [infra-server-pasha-beget, proj-shared-memory-hub]
implemented_by: []
---

# Vaultwarden — vault.babichnail.online

## Что это
Self-hosted password & secret manager (Bitwarden-compatible API), реализован в Vaultwarden (Rust). Заменяет Telegram как канал для передачи и хранения секретов между Pavel'ом и агентами (Amber, Paganel).

Установлен 2026-05-05 как **Stage 0** плана private agent hub (см. `src-2026-05-05-codbash-dashboard.md` и связанный диалог с Amber). Первый шаг до полного hub'а.

## Где живёт
- **URL:** https://vault.babichnail.online
- **Origin VPS:** `pasha.beget.tech` / `85.198.84.47` (см. `infra-server-pasha-beget`)
- **DNS:** прямая A-запись на VPS (НЕ через Beget proxy, в отличие от fp/www).
- **TLS:** Let's Encrypt от certbot, auto-renew через `certbot.timer`. Cert до 2026-08-03.
- **Docker container:** `vaultwarden/server:latest`, имя `vaultwarden`, restart unless-stopped.
- **Persistent data:** `/var/lib/vaultwarden/` на VPS (db.sqlite3 + rsa_key.pem).
- **Bind:** контейнер слушает только `127.0.0.1:8080` (web) и `127.0.0.1:3012` (websocket). Снаружи доступ только через nginx reverse proxy.
- **nginx vhost:** `/etc/nginx/sites-enabled/vault.babichnail.online`.

## Конфигурация контейнера
Env vars:
- `DOMAIN=https://vault.babichnail.online`
- `SIGNUPS_ALLOWED=true` (на момент установки; **закрыть после регистрации Pavel'а** в значение `false`)
- `ADMIN_TOKEN` — random 48-char, plain text. Хранится в `/etc/vaultwarden/admin_token` (chmod 600 root). Используется для доступа к `/admin` панели (управление пользователями, settings).
- `WEBSOCKET_ENABLED=true` (для live-sync между клиентами)
- `LOG_LEVEL=warn`

## Доступ
- **Master-password** Pavel'а — НЕ хранится на сервере (E2E-encryption), только Pavel его знает.
- **Recovery email:** `pasha4046778@gmail.com`.
- **Admin token:** в `/etc/vaultwarden/admin_token` на VPS. Прочитать: `ssh -p 49222 root@85.198.84.47 cat /etc/vaultwarden/admin_token`.
- **Admin panel URL:** https://vault.babichnail.online/admin (после ввода admin_token).

## Бэкап
- **Уровень 1 (на VPS):** ежедневно в 23:50 UTC+5 (= 18:50 UTC) скрипт `/root/scripts/backup-vaultwarden.sh` делает tar.gz всего `/var/lib/vaultwarden/` в `/root/backups/vaultwarden/vaultwarden-<TS>.tar.gz`. Retention 14 дней, log `/var/log/vaultwarden-backup.log`.
- **Уровень 2 (offsite):** ежедневно в 00:25 UTC+5 (= 19:25 UTC) скрипт `/root/.openclaw/workspace/scripts/mirror-vps-backups.sh` на хосте Paganel'а тянет rsync'ом и `/root/backups/vaultwarden-mirror/`. Retention без ограничения (файлы по ~10K).
- **Что внутри backup'а:** SQLite DB зашифрована мастер-паролями пользователей (E2E). RSA ключ + конфиг. Без master-password сами по себе бэкапы расшифровать нельзя.

## Восстановление
```bash
# На VPS
docker stop vaultwarden
mv /var/lib/vaultwarden /var/lib/vaultwarden.broken
tar -xzf vaultwarden-<TS>.tar.gz -C /var/lib/
docker start vaultwarden
```
Проверка: https://vault.babichnail.online/alive должно вернуть ISO timestamp.

## Что положили в Vault (planned migration baseline)
После регистрации Pavel'а — мигрируем туда:
- `GITHUB_TOKEN` (memory hub) — заменит запись в `.env` на ссылку на Vault.
- GitHub fine-grained PAT для `fp-site` (текущее место: `/root/secrets/github_token_fp_site.txt`).
- VPS root password (формально мёртвый артефакт, но не плохо иметь резерв).
- FrutPed FTP (`pasha_fp` после ротации).
- Beget panel login.
- TipTop Pay credentials (`TIPTOP_PUBLIC_ID`, `TIPTOP_API_KEY`, `CP_API_KEY`) — сейчас в config.php.
- gdl.php password — сейчас в `/etc/gdl/password`.
- DB password fruitpedicure (`fp_user`) — сейчас в config.php.
- Anthropic API keys, OpenAI, прочие из `.env`.

## Open issues / improvements
- Argon2-hashed admin_token (сейчас plain) — Vaultwarden рекомендует. Можно сделать через `docker exec vaultwarden vaultwarden hash`.
- `SIGNUPS_ALLOWED=true` пока открыто — **закрыть** сразу после регистрации Pavel'а.
- Geofence / IP-allowlist на nginx (опционально, для жёсткой защиты `/admin`).
- 2FA TOTP — в Vaultwarden встроено, **обязательно** включить Pavel'у в настройках аккаунта.

## Связи
- `infra-server-pasha-beget` — VPS, на котором стоит контейнер.
- `meta/writing-rules.md` §8.1 — правила работы с кредами; вынесем в Vault.
- `incident-2026-04-29-002-creds-via-telegram` — мотивация (Vaultwarden → нет повторения).
- `incident-2026-04-29-004-gdl-password-leak` — мотивация.
- `proj-shared-memory-hub` — Stage 0 пути к private agent control plane.
