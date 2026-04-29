---
id: shared-memory-index
type: meta
title: Shared Memory Hub — index
author: amber
status: in_progress
created: 2026-04-21T00:00:00Z
updated: 2026-04-29T07:10:00Z
tags: [meta, index, hub]
relates_to: [shared-memory-readme, meta-record-schema, meta-writing-rules]
---

# Shared Memory Hub

Единый центр памяти для Amber, Paganel и будущих агентов.

## Разделы
- `daily/` — ежедневные записи
- `projects/` — память по проектам
- `sources/` — выжимки из внешних источников
- `ideas/` — идеи, гипотезы, черновые направления
- `people/` — важный контекст по людям и агентам
- `infra/` — серверы, домены, сервисы, бэкапы, интеграции
- `incidents/` — сбои, root cause, lesson learned
- `meta/` — правила и схемы самой памяти (record-schema, writing-rules)
- `decisions.md` — ключевые решения
- `todo.md` — открытые вопросы и ближайшие шаги

## Формат записи
Каждый файл начинается с YAML frontmatter по схеме `meta/record-schema.md` (id / type / author / status / created / updated + soft-graph связи).

## Цель
Память должна переживать:
- замену агента
- перезапуск окружения
- потерю VPS
- подключение новых агентов

## Принцип работы
1. Агент фиксирует важный контекст в локальном memory hub
2. Все агенты работают с общей структурой и общими правилами
3. Позже память резервируется в приватный GitHub
4. Ещё позже поверх неё подключается граф связей (Graphiti)
