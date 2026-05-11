---
id: infra-server-pasha4bn-beget-shared
type: infra
title: Beget shared-hosting — pasha4bn.beget.tech (account pasha4bn @ salt.beget.ru)
author: paganel
status: in_progress
created: 2026-05-11T12:30:00Z
updated: 2026-05-11T12:30:00Z
tags: [beget, shared-hosting, infra, sites, wordpress]
relates_to: [infra-server-pasha-beget, proj-fp-babichnail-online]
---

# Beget shared-hosting — pasha4bn

## Что это
Shared-hosting аккаунт Pavel'а у Beget. Отдельная сущность от dedicated-VPS (`adkutxwhda` / `85.198.84.47`). Здесь живут несколько пробных/прототипных сайтов и одна продакшн WP-инсталляция.

## Где живёт
- **Хост:** `pasha4bn.beget.tech` (DNS → `5.101.153.76`, машина `salt.beget.ru`, ядро 5.10 с `beget-acl`)
- **Аккаунт:** `pasha4bn` (uid 8706, gid 601 / `newcustomers`)
- **Home:** `/home/p/pasha4bn`
- **Shell:** `/bin/bash`
- **Filesystem:** `/dev/md0p2` 6.9T (shared между всеми клиентами salt — не личная квота)

## Доступы
- **Где креды:** `/root/secrets/beget-tech-account.txt` НА VPS `85.198.84.47` (drwx------ root). Три поля: `host:`, `user:`, `password:`. Не в локальном `.env`.
- **Протоколы:** SSH `:22` open, FTP `:21` open. SSH работает (`sshpass -e ssh pasha4bn@pasha4bn.beget.tech`). Порт 2222 closed.
- **Способ подключения** (отрабатывал 2026-05-08, 2026-05-11):
  ```
  # с VPS 85.198.84.47:
  P=$(awk -F: '/^password:/{print $2}' /root/secrets/beget-tech-account.txt | tr -d ' ')
  SSHPASS="$P" sshpass -e ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password \
    pasha4bn@pasha4bn.beget.tech
  ```
- **GitHub PAT** для сайтов: `/root/secrets/github_token_fp_site.txt` (104 chars, fine-grained) — там же на VPS.

## Сайты на аккаунте

| Папка `~/<dir>` | Размер | Файлов | Назначение / стек |
|---|---|---|---|
| `pasha4bn.beget.tech/public_html` | **416M** | 9824 | **WordPress** (wp-config, wp-content, wp-admin). Активный — wp-content менялся 2026-05-08. Есть `test_amocrm.php` (1.7K, 2026-02-28) — интеграция с AmoCRM. |
| `arzu.pasha4bn.beget.tech/public_html` | 114M | 64 | Реальный апп: `admin/`, `api/`, `data/`, `badi-editor-widget.js` (22K). Бренд **arzu / hab.badi**. |
| `arzu2.pasha4bn.beget.tech/public_html` | 110M | 50 | index.html (39K) + index.php (38K). Шаблонный клон. |
| `arzu3.hab.badi.pasha4bn.beget.tech/public_html` | 110M | 49 | index.html (24K) + 404.html. Шаблонный клон под суб-бренд `hab.badi`. |
| `arzu.manus.hab.badi.pasha4bn.beget.tech/public_html` | 52K | 1 | один index.php (35K). |
| `hab.badi.pasha4bn.beget.tech/public_html` | 28K | 1 | один index.html (10K). |
| `frutped.pasha4bn.beget.tech/public_html` | 14M | 26 | Ранний прототип FrutPed-LMS. AGENTS.md / IDENTITY.md / HEARTBEAT.md (артефакты Claude-сессии). 5 версий `flower-shop-rozovy-*.zip` (~2.4M каждая). `frutped-upgrade-v2026.zip` (9KB). |
| `arzu/` (без public_html) | 110M | — | Дамп кода: app.js, index.html, styles.css, images. Не подключён к домену. |

В корне `~`: `fp-lms.tar.gz` (14K), `fp-lms-complete.tar.gz` (24K), пустой `ENDHTML`.

## Текущее состояние
- WP на главном поддомене активно используется (свежие изменения в wp-content)
- "arzu*" — серия экспериментальных/клонированных сайтов под бренд `arzu`/`hab.badi`
- `frutped.pasha4bn.beget.tech` — устаревший прототип; основной FrutPed переехал на dedicated-VPS (`fp.babichnail.online`)
- БД: `mysql`/`mysqldump` доступны, но `~/.my.cnf` нет — креды БД лежат в `wp-config.php` каждого сайта
- Логов в `~/logs/` нет (либо пусто, либо Beget кладёт куда-то в /var)

## Зависимости
- `infra-server-pasha-beget` — креды лежат на нём, оттуда же ходим SSH-ом сюда.
- `proj-fp-babichnail-online` — `frutped.pasha4bn.beget.tech` это исторический прототип.

## Open issues / not done yet
- Не лез в `wp-config.php` ни одного сайта (там DB-креды).
- Не делал `mysqldump` ни одной БД.
- Не открывал zip-архивы `flower-shop-rozovy-*.zip`.
- Нет git-репо для этих сайтов — изменения не отслеживаются.
- Архивы `fp-lms*.tar.gz` в `~` не выкачаны в shared-memory.

## История
- **2026-05-08 (Paganel):** Pavel дал доступ — креды в `/root/secrets/beget-tech-account.txt` на VPS. Подключился, проинвентаризировал 8 сайтов + WordPress.
- **2026-05-11 (Paganel):** оформлено в эту infra-заметку, закоммичено в shared-memory.
