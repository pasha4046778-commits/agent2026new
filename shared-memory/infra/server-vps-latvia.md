---
id: infra-server-vps-latvia
type: infra
title: VPS Latvia 155.212.230.121 — primary replacement for compromised Beget VPS
author: paganel
status: decommissioned
created: 2026-05-17T16:50:00Z
updated: 2026-07-26T09:15:00Z
tags: [vps, beget, latvia, replacement, vault, video, lms]
relates_to: [infra-server-pasha-beget, infra-vault-babichnail-online, incident-2026-05-12-006-vps-cryptominer-compromise, incident-2026-05-16-007-vps-reinfection]
implemented_by: [paganel]
---

# VPS Latvia — 155.212.230.121

## Назначение
Замена скомпрометированному VPS 85.198.84.47 (incidents #006/#007). Хостит `vault.babichnail.online` (Vaultwarden) и `video.babichnail.online` (защищённый стриминг видео-уроков для LMS на Beget shared).

## Параметры
- **IP:** `155.212.230.121` (IPv4 only публично)
- **Провайдер:** Beget, ДЦ Литва (тот же провайдер что и для скомпрометированного — но другой физический бокс, другой IP-пул)
- **Hostname:** `rulbcqsuxw`
- **CPU/RAM/Disk:** 2 ядра / 4 GB / 40 GB NVMe (fixed)
- **OS:** Ubuntu 24.04 LTS (cloud-init image, май 2026 build)
- **Создан:** Pavel'ем 2026-05-12 (как запасной до обнаружения реинфекции старого VPS)
- **Введён в эксплуатацию:** 2026-05-17 (Paganel захардил + восстановил сервисы)

## SSH
- **Порт:** `51875` (НЕ 22 — 22 закрыт в ufw и не слушается)
- **Auth:** только ключи. Password auth = OFF.
- **PermitRootLogin:** `prohibit-password` (root, но только по ключу)
- **MaxAuthTries:** 3
- **Authorized keys в `/root/.ssh/authorized_keys`:**
  - `paganel-2026-05-fresh-vps` (private у Paganel'я: `~/.ssh/paganel_vps_ed25519`)
  - `pavel-2026-05` (private у Pavel'я: `C:\Users\pasha\.ssh\id_ed25519_pavel_2026`)
- **Был, удалён:** `beget-access-key` (legacy RSA от Beget'а, generated 2026-05-12T22:26:12+03:00) — потенциальный канал реинфекции через Beget инфру, удалён 2026-05-17.

## Защита
- **ufw:** active, default deny incoming. Разрешено: 51875/tcp (SSH), 80/tcp, 443/tcp (HTTP/HTTPS), v4+v6.
- **fail2ban:** active, jail для sshd (5 фейлов → бан 1ч). Whitelist: `95.57.171.254` (Pavel ПК), `46.8.79.53` (Paganel host).
- **unattended-upgrades:** active, авто-патч security.
- **beget-agent:** УДАЛЁН (`apt purge beget-agent` после установки маркера `/tmp/please-remove-beget-agent` который требует prerm-скрипт). Это был потенциальный канал автоматического root-доступа от Beget'а — снят как часть hardening'а после incident #007.

## Сервисы
- **`vault.babichnail.online`** (Vaultwarden) — Docker `vaultwarden/server:latest`, `restart unless-stopped`, bind `127.0.0.1:8080` и `127.0.0.1:3012`, данные в `/var/lib/vaultwarden/`. ADMIN_TOKEN в `/etc/vaultwarden/admin_token` (chmod 600) и у Paganel'я в `/root/secrets/vaultwarden-latvia-admin-token.txt`. nginx reverse proxy с TLS (Let's Encrypt до 2026-08-15, auto-renew). Восстановлен из `/root/backups/vaultwarden-mirror/vaultwarden-2026-05-12T18-50-01Z.tar.gz` (бэкап до реинфекции).
- **`video.babichnail.online`** — nginx + php-fpm 8.3, файлы в `/var/www/videos/` (`www-data:www-data`). Защита через `check-access.php` (HMAC-token + expires, проверка через `hash_hmac('sha256', file|expires, VIDEO_SECRET)`). LMS-стиль URL `/file.mp4?token=X&expires=Y` rewrite'ится в `check-access.php?file=file.mp4&token=X&expires=Y`. TLS via Let's Encrypt.
- **`gdl.php`** (админ-загрузчик видео): развёрнут как файл, но `/etc/gdl/password` НЕ создан, gdown/yt-dlp не установлены — функция временно не работает. По плану: настроить при необходимости.
- **Видео файлы:** 14 mp4 (10.7 GB) в `/var/www/videos/`: `urok_01..urok_10.mp4` + 4 доп. (`mozoli_04`, `onih_plenki2`, `ustanovka_plenok1.0`, `vostonovl_uglov3`). Источник rsync'а — `/root/migration-backup/videos/` на хосте Paganel'я (бэкап до реинфекции).
- **VIDEO_SECRET:** Ротирован 2026-05-17 → `qiGYjKQ1WodZPOdiRUDg88kUuGXYPiAzQSZgsrwn` (40 chars, [a-zA-Z0-9]). Синхронен с `config.php` LMS на `pasha@sakura.beget.com:/home/p/pasha/fp.babichnail.online/public_html/config.php`. Сохранён локально у Paganel'я в `/root/secrets/video-secret-2026-05-17.txt`.

## DNS
- `vault.babichnail.online` A → `155.212.230.121` (был на `85.198.84.47`, переключён Pavel'ем 2026-05-17 16:59 UTC)
- `video.babichnail.online` A → `155.212.230.121` (тот же swap)
- `fp.babichnail.online` остаётся на Beget shared (`45.130.41.50`) — LMS-сайт не переезжал

## Резервные копии
- **Vaultwarden:** offsite зеркало через cron на Paganel host (надо обновить путь скрипта `mirror-vps-backups.sh`, сейчас идёт на старый IP 85.198.84.47:49222 — мёртвый).
- **Видео:** локальная копия на хосте Paganel `/root/migration-backup/videos/` остаётся как страховка.
- **fp DB:** на Beget shared (отдельно от Latvia), отдельная резервная цепочка.

## Fallback
Beget VNC-консоль работает (Pavel проверил 2026-05-17 перед отключением beget-agent). Если SSH ляжет — VNC останется как аварийный канал входа.

## Открытые вопросы
- [ ] Обновить `mirror-vps-backups.sh` на Paganel'е чтобы тянул с нового IP/порта (`155.212.230.121:51875`).
- [ ] Снести старый VPS `85.198.84.47` в Beget панели (опц. снапшот перед удалением).
- [ ] Алёрт «нет нового бэкапа Vaultwarden / fp-DB > 36 часов» (lesson learned из incident #007 §3).
- [ ] Сетевой мониторинг load >2.0 sustain (lesson learned из incident #007).
- [ ] gdl.php стек (yt-dlp / gdown / /etc/gdl/password) — если будем загружать новые уроки.

## Связи
- `infra-server-pasha-beget` — старый, скомпрометированный, остановлен.
- `incident-2026-05-12-006-vps-cryptominer-compromise` + `incident-2026-05-16-007-vps-reinfection` — мотивация переезда.
- `infra-vault-babichnail-online` — Vaultwarden теперь живёт тут.
- `reference_paganel_host_access` (auto-memory) — на хосте Paganel'я ключ к Latvia: `/root/.ssh/paganel_vps_ed25519`.


## 2026-07-25 — DECOMMISSIONING: санкции ЕС против Beget

2026-07-23 Beget внесён в 21-й пакет санкций ЕС (заморозка активов). Латвийский ДЦ-партнёр прекращает обслуживание, локация закрывается «в ближайшее время» без точной даты. Beget ограничивает скачивание больших объёмов (снапшоты/образы).

**Выполнено Paganel'ем 2026-07-25 (по команде Pavel'я):**
1. Полный бэкап на Paganel host (46.8.79.53, GOhost.KZ) в `/root/migration-backups/`:
   - `latvia/videos/` — 11 GB, 19 файлов, `du -sb` байт-в-байт совпадает с origin
   - `latvia/latvia-core-backup-20260725.tar.gz` — /var/lib/vaultwarden + /var/lib/hab (сняты при остановленных сервисах — консистентные SQLite), nginx sites-available, letsencrypt, hab-site.service
   - `latvia/hab-site/` — код без node_modules, включая `.env.local`
   - `frutped/` — webroot public_html + mysqldump всех 7 таблиц + родительский каталог с config.php и schema.sql (через временный token-guarded PHP-хелпер, удалён после использования)
2. Все три сервиса развёрнуты на Paganel host и проверены:
   - **gudhab.com**: nginx → hab-site systemd (Next.js, :3001), локально 307 → /ru как на проде
   - **vault.babichnail.online**: Vaultwarden docker с той же конфигурацией (127.0.0.1:8080+3012), healthy, 200
   - **video.babichnail.online**: nginx + php8.3-fpm, полный боевой тест — HMAC-токен сгенерирован вручную, файл отдался 206/Range
   - SSL-сертификаты перенесены (истекают 2026-10-15), certbot renewal (nginx authenticator) заработает после DNS
3. ffmpeg/gdown/yt-dlp на Paganel host уже стояли — gdl.php работоспособен.

**Ожидает Pavel:** 4 A-записи в панели Beget → 46.8.79.53 (gudhab.com, www.gudhab.com, vault.babichnail.online, video.babichnail.online). TTL 600, переключение бесшовное — Латвия ещё жива.

**Не затронуто санкционным отключением:** fp.babichnail.online (Beget shared RU `sakura`), DNS-сервера Beget, домены .com/.online.

## 2026-07-26 — Cutover завершён
Pavel сменил 4 A-записи в панели Beget → 46.8.79.53 (проверено: authoritative NS + 8.8.8.8). Все сервисы работают по публичному DNS с нового сервера, включая боевой видео-поток с HMAC-токеном (206/Range). Certbot auto-renew: dry-run успешен, systemd certbot.timer активен. На Латвии hab-site/nginx остановлены+disabled, vaultwarden остановлен (restart=no) — базы не менялись с момента бэкапа, потерь данных нет. VPS можно удалять из панели Beget.
