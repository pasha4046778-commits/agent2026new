---
name: reference-vps-latvia
description: "Latvia VPS 155.212.230.121 DECOMMISSIONING — Beget hit by EU 21st sanctions package 2026-07-23, Latvian DC closing; all services migrated to Paganel KZ host 46.8.79.53 on 2026-07-25"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 51b4561f-d3b0-43cf-aeab-b0ac57659f38
---

**DECOMMISSIONING.** Latvia VPS (Beget cloud, `155.212.230.121`, ssh alias `latvia`, port 51875, key-only) is being shut down: 2026-07-23 Beget попал в 21-й пакет санкций ЕС, латвийский ДЦ разрывает договор, точной даты отключения нет («в ближайшее время»), Beget троттлит массовые скачивания.

**2026-07-25 — полный перенос на Paganel host (46.8.79.53, GOhost.KZ, вне санкций):**
- Бэкапы в `/root/migration-backups/` на Paganel host: videos 11 GB (байт-в-байт сверено), core tar (Vaultwarden+hab БД сняты при остановленных сервисах), nginx/letsencrypt/systemd конфиги, FrutPed (webroot+MySQL dump 7 таблиц+config.php+schema.sql).
- Развёрнуто на Paganel host, всё проверено локально:
  - gudhab.com → systemd `hab-site` (Next.js 15, port 3001), DB `/var/lib/hab/hab.db`, секреты в `/var/www/hab-site/.env.local` (перенесён)
  - vault.babichnail.online → Vaultwarden docker (127.0.0.1:8080 + 3012), данные `/var/lib/vaultwarden`
  - video.babichnail.online → nginx + php8.3-fpm, `/var/www/videos` (жёсткие ссылки на бэкап), боевой поток с HMAC-токеном проверен (206 Range)
- VIDEO_SECRET прежний: `/root/secrets/video-secret-2026-05-17.txt`, совпадает с config.php LMS на Beget shared.
- SSL-сертификаты перенесены (до 2026-10-15), renewal через certbot nginx-плагин заработает после смены DNS.

**2026-07-26 — cutover ЗАВЕРШЁН:** Pavel сменил 4 A-записи (gudhab.com, www.gudhab.com, vault, video → 46.8.79.53), проверено на authoritative NS и 8.8.8.8. Боевой видео-поток с HMAC-токеном работает через публичный DNS, внешний трафик идёт на новый сервер. Certbot auto-renew проверен (dry-run OK; из интерактивного шелла нужен PATH с /usr/sbin, systemd-таймер работает сам). На Латвии все сервисы остановлены и disabled (hab-site, nginx, vaultwarden) — базы не менялись с бэкапа, потерь нет. fp.babichnail.online (Beget shared RU, sakura) не затронут. Pavel может удалить латвийский VPS из панели.

После отключения ДЦ ssh-алиас `latvia` мёртв. Related: [[reference-paganel-host-access]]
