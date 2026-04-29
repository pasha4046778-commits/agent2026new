---
id: infra-server-pasha-beget
type: infra
title: Beget VPS — pasha.beget.tech (85.198.84.47, hostname adkutxwhda)
author: paganel
status: in_progress
created: 2026-04-29T07:40:00Z
updated: 2026-04-29T08:05:00Z
tags: [vps, beget, infra, hosting]
relates_to: [infra-fp-babichnail-online, infra-video-babichnail-online, proj-fp-babichnail-online]
---

# Beget VPS — pasha.beget.tech (adkutxwhda)

## Что это
Основной VPS Павла у Beget. Хостит сайт `fp.babichnail.online` (LMS) и `video.babichnail.online` (видеохостинг для уроков).

## Идентификация
- **Hostname:** `adkutxwhda`
- **Public DNS:** `pasha.beget.tech`
- **IP:** `85.198.84.47` (eth0, /32)
- **OS:** Ubuntu, kernel `6.8.0-110-generic`
- **CPU/RAM/Disk:** 5.8 GiB RAM (1.4 used), 77 GB / (52% занято), swap 0
- **Uptime (на момент проверки 2026-04-29 08:01 UTC):** 4 дня 23 часа

## Доступы
- **SSH:** `root@85.198.84.47` **порт 49222** (с 2026-04-29; раньше был 22, закрыт).
- **Auth method:** **ТОЛЬКО ключ.** Пароль отключён (`PasswordAuthentication no`, `PermitRootLogin without-password`).
- **Paganel-ключ:** `/root/.ssh/paganel_vps_ed25519` (приватный, на этом host'е), `paganel_vps_ed25519.pub` установлен в `authorized_keys` на VPS. В `.env` под `VPS_KEY_PATH`.
- **`.env` ключи:** `VPS_HOST`, `VPS_IP`, `VPS_USER`, `VPS_PORT=49222`, `VPS_KEY_PATH`. `VPS_PASS` удалён — пароля больше нет в системе как механизма доступа.
- known_hosts: `/root/.ssh/known_hosts_paganel` (ED25519 fingerprint 2026-04-29).
- Для подключения: `ssh -i $VPS_KEY_PATH -p $VPS_PORT $VPS_USER@$VPS_IP`.

## Что развернуто
| Сервис | Версия | Статус | Назначение |
|---|---|---|---|
| nginx | 1.24.0 (Ubuntu) | active | reverse proxy для сайтов |
| php8.3-fpm | 8.3 | active | бэкенд PHP-LMS |
| mysql-server | (см. dpkg) | active | БД `fruitpedicure` (916K) |
| mariadb | — | inactive | (заместо MySQL не используется) |
| fail2ban | sshd jail | active | анти-bruteforce SSH |
| certbot.timer | systemd | enabled | авто-renew сертификатов |

## Сайты на машине
- `/var/www/fp.babichnail.online/` — LMS, см. `infra-fp-babichnail-online`.
- `/var/www/videos/` — видеохост, см. `infra-video-babichnail-online`.
- `/var/www/html/` — стандартная nginx default page (не используется).

## TLS
- `/etc/letsencrypt/live/`:
  - `video.babichnail.online/` — есть, валидный
  - `fp.babichnail.online/` — **отсутствует**
- Тем не менее `https://fp.babichnail.online/` отвечает: фронт стоит за reverse proxy Beget (`server: nginx-reuseport/1.21.1`), TLS терминируется на нём, до origin идёт HTTP. Edge SSL.

## SSH / firewall
- `sshd -T` (после lockdown 2026-04-29): `permitrootlogin without-password`, `passwordauthentication no`, `pubkeyauthentication yes`, `port 49222`.
- Drop-in: `/etc/ssh/sshd_config.d/00-paganel.conf` (имя `00-` важно — sshd использует first-occurrence-wins, иначе дефолтный `50-cloud-init.conf` ставит `PasswordAuthentication yes`).
- Socket-activation: `ssh.socket` слушает 49222 через `/etc/systemd/system/ssh.socket.d/listen.conf`.
- `ufw`: inactive. `iptables`: цепочка fail2ban (`f2b-sshd`).
- **fail2ban** обновлён: `/etc/fail2ban/jail.d/sshd-paganel.local` ставит `port = 49222`. Reloaded.
- Bruteforce-история на старом 22 (до закрытия): 15 612 failed attempts, 857 banned. После закрытия 22 — поток должен резко упасть.

## FTP / shared-hosting интерфейс
- Beget shared-hosting username `pasha_fp` смонтирован в `/home/p/pasha/`.
- `/home/p/pasha/fp.babichnail.online/` — почти пустая болванка (16K, только public_html-каркас).
- Реальный сайт деплоится root'ом в `/var/www/`, не через FTP. То есть FTP-доступ `pasha_fp` к LIVE-коду НЕ даёт — пишет в изолированную папку.

## Open issues
- ✅ Парольный root SSH → закрыто 2026-04-29 (key-only, port 49222).
- ⏳ root-пароль ротировать (Pavel, Phase 4) — после этого артефакт окончательно не нужен.
- `fp.babichnail.online` без origin-сертификата → certbot для full TLS.
- Нет git-репо для сайтов → нет истории, нет отката.
- Нет автоматического mysqldump → потеря БД = потеря всего прогресса учеников.

## История изменений
- **2026-04-29 (Paganel):** SSH lockdown — установлен ключ `paganel_vps_ed25519`, `PasswordAuthentication no`, порт сменён 22→49222, fail2ban-jail обновлён. Прежняя парольная авторизация и порт 22 закрыты.

## Безопасность (рекомендации, оставшиеся)
1. **(Pavel, Phase 4)** Сменить root-пароль (формально не используется, но «удалить артефакт»). После этого `passwd` через мою сессию или сам в консоли Beget.
2. **(Pavel)** Свой ssh-ключ — сгенерить на ПК и прислать публичную часть; добавлю в authorized_keys как независимый канал.
3. Запустить `certbot --nginx -d fp.babichnail.online`, перевести в Beget панель «full» (а не flexible) SSL, чтобы proxy↔origin тоже шёл по TLS.
4. Поставить unattended-upgrades для security patches.
5. Завести cron для mysqldump в безопасное место (S3 / другой VPS / приватный GitHub-репо).

## Связи
- `infra-fp-babichnail-online` — LMS-сайт.
- `infra-video-babichnail-online` — видеохост.
- `proj-fp-babichnail-online` — приоритетный проект.
- `incident-2026-04-29-002-creds-via-telegram` — креды через Telegram.
