---
id: proj-shared-memory-hub
type: project
title: Shared Memory Hub (доработка памяти)
author: paganel
status: in_progress
created: 2026-04-29T05:35:00Z
updated: 2026-04-29T05:35:00Z
tags: [memory, infra, priority]
relates_to: []
---

# Shared Memory Hub

## Что это
Сама память Amber и Paganel — её архитектура, правила, бэкапы, soft-graph, retrieval. Один из двух приоритетных проектов Павла.

## Текущий статус
В активной доработке. Принят план v2 от Amber + расширения от Paganel.

### Готово
- базовая структура `shared-memory/` (daily, projects, sources, ideas, people, decisions.md, todo.md)
- Paganel подключён к hub'у (2026-04-21)
- идентичности Paganel и Amber разделены (`PAGANEL_IDENTITY.md`)
- новые папки развёрнуты: `infra/`, `incidents/`, `meta/`
- frontmatter-схема для soft-graph: `meta/record-schema.md`
- backup в приватный GitHub: ремоут чистый, токен в credential helper, ежедневный cron 23:55 UTC+5 (см. `infra/backup-shared-memory.md`)

### В работе
- operational regulament (кто/когда/что/куда пишет) — `meta/writing-rules.md` (стаб → допишется)
- проектные стержни: `projects/fp-babichnail-online.md`, этот файл

### Не начато
- переход на frontmatter всех старых записей
- retrieval / Graphiti поверх hub'а
- визуализация графа

## Архитектурные решения (см. `decisions.md`)
- structured memory сначала, soft-graph потом (Amber + Paganel, 2026-04-29)
- роли: Amber — архитектура, summaries, decisions, meta-rules; Paganel — технические изменения, deploy/dev, automation, incidents. (Скорректировано Павлом 2026-04-29: Paganel также берёт на себя выстраивание структуры памяти и безопасность.)

## Связи
- `meta/record-schema.md` — схема записей
- `infra/backup-shared-memory.md` — бэкап
- `decisions.md` — все ключевые решения
- `people/agents.md`, `people/PAGANEL_ONBOARDING.md`, `people/PAGANEL_CONNECT_MESSAGE.md`

## Что нужно от Павла
- утвердить frontmatter-схему (record-schema.md)
- решить, мигрировать ли старые записи или применять схему только к новым
