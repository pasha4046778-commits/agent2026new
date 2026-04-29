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
- **SSH:** root@85.198.84.47 порт 22
- **Auth method:** пароль (значение в `.env` под `VPS_USER` / `VPS_PASS`). НИКОГДА не коммитить в git.
- known_hosts entry для Paganel: `/root/.ssh/known_hosts_paganel` (ED25519 fingerprint 2026-04-29).

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
- `sshd -T`: `permitrootlogin yes`, `passwordauthentication yes`, `pubkeyauthentication yes`, `port 22`.
- `ufw`: inactive. `iptables`: добавлена цепочка fail2ban (`f2b-sshd` REJECT).
- **fail2ban (sshd jail) на 2026-04-29 08:01:**
  - текущих банов: 2 (2.57.121.112, 92.118.39.236)
  - всего забанено: 857
  - всего failed login attempts: **15 612**
  - активный bruteforce — постоянный фон. Ключи + отключение пароля = маст.

## FTP / shared-hosting интерфейс
- Beget shared-hosting username `pasha_fp` смонтирован в `/home/p/pasha/`.
- `/home/p/pasha/fp.babichnail.online/` — почти пустая болванка (16K, только public_html-каркас).
- Реальный сайт деплоится root'ом в `/var/www/`, не через FTP. То есть FTP-доступ `pasha_fp` к LIVE-коду НЕ даёт — пишет в изолированную папку.

## Open issues
- Парольный root SSH + 15K bruteforce-попыток → закрыть парольную аутентификацию, перейти на ключ.
- `fp.babichnail.online` без origin-сертификата → certbot для full TLS.
- Нет git-репо для сайтов → нет истории, нет отката.
- Нет автоматического mysqldump → потеря БД = потеря всего прогресса учеников.

## Безопасность (рекомендации)
1. SSH-ключ Paganel → `~/.ssh/authorized_keys`, `PasswordAuthentication no`, `PermitRootLogin prohibit-password` (или `without-password`).
2. После — сменить root-пароль (на случай, если Telegram-копию утянули).
3. Запустить `certbot --nginx -d fp.babichnail.online`, перевести в Beget панель «full» (а не flexible) SSL, чтобы proxy↔origin тоже шёл по TLS.
4. Поставить unattended-upgrades для security patches.
5. Завести cron для mysqldump в безопасное место.

## Связи
- `infra-fp-babichnail-online` — LMS-сайт.
- `infra-video-babichnail-online` — видеохост.
- `proj-fp-babichnail-online` — приоритетный проект.
- `incident-2026-04-29-002-creds-via-telegram` — креды через Telegram.
