---
id: src-2026-05-05-codbash-dashboard
type: source
title: "Codbash — AI Coding Session Dashboard (vakovalskii/codedash)"
author: paganel
status: done
created: 2026-05-05T15:00:00Z
updated: 2026-05-05T15:00:00Z
tags: [source, ai, agent-tooling, dashboard, monitoring]
relates_to: [people-agents, proj-shared-memory-hub]
source_for: []
---

# Codbash — AI Coding Session Dashboard

## Тип источника
GitHub-репозиторий (open-source проект)

## Ссылка / идентификатор
- Repo: https://github.com/vakovalskii/codedash
- Внутри он называется **Codbash** (расхождение между названием репо и названием проекта).
- License: MIT
- Stack: JavaScript, Node.js ≥ 18, zero production dependencies, localhost-only.

## Короткая выжимка
Локальный (localhost) браузерный дэшборд для управления AI-coding-сессиями нескольких агентов в одном месте. Лезет в директории сессий конкретных агентов на ПК и показывает их в одном UI. Поддерживает: Claude Code, Codex CLI, Cursor, OpenCode, Kiro, Copilot Chat.

## Ключевые фичи
- **Поиск:** fuzzy + full-text deep-search по сообщениям всех сессий, фильтр по агенту / тегам / диапазону дат.
- **Replay:** перепрокрутка любой сессии с timeline-контролами.
- **Live-мониторинг:** показывает LIVE/WAITING статус активных сессий, CPU/RAM/PID/uptime.
- **Cost analytics:** считает стоимость по токенам с раскладкой по моделям (Opus / Sonnet / Haiku и др.). Дневные графики, per-session расходы.
- **Activity heatmap:** streak-статистика дней работы.
- **Кросс-агент:** конверсия сессии Claude Code ↔ Codex, генерация handoff-контекста для продолжения в другом агенте.
- **Импорт/экспорт:** `codbash export file.tar.gz` — снимок всех сессий.
- **Установка/запуск агентов:** one-click install для поддерживаемых агентов.

## Установка
```bash
npm i -g codbash-app
codbash run [--port=N] [--no-browser]
```
Доступ: `http://localhost:<port>` в браузере.

## Команды
```
codbash run        # запустить дэшборд
codbash search Q   # поиск
codbash handoff <id> [target] [--verbosity=full]
codbash convert <id> claude|codex
codbash stats
codbash export [file.tar.gz]
codbash import <file.tar.gz>
```

## Что важно для наших задач
- Релевантно прямо: у Pavel'а ДВА параллельных Claude Code-агента (Amber и Paganel). Одного дэшборда не хватает — здесь сразу оба.
- Cost-analytics → понимание, какая сессия / агент жжёт токены (если работаем на API-подписке с лимитами).
- Replay → проще поднимать прошлый контекст без ручного chat-history.
- Локальный, MIT, без облака — не противоречит нашим правилам безопасности.

## Ограничения / нюансы
- Видит только директории, доступные хосту, на котором запущен. То есть:
  - На Amber/Paganel-хосте (46.8.79.53): увидит `~/.claude/` (наши сессии). Cursor / Copilot, которые работают на ПК Pavel'а — нет.
  - На ПК Pavel'а Windows: увидит его локальные Cursor/Copilot/Codex, но НЕ Amber/Paganel-сессии (они на удалённом хосте).
- Полное покрытие требует двух инсталляций: одна на ПК, одна на агентом-хосте. Дэшборды независимы.
- Нет встроенной cross-machine консолидации.

## Безопасность
- Localhost-only — данные не уходят наружу.
- Zero production dependencies — минимальный supply-chain risk, но `npm audit` после установки лишним не будет.
- При экспорте `codbash export` — снимок включает содержимое сессий (могут быть креды / секреты, если они появлялись в чате с агентом). Файл не вылить наружу без проверки.

## Следующие действия
- Решение Павла после обсуждения с Amber: ставим / не ставим / куда.
- Если ставим на Amber/Paganel-хост — обернуть запуск в systemd unit для автозапуска.
- Источник цитируется в potential decision-записи `decision-2026-05-05-codbash-adoption` (если будет принято решение).
