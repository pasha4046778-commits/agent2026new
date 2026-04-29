---
id: infra-fp-babichnail-online
type: infra
title: fp.babichnail.online — LMS deployment
author: paganel
status: in_progress
created: 2026-04-29T07:40:00Z
updated: 2026-04-29T08:05:00Z
tags: [website, hosting, beget, lms, frutped]
relates_to: [proj-fp-babichnail-online, infra-server-pasha-beget, infra-video-babichnail-online]
---

# fp.babichnail.online — LMS deployment

## Что это
Production-deployment кастомной LMS «Fruit Pedicure» — обучающая платформа на PHP 8.3 + MySQL.

## Где живёт
- **Hostname:** `fp.babichnail.online`
- **Origin VPS:** `pasha.beget.tech` / `85.198.84.47` (см. `infra-server-pasha-beget`)
- **Front:** Beget reverse proxy (`nginx-reuseport/1.21.1`), терминирует TLS, проксирует до origin по HTTP.
- **nginx vhost:** `/etc/nginx/sites-enabled/fp.babichnail.online`
- **Document root:** `/var/www/fp.babichnail.online/public_html`
- **Code tree:** `/var/www/fp.babichnail.online/` (admin, api, database, public_html, videos, config.php, README.md)
- **DB:** MySQL local, схема `fruitpedicure`, 916K, 7 таблиц.

## Структура кода (на 2026-04-29)
```
/var/www/fp.babichnail.online/
├── README.md              # инструкция по установке (PHP 8.1 в инструкции, по факту 8.3)
├── config.php             # конфиг (DB, CloudPayments, email) — root:root
├── nginx-config.txt       # бэкап nginx vhost
├── database/
│   └── schema.sql         # DDL для fruitpedicure
├── public_html/           # = document_root nginx
│   ├── index.php          # landing (динамический)
│   ├── buy.php, offer.php, payment.php, payment-security.php
│   ├── login.php, logout.php, dashboard.php
│   ├── activate.php, success.php
│   ├── watch.php, stream.php
│   ├── contacts.php, privacy.php
│   ├── create_users.php   # root:root, скрипт массового создания юзеров
│   ├── api/
│   │   ├── register.php
│   │   └── register.php.bak    ← lefovers
│   └── admin/
│       ├── index.php
│       ├── index.php.bak       ← leftover
│       ├── login.php, logout.php
│       └── add-user.php
├── admin/                # пустая (старая)
├── api/                  # пустая (старая)
└── videos/               # пустая, доступ закрыт через nginx
```

## nginx vhost (origin)
- `listen 80 default_server;` — origin **только** по HTTP. TLS — на Beget proxy.
- `server_name fp.babichnail.online 85.198.84.47 _;` — fallback на default.
- `root /var/www/fp.babichnail.online/public_html;`
- `index index.html index.php;` (фактически index.php — html нет).
- `.php` → unix socket `/var/run/php/php8.3-fpm.sock`.
- `/videos/` → `deny all; return 403;` (видео отдаются только через video.babichnail.online).
- `/.ht*` → deny.

## База данных
| Таблица | Строк (2026-04-29) |
|---|---|
| users | 10 |
| admins | 1 |
| courses | 1 |
| lessons | 5 |
| user_courses | 0 |
| lesson_progress | 0 |
| payments | 0 |

- Курс id=1 — «Fruit Pedicure», 5 модулей: Философия бренда / Препараты / Инструменты / Протоколы / Частые ошибки.
- Пользователи добавлены 15-21 апреля 2026, 9 из 10 active, expires_at заполнен только у одного (id=2 → 2027-04-15).
- 0 user_courses при 10 users — открытый вопрос: доступ выдаётся вне таблицы или баг.
- 0 payments — либо все доступы выданы вручную, либо платежей пока не было.

## FTP-каналы (Beget panel)
- Логин `pasha_fp`, root-папка `/home/p/pasha/fp.babichnail.online/` — 16K, **почти пустая болванка**, не связана с live-сайтом.
- Live-код деплоится root'ом в `/var/www/`. FTP `pasha_fp` к live доступа не даёт. (Хорошо для безопасности, но значит, что и Pavel не может править сайт через FTP.)

