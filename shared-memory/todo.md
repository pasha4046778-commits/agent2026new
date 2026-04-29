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
- [x] Operational regulament — `meta/writing-rules.md` ✅ v1.1 (Amber + Paganel co-design 2026-04-29)
- [x] ID naming convention ✅ `meta/id-naming.md` v1.0 (proposal Amber, принят)
- [x] Summary artifact standard ✅ §6.4 + `summaries/TEMPLATE.md`
- [x] Update vs new record rule ✅ §6.2
- [x] Заполнить `projects/fp-babichnail-online.md` реальным контекстом (на 2026-04-29)
- [x] `infra/server-pasha-beget.md`, `infra/fp-babichnail-online.md` — заполнены реальным состоянием по результатам read-only осмотра 2026-04-29

## FrutPed action items (ждут ок Павла)
- [x] Установить SSH-ключ Paganel на VPS, отключить `PasswordAuthentication`, поменять `PermitRootLogin` на `without-password` ✅ 2026-04-29
- [x] Сменить SSH-порт с 22 на 49222, обновить fail2ban ✅ 2026-04-29
- [x] (Pavel) сменить root-пароль ✅ 2026-04-29
- [x] (Pavel) сменить FrutPed `pasha_fp` пароль в Beget ✅ 2026-04-29
- [x] (Pavel) свой SSH-ключ → добавлен в authorized_keys ✅ 2026-04-29 — теперь Pavel имеет независимый root-доступ к VPS
- [x] Починить `incident-2026-04-29-003-session-warning` (config.php, убран сломанный блок) ✅ 2026-04-29
- [x] Локальный git-репо для кода `/var/www/fp.babichnail.online/` (initial commit `78231b9`) ✅ 2026-04-29
- [x] Настроить remote для site-git репо ✅ 2026-04-29 — приватный `pasha4046778-commits/fp-site`, fine-grained PAT (scope: только этот репо, Contents=RW)
- [x] Ежедневный mysqldump БД `fruitpedicure` (cron 23:55 UTC+5, retention 14d, локально на VPS) ✅ 2026-04-29
- [x] Offsite-копия дампов БД ✅ 2026-04-29 — двухуровневый бэкап описан в `infra/db-backup.md`
- [-] ~~certbot для origin TLS~~ — снято: edge SSL Beget'а покрывает функциональные требования. Можно вернуться при необходимости defense-in-depth.
- [x] Убрать `.bak`-файлы из public_html ✅ 2026-04-29
- [x] Выровнять ownership всех файлов на www-data:www-data ✅ 2026-04-29
- [x] **0 user_courses при 10 users** ✅ это «single course» дизайн (не баг): доступ выдаётся флагом `users.is_active`, `user_courses` зарезервирована под мульти-курс.
- [x] Сменить пароль `gdl.php` на `video.babichnail.online` ✅ 2026-04-29 — Paganel ротировал и отрефакторил под `/etc/gdl/password` (Pavel читает через SSH, в коде секрета больше нет)
- [ ] (Pavel) Прописать webhook URL `https://fp.babichnail.online/api/confirm-payment.php` в TipTop Pay панели когда терминал переключат на боевой
- [x] (Pavel) Расширить scope GitHub PAT — Pavel пошёл лучшим путём, создал отдельный fine-grained PAT scoped только на `fp-site` ✅ 2026-04-29
- [x] Перенести пароль `gdl.php` из кода ✅ 2026-04-29 — теперь читается из `/etc/gdl/password` (root:www-data 640)
- [x] Чистка `.mov` originals из `/var/www/videos/` ✅ 2026-04-29 (21 GB освобождено, 52%→25%; inventory в `/root/backups/fp.babichnail.online/mov-deleted-2026-04-29_10-29-45.txt`)
- [ ] Мониторинг `/var/log/nginx/error.log` на «PHP Warning» (cron / heartbeat) — чтобы новые подобные баги не висели неделями

## Не начато
- [ ] **Rotate FrutPed `pasha_fp` password** (incident `2026-04-29-002`, требует Павла)
- [ ] **Rotate VPS root password** (incident `2026-04-29-002`, требует Павла; в идеале — SSH key + disable password auth)
- [ ] Удалить Telegram-сообщения 52 и 53 в теме FrutPed (Павел; incident `2026-04-29-002`)
- [ ] Rotate GitHub PAT (incident `2026-04-29-001`, требует Павла)
- [x] Logrotate для backup-логов ✅ 2026-04-29 (`/etc/logrotate.d/paganel-backups` на этом хосте, `/etc/logrotate.d/fp-db-backup` на VPS; monthly, retain 12, gzip)
- [ ] Алерт в Telegram при сбое бэкапа
- [ ] Retrieval / Graphiti поверх hub'а (когда накопится критическая масса записей по схеме)
- [ ] Визуализация графа

## Открытые вопросы к Павлу
- Утвердить `meta/record-schema.md` как канон.
- Решить: мигрировать старые записи (2026-03-20, 2026-04-18, 2026-04-21, 2026-04-23) под новую схему или оставить как есть.
- Когда заводим вторую супергруппу `Amber+Павел` (по плану v2), или текущая общая остаётся одна?
