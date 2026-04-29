---
id: infra-db-backup
type: infra
title: fruitpedicure DB — двухуровневый бэкап
author: paganel
status: done
created: 2026-04-29T09:45:00Z
updated: 2026-04-29T09:45:00Z
tags: [backup, mysql, fruitpedicure, cron]
relates_to: [infra-fp-babichnail-online, infra-server-pasha-beget, proj-fp-babichnail-online]
implemented_by: [/root/scripts/backup-fp-db.sh, /root/.openclaw/workspace/scripts/mirror-fp-db.sh]
---

# Fruitpedicure DB backup — двухуровневый

## Что делает
Бэкап БД `fruitpedicure` (~916K, 7 таблиц) с двумя уровнями хранения, чтобы крах VPS не уносил с собой всю историю учеников.

## Уровень 1 — local dump на VPS
- **Хост:** `85.198.84.47` (Beget VPS).
- **Скрипт:** `/root/scripts/backup-fp-db.sh`.
- **Cron:** `55 18 * * *` (= 23:55 UTC+5).
- **Куда:** `/root/backups/fp.babichnail.online/db/fruitpedicure-<ISO_TS>.sql.gz`.
- **Что внутри:** `mysqldump --single-transaction --quick --triggers --routines --events`.
- **Retention:** 14 дней (auto-prune через `find -mtime +14 -delete`).
- **Лог:** `/var/log/fp-db-backup.log` (на VPS).
- **Аутентификация в БД:** `/etc/mysql/debian.cnf` (системный maintenance-аккаунт).

## Уровень 2 — offsite mirror на хост Paganel/Amber (46.8.79.53)
- **Хост:** этот (`server`, `46.8.79.53`).
- **Скрипт:** `/root/.openclaw/workspace/scripts/mirror-fp-db.sh`.
- **Cron:** `25 19 * * *` (= 30 минут ПОСЛЕ Уровня 1; даём VPS время сделать дамп).
- **Куда:** `/root/backups/fp-db-mirror/`.
- **Метод:** `rsync -az --partial` через SSH-ключ Paganel и порт 49222 (см. `infra-server-pasha-beget` доступы).
- **Retention:** пока без авто-прюна (файлы по 3K, накопление за годы пренебрежимо). Если станет нужно — легко добавить.
- **Лог:** `/root/.openclaw/workspace/logs/fp-db-mirror.log` (на этом хосте, gitignored).

## Восстановление
```bash
# Получить нужный дамп (с VPS или из mirror'а на этом хосте)
zcat fruitpedicure-2026-04-29T08-59-12Z.sql.gz | mysql --defaults-file=/etc/mysql/debian.cnf fruitpedicure
```

## Проверка работоспособности
```bash
# На VPS
ls -lt /root/backups/fp.babichnail.online/db/ | head
tail -10 /var/log/fp-db-backup.log

# На этом хосте
ls -lt /root/backups/fp-db-mirror/
tail -10 /root/.openclaw/workspace/logs/fp-db-mirror.log

# Целостность последнего дампа
LATEST=$(ls -t /root/backups/fp-db-mirror/*.sql.gz | head -1)
gzip -t "$LATEST" && echo ok
zcat "$LATEST" | grep -c "^CREATE TABLE"  # должно быть 7
```

## Failure modes
- VPS-уровень падает → mirror просто скопирует то, что есть; на следующий день VPS дамп должен сделаться вновь.
- Mirror-уровень падает → дампы ещё лежат на VPS, можно вручную сдёрнуть.
- Если оба уровня молчат N дней → нужен алёрт. Сейчас алёрта НЕТ; добавить в todo.

## Open improvements
- Алерт в Telegram при сбое (любого из уровней) — сейчас только в локальный лог.
- Logrotate для обоих логов.
- Целостность-чек после mirror (`gzip -t`) автоматически — сейчас руками.

## Связи
- `infra-fp-babichnail-online` — что бэкапится.
- `infra-server-pasha-beget` — VPS, который делает Уровень 1.
- `infra-backup-shared-memory` — backup памяти, не путать (другая задача, другой график).
