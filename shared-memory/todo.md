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
- [ ] Operational regulament — `meta/writing-rules.md` (кто/когда/что/куда пишет; правило маршрутизации Telegram-темы → hub)
- [ ] Заполнить `projects/fp-babichnail-online.md` реальным контекстом (текущие доработки, инфра, бэклог)
- [ ] Описать инфраструктуру в `infra/`: сервер `babichnail.online`, поддомены `fp.` и `video.`, GitHub-ремоут

## Не начато
- [ ] Применить frontmatter ко всем существующим записям (или решить: только к новым)
- [ ] Rotate GitHub PAT (требует Павла; см. `logs/security_log.json` incident `2026-04-29-001`)
- [ ] Logrotate для `logs/paganel-backup.log`
- [ ] Алерт в Telegram при сбое бэкапа
- [ ] Retrieval / Graphiti поверх hub'а (когда накопится критическая масса записей по схеме)
- [ ] Визуализация графа

## Открытые вопросы к Павлу
- Утвердить `meta/record-schema.md` как канон.
- Решить: мигрировать старые записи (2026-03-20, 2026-04-18, 2026-04-21, 2026-04-23) под новую схему или оставить как есть.
- Когда заводим вторую супергруппу `Amber+Павел` (по плану v2), или текущая общая остаётся одна?
