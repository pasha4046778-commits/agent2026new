---
id: todo-register
type: meta
title: Shared Memory todo register
author: paganel
status: in_progress
created: 2026-04-21T00:00:00Z
updated: 2026-04-29T07:10:00Z
tags: [meta, todo, register]
relates_to: [proj-shared-memory-hub]
---

# Shared Memory Todo

## Готово
- [x] Развернуть базовую структуру: `daily/`, `projects/`, `sources/`, `ideas/`, `people/`, `decisions.md`, `todo.md`
- [x] Подключить Paganel к hub'у, развести identity (`PAGANEL_IDENTITY.md`)
- [x] Подтвердить названия двух приоритетных проектов: `fp.babichnail.online` и сам Shared Memory Hub
- [x] Завести project-стержни в `projects/` под оба проекта
- [x] Добавить новые папки v2: `infra/`, `incidents/`, `meta/`
- [x] Frontmatter-схема под soft-graph: `meta/record-schema.md`
- [x] Шаблоны: `infra/TEMPLATE.md`, `incidents/TEMPLATE.md`, `meta/TEMPLATE.md`
- [x] Backup `shared-memory/` в приватный GitHub: чистый origin, credential helper, ежедневный cron 23:55 UTC+5 (см. `infra/backup-shared-memory.md`)
- [x] Security: GitHub PAT убран из `.git/config` (incident `2026-04-29-001` в `logs/security_log.json`)

## В работе
- [ ] Operational regulament — `meta/writing-rules.md` v0.1.3 (на ревью у Павла)
- [x] Заполнить `projects/fp-babichnail-online.md` реальным контекстом (на 2026-04-29)
- [x] `infra/server-pasha-beget.md`, `infra/fp-babichnail-online.md` — заполнены реальным состоянием по результатам read-only осмотра 2026-04-29

## FrutPed action items (ждут ок Павла)
- [x] Установить SSH-ключ Paganel на VPS, отключить `PasswordAuthentication`, поменять `PermitRootLogin` на `without-password` ✅ 2026-04-29
- [x] Сменить SSH-порт с 22 на 49222, обновить fail2ban ✅ 2026-04-29
- [ ] (Pavel) сменить root-пароль `passwd` для гигиены
- [ ] (Pavel) сменить FrutPed `pasha_fp` пароль в Beget
- [ ] (Pavel) свой SSH-ключ → прислать публичную часть, добавлю в authorized_keys
- [x] Починить `incident-2026-04-29-003-session-warning` (config.php, убран сломанный блок) ✅ 2026-04-29
- [x] Локальный git-репо для кода `/var/www/fp.babichnail.online/` (initial commit `78231b9`) ✅ 2026-04-29
- [ ] Настроить remote для site-git репо (GitHub приватный? отдельный hub?) — решение за Павлом
- [x] Ежедневный mysqldump БД `fruitpedicure` (cron 23:55 UTC+5, retention 14d, локально на VPS) ✅ 2026-04-29
- [ ] Offsite-копия дампов БД — сейчас живут только на VPS (риск потери при крэше VPS); сделать nightly scp на Amber/Paganel host
- [ ] **Заблокировано (Pavel decision)** `certbot --nginx -d fp.babichnail.online` — DNS не указывает на VPS (45.130.41.50 = Beget proxy), HTTP-01 challenge не сработает. Варианты: (a) Beget Full SSL, (b) DNS-01 через Beget API, (c) изменить DNS на VPS-IP
- [x] Убрать `.bak`-файлы из public_html ✅ 2026-04-29
- [x] Выровнять ownership всех файлов на www-data:www-data ✅ 2026-04-29
- [ ] **0 user_courses при 10 users** — выяснить у Павла бизнес-логику (доступ выдаётся вне таблицы или баг?)
- [ ] Мониторинг `/var/log/nginx/error.log` на «PHP Warning» (cron / heartbeat) — чтобы новые подобные баги не висели неделями

## Не начато
- [ ] **Rotate FrutPed `pasha_fp` password** (incident `2026-04-29-002`, требует Павла)
- [ ] **Rotate VPS root password** (incident `2026-04-29-002`, требует Павла; в идеале — SSH key + disable password auth)
- [ ] Удалить Telegram-сообщения 52 и 53 в теме FrutPed (Павел; incident `2026-04-29-002`)
- [ ] Rotate GitHub PAT (incident `2026-04-29-001`, требует Павла)
- [ ] Logrotate для `logs/paganel-backup.log`
- [ ] Алерт в Telegram при сбое бэкапа
- [ ] Retrieval / Graphiti поверх hub'а (когда накопится критическая масса записей по схеме)
- [ ] Визуализация графа

## Открытые вопросы к Павлу
- Утвердить `meta/record-schema.md` как канон.
- Решить: мигрировать старые записи (2026-03-20, 2026-04-18, 2026-04-21, 2026-04-23) под новую схему или оставить как есть.
- Когда заводим вторую супергруппу `Amber+Павел` (по плану v2), или текущая общая остаётся одна?
