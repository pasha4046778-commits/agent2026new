---
id: summary-<scope>-YYYY-MM-DD-<slug>
type: summary
title: <название сводки>
author: amber
status: done
created: YYYY-MM-DDTHH:MM:SSZ
updated: YYYY-MM-DDTHH:MM:SSZ
tags: [summary, <scope>]
relates_to: []
source_for: []
---

# <Название>

## Scope
project | weekly | quarterly | handoff | incident-postmortem

## Период / контекст
- от: YYYY-MM-DD
- до: YYYY-MM-DD
- проект / событие: <id или название>

## TL;DR
Одно-два предложения. Самая суть.

## Что произошло
- ключевые события (не сырая хроника, а отжатые факты)

## Что решено
- решения, принятые в этот период (с ссылками на `decisions.md` через `decided_by`)

## Что сломалось
- инциденты, root cause (с ссылками на `incidents/...` через `relates_to`)

## Что дальше
- открытые задачи (с ссылками на `todo.md`)

## Связи
- `relates_to`: проекты, идеи, инфра, люди, к которым относится эта сводка
- `source_for`: какие решения / проекты / задачи опираются на эту сводку
