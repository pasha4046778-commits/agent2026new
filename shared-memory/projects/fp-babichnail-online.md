---
id: proj-fp-babichnail-online
type: project
title: fp.babichnail.online (FrutPed) — Fruit Pedicure LMS
author: paganel
status: in_progress
created: 2026-04-29T05:35:00Z
updated: 2026-04-29T08:05:00Z
tags: [website, lms, priority, frutped]
relates_to: [infra-fp-babichnail-online, infra-server-pasha-beget, incident-2026-04-29-003-session-warning]
---

# fp.babichnail.online — Fruit Pedicure LMS (FrutPed)

## Что это
Платный онлайн-курс по педикюру. Кастомная LMS на PHP 8.3 + MySQL: лендинг → покупка через CloudPayments → активация → личный кабинет → просмотр уроков (видео отдаются с защищённого `video.babichnail.online`).

Внутреннее код-имя: **FrutPed**.

## Текущее состояние (2026-04-29)
- Сайт live, отвечает по https://fp.babichnail.online/.
- Контент: 1 курс «Fruit Pedicure», 5 модулей, описание см. `infra-fp-babichnail-online`.
- Аудитория: 10 зарегистрированных пользователей (9 активных), последний — 2026-04-21.
- Платёжная интеграция: CloudPayments (валюта KZT).

## Что было сделано (восстановлено из артефактов на сервере, не из переписки)
- Развёрнута полная LMS: schema.sql + PHP-страницы (landing/buy/payment/activate/login/dashboard/watch/admin).
- Вшит контент курса (5 уроков, видео загружены отдельно на `video.babichnail.online`).
- Зарегистрирован 1 admin, добавлены первые 10 пользователей вручную (включая тестовые: vit, pas, aid, mar, inf, koz, bet).
- Последняя правка кода: 2026-04-15 (~2 недели назад). Сайт стабилен.

> Прим. Paganel: переписка из DM, где «делали уже доработки», в боте недоступна (Telegram bot API не отдаёт историю). Если Павел укажет конкретные правки, точечно проверю.

## Активные баги
- `incident-2026-04-29-003-session-warning` — PHP Warning на каждом запросе: `ini_set` и `session_set_cookie_params` в `config.php:24-25` вызываются после старта сессии. Настройки cookie не применяются. Низкий риск, но реально снижает безопасность сессий.

## Технические долги
- Нет git-репо у кода → нет истории, нет отката.
- Нет автоматического бэкапа БД (916K, легко делать nightly mysqldump).
- Origin без TLS-сертификата (полагается на Beget edge SSL).
- Mixed ownership www-data vs root в файлах сайта.
- `.bak`-файлы в public_html.
- 0 строк в `user_courses` при 10 users — либо доступ выдаётся вне этой таблицы, либо логика регистрации неполная.

## Приоритеты (мой draft, ждёт ок Павла)
1. Поставить SSH-ключ от Paganel → отключить парольный root login на VPS (закрывает риск кредов через Telegram + 15K bruteforce).
2. Починить session warning (5 минут).
3. Завести приватный git-репо для кода + ежедневный mysqldump.
4. Origin TLS через certbot + переключить Beget на full SSL.
5. Прибраться: убрать .bak'и, выровнять ownership.

## Связанные источники
- README.md на сервере (`/var/www/fp.babichnail.online/README.md`) — инструкция по установке.
- `database/schema.sql` — DDL.

## Что нужно от Павла
- ОК на SSH-ключ (приоритет 1).
- Подтвердить, что 0 user_courses при 10 users — это норма (выдача доступа вне таблицы)? Или есть баг.
- Если есть локальная копия исходников — путь / репо. Если нет — настроить «server-as-source-of-truth» с git initial commit прямо на VPS.
- Куда хранить ежедневный дамп БД (S3 / другой VPS / GitHub приватный)?
- Список доработок, которые делались с этим Paganel'ом раньше (мне не видно), если хочешь, чтобы я подхватил.
