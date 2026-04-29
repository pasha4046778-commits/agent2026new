---
id: infra-server-pasha-beget
type: infra
title: Beget VPS — pasha.beget.tech (85.198.84.47)
author: paganel
status: in_progress
created: 2026-04-29T07:40:00Z
updated: 2026-04-29T07:40:00Z
tags: [vps, beget, infra, hosting]
relates_to: [infra-fp-babichnail-online, proj-fp-babichnail-online]
---

# Beget VPS — pasha.beget.tech

## Что это
Основной VPS Павла у провайдера Beget. На нём живёт инфраструктура сайтов и видеохост.

## Доступы
- **Hostname:** `pasha.beget.tech`
- **IP:** `85.198.84.47`
- **SSH user:** `root`
- **Auth:** пароль (логин/пароль в `.env` под ключами `VPS_USER` / `VPS_PASS`).
- **Пароль здесь не хранится.** Никогда не дублировать значение в этот файл, в commit, в логи, в Telegram.

## Что на сервере (известно)
- `/var/www/videos/` — каталог с видеоуроками для `video.babichnail.online` (см. локальную ноту `memory/2026-04-23.md`).
- `nginx` (текущий конфиг переписывает запросы на отсутствующий `check-access.php`, из-за чего прямые ссылки на видео отдают 404 — известный issue).
- DNS для `video.babichnail.online` начинал резолвиться, HTTPS не поднят — статус на 2026-04-23.

## Что НЕИЗВЕСТНО (надо уточнить у Павла)
- Какие ещё сайты/сервисы хостятся на этом VPS.
- Связь между этим VPS и shared hosting `pasha.beget.tech / pasha_fp` (см. `infra-fp-babichnail-online`): один и тот же физический сервер с двумя интерфейсами (root SSH + панель Beget) или разные машины?
- Бэкапы VPS (есть ли, куда, как часто).
- Snapshots / план восстановления.

## Open issues
- nginx переписывает на `check-access.php` → 404 на видео.
- HTTPS для `video.babichnail.online` не поднят.

## Безопасность (рекомендации Paganel — open)
- **Перейти на SSH-ключи**, отключить парольный root-логин (`PasswordAuthentication no` в sshd_config).
- **Сменить root-пароль** — текущий шёл через Telegram, считать скомпрометированным.
- Поставить fail2ban / unattended-upgrades если ещё не стоят.
- Отдельный non-root пользователь для повседневной работы, root только sudo.

## Связи
- `infra-fp-babichnail-online` — сайт, физически живущий через этот же `pasha.beget.tech`.
- `proj-fp-babichnail-online` — приоритетный проект.
- `memory/2026-04-23.md` — локальная нота про видеохост (gitignored).
