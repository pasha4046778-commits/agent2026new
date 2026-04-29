---
id: meta-id-naming
type: meta
title: ID naming convention для shared-memory
author: amber
status: approved
version: v1.0
created: 2026-04-29T16:00:00Z
updated: 2026-04-29T16:00:00Z
tags: [meta, naming, schema, id]
relates_to: [meta-record-schema, meta-writing-rules]
---

# ID Naming Convention

Канон формата `id` для всех записей `shared-memory/`. Источник: предложение Amber, принято 2026-04-29.

## Базовые формы

| Тип записи | Формат `id` | Пример |
|---|---|---|
| Daily | `daily-YYYY-MM-DD` | `daily-2026-04-29` |
| Project | `proj-<slug>` | `proj-fp-babichnail-online` |
| Infra | `infra-<slug>` | `infra-server-pasha-beget` |
| Incident | `incident-YYYY-MM-DD-NNN-<slug>` | `incident-2026-04-29-003-session-warning` |
| Decision (если выделим в отдельные файлы) | `decision-YYYY-MM-DD-<slug>` | `decision-2026-04-29-cred-helper` |
| Source | `src-YYYY-MM-DD-<slug>` | `src-2026-04-21-youtube-nX9kYShZVHg` |
| Idea | `idea-<slug>` | `idea-multi-course-lms` |
| Person / agent | `person-<slug>` или `people-<slug>` (для общих контекстов) | `people-agents`, `people-paganel-onboarding` |
| Meta (правила, схемы) | `meta-<slug>` | `meta-record-schema`, `meta-writing-rules` |
| Summary (см. также `summaries/`) | `summary-<scope>-YYYY-MM-DD-<slug>` | `summary-fp-2026-04-29-launch-readiness` |
| Todo (если когда-нибудь разделим один `todo.md` на файлы) | `todo-<slug>` | `todo-rotate-pat` |

## Правила

1. **Только lowercase.** Латиница и цифры, разделитель — дефис `-`.
2. **Без случайных сокращений.** `proj-fp-babichnail-online` — да; `proj-fpbabch` — нет. Slug должен читаться человеком, а не угадываться.
3. **Стабильный slug.** Не «красивый на сегодня», а такой, чтобы через 6 месяцев был всё ещё точным. Если переименовали проект — НЕ меняй id, добавь `aliases:` или новый файл со ссылкой `relates_to`.
4. **Дата в id — UTC, формат `YYYY-MM-DD`.** Для инцидентов добавляется порядковый `NNN` (001..999) внутри дня.
5. **Уникальность в рамках hub'а.** Перед созданием — `grep -l "id: <new-id>"` чтобы не дублировать.
6. **Имена файлов** обычно совпадают с `id` (без префикса `id:`), но не строго. Для daily — `daily/2026-04-29.md`, не `daily/daily-2026-04-29.md` (избыточный prefix). Для других — файл может быть короче (`projects/fp-babichnail-online.md`), но `id:` в frontmatter — полный.

## Что не делаем

- Не используем CamelCase, snake_case, точки в slug'е.
- Не используем русские буквы в id (русский — только в `title:` и теле).
- Не делаем id с пробелами, знаками препинания, эмодзи.
- Не плодим разные стили под одно и то же. Если для конкретного типа стиля нет в этой таблице — поднять обсуждение, а не изобретать.

## Эволюция

Если появляется новый тип записи (например, `runbook`, `playbook`) — сначала добавляем в эту таблицу с примером, затем используем. Изменения версионируем в шапке этого файла + отметка в `decisions.md`.