## Известные проблемы (на 2026-04-29 09:00 UTC)
1. ✅ ~~PHP session warning~~ — починено 2026-04-29 (`incident-2026-04-29-003-session-warning` → done, status mitigated).
2. ⏸️ **Origin без TLS-сертификата** — заблокировано: DNS `fp.babichnail.online` → `45.130.41.50` (Beget proxy), а не на VPS (`85.198.84.47`). Поэтому ACME HTTP-01 challenge с VPS не пройдёт — Let's Encrypt стучит в Beget proxy. Варианты решения: (a) включить «Full SSL» в панели Beget (если такая опция есть — origin получит сертификат от Beget); (b) изменить DNS на VPS-IP, потерять edge-кэш Beget; (c) сделать DNS-01 challenge — нужен Beget DNS API token. Решает Павел.
3. ✅ ~~.bak-файлы~~ — убраны 2026-04-29.
4. ✅ ~~Mixed ownership~~ — приведено к `www-data:www-data` 2026-04-29.
5. ✅ ~~Нет git-репо~~ — инициализировано 2026-04-29 (без remote).
6. ✅ ~~Нет автоматического mysqldump~~ — поставлен 2026-04-29 (без offsite-копии).
7. ⏳ **0 user_courses при 10 users** — открытый бизнес-вопрос к Павлу (доступ выдаётся вне таблицы или баг).

## Деплой / процесс
- ✅ git репо инициализирован 2026-04-29: `/var/www/fp.babichnail.online/.git`. Initial commit `78231b9` (branch `main`, author Paganel). 27 файлов в репо. `config.php`, `*.bak`, `videos/`, `*.log` — в `.gitignore`. **Remote: `pasha4046778-commits/fp-site` (приватный)**, push прошёл 2026-04-29 13:15 UTC. Аутентификация: fine-grained PAT с правами Contents=RW, Metadata=R, scoped только на `fp-site`. Хранится в `/root/secrets/github_token_fp_site.txt` (source) и в `/root/.git-credentials` (credential helper, chmod 600). Локальная git identity для коммитов в этом репо: `Paganel <paganel@bot.openclaw.local>`.
- ✅ mysqldump cron 2026-04-29: ежедневный gzip-дамп `fruitpedicure` в `/root/backups/fp.babichnail.online/db/` на VPS, retain 14 дней. Расписание: 23:55 UTC+5 (cron `55 18 * * *`). Скрипт `/root/scripts/backup-fp-db.sh`. Лог `/var/log/fp-db-backup.log`. Тест-запуск 2026-04-29 08:59 UTC прошёл (7 таблиц, 3.3K gzipped). **Offsite копия пока НЕ настроена** — если VPS умирает, дампы умрут с ним. Стоит сделать nightly scp на хост Amber/Paganel.
- ✅ Все .bak-файлы убраны из public_html 2026-04-29 (бэкапы в `/root/backups/fp.babichnail.online/cleanup-*/`).
- ✅ Ownership всех source-файлов нормализован к `www-data:www-data` 2026-04-29 (раньше config.php / activate.php / create_users.php / api/register.php были root-owned).

## Что неизвестно (open вопросы к Павлу)
- `pasha.beget.tech` shared hosting и VPS — это одна машина с двумя интерфейсами или две? (Я подключался напрямую к VPS — там FTP-папка `/home/p/pasha/` лежит как chroot для shared-hosting клиента; видимо одна машина.)
- Где исходники сайта живут вне сервера (есть ли локальная копия / приватный git)?
- Кто ещё имеет SSH/FTP доступ?
- Бизнес-логика: 0 user_courses при 10 users — это норма?

## Связи
- `proj-fp-babichnail-online` — проектный стержень.
- `infra-server-pasha-beget` — VPS.
- `incident-2026-04-29-002-creds-via-telegram` — пароли через Telegram.
- `incident-2026-04-29-003-session-warning` — PHP session warning bug.
