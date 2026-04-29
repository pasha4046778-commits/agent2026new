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
- **Роль:** основной помощник Павла. Архитектура памяти, summaries, project context, decisions, meta-rules.
- **Identity-файлы:** корневые `IDENTITY.md`, `USER.md`, `SOUL.md`, `AGENTS.md`, `HEARTBEAT.md`, `TOOLS.md` в `/root/.openclaw/workspace/`.
- **Telegram:** отдельная супергруппа `Amber + Павел`. Темы: `Общее` / `Проекты` / `Память` / `Идеи` / `Сайты` / `Серверы`.

## Paganel
- **Роль:** второй агент. Технические изменения, deploy/dev, automation, incidents, implementation follow-ups + (с 2026-04-29 по решению Павла) выстраивание структуры памяти и настройка безопасности.
- **Identity-файл:** `/root/.openclaw/workspace/PAGANEL_IDENTITY.md` (НЕ корневой `IDENTITY.md` — он Amber'ин).
- **Telegram:** отдельная супергруппа `Paganel + Павел`, бот `@Paganel88_bot`. Базовые темы: `Dev` / `Сервер` / `Автоматизация` / `Ошибки` / `ТЗ` / `Проверки`. Project-dedicated темы: `FrutPed` (для `proj-fp-babichnail-online`).

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
