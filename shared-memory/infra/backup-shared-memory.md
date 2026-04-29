---
id: infra-backup-shared-memory
type: infra
title: Daily backup of shared-memory to GitHub
author: paganel
status: done
created: 2026-04-29T05:35:00Z
updated: 2026-04-29T05:35:00Z
tags: [backup, cron, git, github]
relates_to: [proj-shared-memory-hub]
implemented_by: [/root/.openclaw/workspace/scripts/backup-shared-memory.sh]
---

# Daily backup of shared-memory

## Что делает
Ежедневный авто-бэкап `shared-memory/` в приватный GitHub-ремоут.
Скрипт коммитит ТОЛЬКО изменения в `shared-memory/` (другие пути не трогает) и пушит в `origin/master`.

## Когда
Каждый день в 23:55 по времени Павла (UTC+05:00) = 18:55 UTC.

## Как (cron)
Установлено в crontab пользователя root:
```
55 18 * * * /root/.openclaw/workspace/scripts/backup-shared-memory.sh
```

## Скрипт
`/root/.openclaw/workspace/scripts/backup-shared-memory.sh` — bash, `set -euo pipefail`.
Author всегда `Paganel <paganel@bot.openclaw.local>` (через `-c user.name -c user.email`, не меняет глобальный конфиг).

## Лог
`/root/.openclaw/workspace/logs/paganel-backup.log` — один строка на запуск, формат `[ISO_TS] <событие>`.
Папка `logs/` в `.gitignore`, лог в репозиторий не утечёт.

## Аутентификация
Через credential helper, токен в `/root/.git-credentials` (chmod 600).
Origin URL чистый: `https://github.com/pasha4046778-commits/agent2026new.git`.

## Что НЕ покрывает
- остальной workspace (по дизайну — бэкапим только память)
- секреты `.env` (исключены через `.gitignore`)
- `logs/`, `data/`, `memory/`, `tmp/`, `media/` (исключены)

## Failure mode
- если `git add` упал — exit 1, ошибка в логе, следующий запуск попробует снова
- если нечего коммитить — лог пишется, push всё равно делается (на случай, если ранее остались неотправленные коммиты)
- если `push` упал — exit 1, ошибка в логе; нужно разобраться руками (обычно: проблема с токеном)

## Проверка работоспособности
```bash
# Запуск вручную
/root/.openclaw/workspace/scripts/backup-shared-memory.sh

# Последние записи лога
tail -20 /root/.openclaw/workspace/logs/paganel-backup.log

# Список cron-задач
crontab -l
```

## Открытые улучшения
- ротация лога (logrotate) — пока лог растёт без ограничений
- алерт в Telegram при exit 1 — пока только в лог
- если репозиторий перейдёт на ветку, отличную от master, — править скрипт
