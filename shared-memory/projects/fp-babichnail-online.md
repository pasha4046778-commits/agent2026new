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

## Что было сделано (восстановлено по chat-history файлу от Павла 2026-04-29 + артефактам сервера)

Прежняя сессия Paganel'я закрыла длинный список:

### Безопасность (до апреля)
- Авторизация админки переведена с cookie на session (была дыра — кто угодно мог войти через DevTools).
- Проверка HMAC-подписи вебхука раскомментирована.
- `generatePassword` переведён с `rand()` на `random_int()`.
- Idempotency-защита от двойного процессинга платежа.
- `display_errors` отключён в продакшене.
- Все `.bak` из public_html подчищены (5 штук в апреле).

### LMS-функционал
- Создан `login.php` (его не было — редирект с index.php вёл в никуда).
- Создан `admin/login.php` с проверкой по БД.
- Расширенная админка: дашборд (статистика), ученики (поиск/фильтры/добавление/блокировка/продление/сброс пароля), уроки (CRUD, тип «URL» или «загруженный файл»), платежи, настройки.
- watch.php поддерживает iframe (YouTube/Vimeo/Drive) и `<video>` (файл).

### Платежи (TipTop Pay)
- Виджет TipTop Pay интегрирован по их доке: `widget.tiptoppay.kz/bundles/widget.js`.
- Передаются `publicTerminalId`, `amount`, `currency`, `paymentSchema='Single'`, `externalId` (= user_id для вебхука).
- Webhook `/api/confirm-payment.php` обновлён: HMAC-заголовок `X-Content-HMAC` (основной) + `Content-HMAC` (запасной), поддержка `InvoiceId`/`externalId`.
- **Реальные ключи `TIPTOP_PUBLIC_ID` / `TIPTOP_API_KEY` уже в config.php** (Pavel заменил заглушки).
- ⏳ **Webhook URL** в личном кабинете TipTop Pay прописать должен Pavel: `https://fp.babichnail.online/api/confirm-payment.php` (Pay+Confirm). Сейчас терминал в **тестовом режиме** — ждёт перевода на боевой; в тестовом режиме webhook'и не приходят, активация и письма через webhook не сработают.

### Email-уведомления
- Письмо ученику с логином/паролем после оплаты или ручного добавления через админку — работает (баг с `rn` вместо `\r\n` в заголовках починен).
- Письмо админу `info@galereya-krasoti.com` при каждой регистрации (даже без оплаты) — работает.

### Дизайн
- Вся LMS приведена к палитре лендинга: cream `#F5F5F0`, оранжевый `#FF6B00`, терракотовый `#9E5C3F`, шрифт Montserrat.
- Фавикон — апельсин с лендинга, на всех страницах включая футер и checkout.

### Видеоплатформа
- Подключён SSL для `video.babichnail.online` (Let's Encrypt).
- Защищённые токен-ссылки на видео (4-часовой TTL, `check-access.php`).
- Авто-конвертация загруженных видео (inotify + ffmpeg) — `video-convert.service` (CRF 22, H.264).
- Поддержка HEVC/H.265 → H.264, VP9 → H.264.
- Загрузчик `gdl.php` с защитой паролем — Pavel вставляет ссылку Google Drive / YouTube, VPS скачивает напрямую через `gdown` / `yt-dlp` без LLM-токенов.
- На сейчас залито 13 готовых .mp4 + 10 .mov originals, ~31 GB на диске VPS.

### Регистрация / выдача доступа (объясняет «0 user_courses при 10 users»)
- В системе один курс, доступ выдаётся флагом `users.is_active`. `user_courses` table зарезервирована под мульти-курс — пока пуста по дизайну, не баг.
- Поток: `/buy.php` → форма + чекбокс согласия → TipTop Pay widget → webhook `/api/confirm-payment.php` → `is_active=1` + email. Альтернативно: админка → «Добавить ученика» → создание + email с паролем.

## Активные баги
- ✅ ~~`incident-2026-04-29-003-session-warning`~~ — починен 2026-04-29.

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
- ✅ SSH-ключ установлен 2026-04-29.
- ✅ user_courses=0 — выяснил из chat-history: это «single course» дизайн, не баг.
- ✅ Список прошлых доработок — получен в файле «инфо правки фрутпед.txt», перенесён сюда.
- 🔑 Обновить `GITHUB_TOKEN` scope с `public_repo` на `repo` (нужно для создания приватного site-репо).
- 🌐 Прописать webhook URL в TipTop Pay панели: `https://fp.babichnail.online/api/confirm-payment.php` (когда терминал переключат на боевой).
- 🔒 Сменить пароль `gdl.php` на `video.babichnail.online` (см. `incident-2026-04-29-004-gdl-password-leak`).
- 💽 Долгосрочно: продумать чистку `.mov`-исходников из `/var/www/videos/` после успешной конвертации (диск занят на 52%, дальнейшие уроки забьют).
