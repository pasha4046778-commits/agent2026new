---
id: decisions-register
type: meta
title: Decisions register
author: paganel
status: in_progress
created: 2026-04-21T00:00:00Z
updated: 2026-04-29T07:10:00Z
tags: [meta, decisions, register]
relates_to: [proj-shared-memory-hub]
---

# Decisions

## 2026-04-21
- Общую память Amber + Paganel храним в `shared-memory/` внутри workspace.
- Структуру делаем совместимой с будущим подключением Graphiti: отдельные источники, проекты, ежедневки и решения.
- Сначала строим качественную markdown-память и backup, граф связей подключаем следующим этапом.
- Первый обработанный внешний источник: видео `nX9kYShZVHg` о памяти агента и резервном копировании на GitHub.

## 2026-04-29
- **План v2 памяти от Amber принят как канон.** Расширяем его: добавлены папки `infra/`, `incidents/`, `meta/`. Source: файл «план память от амбер.txt», полученный 2026-04-29.
- **Format записей:** YAML frontmatter с обязательными `id`, `type`, `title`, `author`, `status`, `created`, `updated` + soft-graph связи (`relates_to`, `depends_on`, `blocked_by`, `decided_by`, `implemented_by`, `affects`, `source_for`). Канон — `meta/record-schema.md`.
- **Soft-graph сразу, граф-движок потом.** Записи graph-ready, но Graphiti/retrieval подключаем после накопления критической массы.
- **Роли:** Amber — архитектура, summaries, decisions, meta-rules; Paganel — технические изменения, deploy/dev, automation, incidents, follow-ups. **Уточнение Павла (2026-04-29):** Paganel также берёт на себя выстраивание структуры памяти и настройку безопасности.
- **Бэкап `shared-memory/`:** ежедневный cron 23:55 UTC+5 (= 18:55 UTC), скрипт `/root/.openclaw/workspace/scripts/backup-shared-memory.sh`, лог `logs/paganel-backup.log` (gitignored). Коммитит только `shared-memory/`. См. `infra/backup-shared-memory.md`.
- **Security (PAT в .git/config):** токен убран из remote URL и перенесён в `/root/.git-credentials` (chmod 600) + `git config --local credential.helper store`. Incident `2026-04-29-001` в `logs/security_log.json` (gitignored). Ротация токена в GitHub — за Павлом.
- **Git identity:** локально для этого репо `Paganel <paganel@bot.openclaw.local>` (без --global, не влияет на другие репо).
- **Приоритетные проекты:** `proj-fp-babichnail-online` (сайт https://fp.babichnail.online/) и `proj-shared-memory-hub` (сама память).
- **Telegram-маршрутизация:** темы группы `Paganel+Павел` (Dev / Сервер / Автоматизация / Ошибки / ТЗ / Проверки) — рабочее пространство; важное из тем оседает в hub по правилу: daily / todo / decisions / projects / infra / incidents / sources.
