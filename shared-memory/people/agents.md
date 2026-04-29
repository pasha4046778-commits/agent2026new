---
id: people-agents
type: person
title: Agents (Amber + Paganel)
author: paganel
status: in_progress
created: 2026-04-21T00:00:00Z
updated: 2026-04-29T07:10:00Z
tags: [people, agents, roles]
relates_to: [meta-writing-rules, proj-shared-memory-hub]
---

# Agents

## Amber
- **Роль (semantic side):** основной помощник Павла. Owner: summaries, decisions, project context. Co-owner: memory architecture / hub schema / meta-rules (вместе с Paganel).
- **Identity-файлы:** корневые `IDENTITY.md`, `USER.md`, `SOUL.md`, `AGENTS.md`, `HEARTBEAT.md`, `TOOLS.md` в `/root/.openclaw/workspace/`.
- **Telegram:** отдельная супергруппа `Amber + Павел`. Темы (финальный список Pavel'а 2026-04-29):
  `Общее` / `Серверы` / `Сайты` / `Память` / `Проекты` / `Paganel` / `Автоматизация` / `Codex` / `Ремонт` / `Варианты заработка` / `VPS агент` / `ТЗ для базы знаний` / `Идеи` / `Фрукт пед` / `Эксперимент`.
  (chat_id и thread_id'ы у меня не зафиксированы — это её группа.)

## Paganel
- **Роль (operational side):** Owner: infra, incidents, automation, security, implementation follow-ups, operational structure. Co-owner: memory architecture / hub schema / meta-rules (вместе с Amber).
- **Identity-файл:** `/root/.openclaw/workspace/PAGANEL_IDENTITY.md` (НЕ корневой `IDENTITY.md` — он Amber'ин).
- **Telegram:** супергруппа `Paganel + Павел` (`chat_id = -1003982689602`), бот `@Paganel88_bot`. Финальный список тем (2026-04-29):

| Тема | thread_id | Назначение |
|---|---|---|
| `general` (root supergroup) | — (нет thread_id) | свободный канал, оседает в `daily/`, дальше по контексту |
| `memory` | 7 | shared-memory hub: схема, правила, архитектура памяти |
| `FrutPed` (project-dedicated) | 49 | сайт `fp.babichnail.online`, всё по нему |
| `Dev / Разработка` | 114 | программирование общее, разные проекты |
| `Серверы` | 117 | серверы, хостинг, VPS |
| `Автоматизация` | 120 | cron, скрипты, deploy-pipeline, бэкап-сервисы |
| `Ошибки` | 123 | баги, сбои, root-cause разборы |
| `ТЗ` | 126 | постановки задач, требования, scope, acceptance criteria |
| `Идеи` | 129 | гипотезы, наброски, фичи в раздумьях |
| `Апгрейд` | 132 | обновления, версии, тюнинг (`my.cnf`, `php.ini`, opcache, unattended-upgrades) |
| `Сайты` | 135 | сайт-портфолио, разборы статей/инструментов |
| `Трейдинг` | 138 | трейдинг (новый домен — боты, API, бэктест, не финсоветы) |
| `Проверки` | (thread_id уточнить) | прогон by-hand проверок, smoke тесты, regression checks |

## Общее
- Оба пишут в один shared-memory hub по правилам `meta/writing-rules.md`.
- Telegram-тема ≠ память: важное из обеих групп оседает в hub по таблице маршрутизации.
- Daily-файлы общие (`daily/YYYY-MM-DD.md`), оба добавляют свои секции / абзацы с подписью `[author]`.

## Правило масштабирования
Если подключается третий агент:
- он не создаёт отдельную систему памяти с нуля;
- он читает `shared-memory/README.md`, `index.md`, `decisions.md`, `meta/record-schema.md`, `meta/writing-rules.md`, последние daily notes и нужные project/source files;
- затем пишет в ту же общую структуру по тем же правилам;
- получает свой identity-файл по аналогии с `PAGANEL_IDENTITY.md`.
