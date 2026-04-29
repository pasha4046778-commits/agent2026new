---
id: meta-record-schema
type: meta
title: Record schema for shared-memory
author: paganel
status: in_progress
created: 2026-04-29T05:35:00Z
updated: 2026-04-29T05:35:00Z
tags: [meta, schema, soft-graph]
relates_to: []
---

# Record Schema (Soft Graph)

Единый формат заголовка (YAML frontmatter) для всех записей в `shared-memory/`. Цель — хранить достаточный контекст и связи, чтобы потом можно было поднять retrieval и Graphiti-граф без переписывания файлов.

## Обязательные поля

| Поле | Что | Пример |
|---|---|---|
| `id` | стабильный slug записи | `proj-fp-babichnail`, `decision-2026-04-29-cron-backup` |
| `type` | категория записи | см. ниже |
| `title` | человеческое название | `FP Babichnail сайт` |
| `author` | кто создал запись | `amber` / `paganel` / `pavel` |
| `status` | состояние | см. ниже |
| `created` | ISO8601 UTC | `2026-04-29T05:35:00Z` |
| `updated` | ISO8601 UTC | `2026-04-29T05:35:00Z` |

## Опциональные поля

| Поле | Что |
|---|---|
| `tags` | свободные теги, массив |
| `relates_to` | общая связь, массив `id` |
| `depends_on` | зависит от чего |
| `blocked_by` | заблокировано чем |
| `decided_by` | решением (id) |
| `implemented_by` | реализовано чем (id задачи / коммита / скрипта) |
| `affects` | что эта запись меняет |
| `source_for` | служит источником для |

## Допустимые `type`

| type | папка |
|---|---|
| `daily` | `daily/` |
| `project` | `projects/` |
| `source` | `sources/` |
| `decision` | `decisions.md` (как раздел) или отдельный файл `decisions/` |
| `incident` | `incidents/` |
| `infra` | `infra/` |
| `idea` | `ideas/` |
| `meta` | `meta/` |
| `person` | `people/` |

## Допустимые `status`

`open`, `in_progress`, `done`, `blocked`, `archived`, `cancelled`.
Для `daily` обычно `done` после закрытия дня; для `project` — текущее состояние; для `incident` — стадия разбора.

## Правила связей

- `id` должен быть уникален в рамках hub'а.
- Связь — это просто `id` в массиве; разрешение в файл — вручную или ретривером (поиск по frontmatter).
- Если связь идёт в обе стороны (A зависит от B), достаточно записать в одной из сторон; при выгрузке в граф направление восстановится.
- Не плодить связи "просто так" — добавлять только осмысленные.

## Пример

```yaml
---
id: incident-2026-04-29-001-pat-in-config
type: incident
title: GitHub PAT in .git/config remote URL
author: paganel
status: done
created: 2026-04-29T05:10:00Z
updated: 2026-04-29T05:10:00Z
tags: [security, credentials, git]
relates_to: [proj-shared-memory-hub]
decided_by: [decision-2026-04-29-cred-helper]
implemented_by: [commit:4d835f5]
affects: [infra-git-remote]
source_for: []
---
```

## Что НЕ кладём в frontmatter

- сам токен / секреты — никогда
- сырые длинные логи — в тело и только если нужны выжимки
- личную переписку без пользы

## Открытые вопросы

- decisions: один файл `decisions.md` или отдельные файлы в `decisions/`? Сейчас оставлено как есть (общий файл), при разрастании можно мигрировать.
- formal validator (yaml-lint + кастомные правила) — позже.
