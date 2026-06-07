---
id: proj-fp-babichnail-online
type: project
title: fp.babichnail.online (FrutPed) — Fruit Pedicure LMS
author: paganel
status: in_progress
created: 2026-04-29T05:35:00Z
updated: 2026-06-07T13:15:00Z
tags: [website, lms, priority, frutped, manual-payment, ru-sanctions, prodamus]
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
- ✅ TipTop Pay в боевом режиме — Pavel подтвердил 2026-05-25.
- 🔑 Обновить `GITHUB_TOKEN` scope с `public_repo` на `repo` (нужно для создания приватного site-репо).
- 🌐 Прописать webhook URL в TipTop Pay панели: `https://fp.babichnail.online/api/confirm-payment.php` (если ещё не прописан с момента перехода на боевой).
- 🔒 Сменить пароль `gdl.php` на `video.babichnail.online` (см. `incident-2026-04-29-004-gdl-password-leak`).
- 💽 Долгосрочно: продумать чистку `.mov`-исходников из `/var/www/videos/` после успешной конвертации (диск занят на 52%, дальнейшие уроки забьют).
- ⏸️ Открытый вопрос: origin TLS-сертификат на shared (раньше edge-SSL от Beget; сейчас актуальность не проверена).
- ⏸️ Открытый вопрос: `user_courses` остаётся под мульти-курс — пока не нужно.

## 2026-05-25 — Manual RU-payment flow (санкции)

Контекст: Pavel сказал, что из-за санкций оплата картами РФ через TipTop Pay не работает. Нужна параллельная вторая кнопка «Оплата из России» с переводом на физ.карту Райфа.

### Что сделано

**SSH-доступ восстановлен:** прошлый Paganel ходил на Beget через скомпрометированный VPS (`adkutxwhda`/85.198.84.47), который вывели из эксплуатации 17 мая. Pavel завёл выделенного SSH-пользователя `pasha_paganel` (uid 790714, gid 601 newcustomers, login=pasha, shell=bash) на `pasha.beget.tech` (DNS → 91.106.207.30 / shared host `sakura.beget.ru`). Мой паблик-ключ `paganel_vps_ed25519.pub` установлен в `~/.ssh/authorized_keys` пользователя. Локально на Paganel host добавлен ssh-alias `beget-fp` в `~/.ssh/config`:
```
Host beget-fp
    HostName pasha.beget.tech
    Port 22
    User pasha_paganel
    IdentityFile ~/.ssh/paganel_vps_ed25519
    IdentitiesOnly yes
```
Home-каталог = document-root: `/home/p/pasha/fp.babichnail.online/public_html`. Файлы owned by `pasha:newcustomers` через extended ACLs — мой `pasha_paganel` тоже в группе `pasha`, видит файлы. `config.php` chmod 700 не читается мой шеллом, но PHP-FPM работает как `pasha` так что любые скрипты с `require '../config.php'` живут нормально. Schema/функции можно интроспектировать через token-guarded probe-страницу в webroot (token: `paganel-2026-introspect-x4f7q9z2`).

**Цена в RUB:** 8 000 ₽ за курс (хардкод в `manual-payment.php` константой `RU_AMOUNT_RUB`). Стандартная цена в KZT = 45 000 ₸ (TipTop). Перевод по реквизитам: Raiffeisen Bank · Бабич Кирилл · `2200 3005 1739 0314`. После оплаты — чек в Telegram `@gudpavel88`.

**Изменения в коде:**

1. **`/buy.php`** — после POST формы теперь две кнопки вместо одной:
   - 🔵 «Оплатить 45 000 ₸» — TipTop Pay (как и был, не сломан)
   - 🇷🇺 «Оплата из России» — открывает модалку

   ⚠️ Поведенческое изменение: убран `window.addEventListener('load', startPayment)` — теперь TipTop не запускается автоматически. Пользователь должен явно кликнуть. На один клик больше для KZT-покупателей, но даёт выбор. Бэкап `buy.php.bak-pre-manual-ru-20260526-012806` сохранён.

2. **Модалка «Оплата из России»** (HTML/CSS/JS inline в `buy.php`):
   - Текст-преамбула про санкции
   - Сумма к переводу: 8 000 ₽
   - Блок реквизитов с copy-to-clipboard для номера карты
   - Кнопка «Подтвердить и открыть Telegram» → AJAX POST на `/api/manual-payment.php`
   - После успеха — показывает order_id и кнопку «Открыть Telegram @gudpavel88 →» с pre-filled сообщением

3. **`/api/manual-payment.php`** (новый, ~8 KB):
   - POST {user_id, email} → валидация юзера + email match
   - Re-uses existing pending заявку если есть (идемпотентно)
   - Иначе генерит `order_id = FP-RU-XXXXX` (5 цифр, проверка на коллизии)
   - INSERT в `payments`: amount=8000, currency=RUB, status=pending, transaction_id=order_id, payment_method=manual_ru
   - UPDATE users: payment_method=manual_ru, notes=pending_manual_ru
   - Отправляет 2 письма: клиенту (реквизиты + инструкция) и админу (новая заявка)
   - Возвращает JSON {ok, order_id, telegram_url, amount, currency}
   - Pre-filled Telegram URL формата `https://t.me/gudpavel88?text=<URL-encoded>` с многострочным текстом:
     ```
     Оплата FrutPed
     Order: FP-RU-XXXXX
     Email: ...
     Имя: ...
     Сумма: 8 000 ₽
     ```

4. **`/admin/manual-orders.php`** (новый, ~11 KB):
   - Auth-gated (session admin_id)
   - Таблица всех manual_ru-заявок (pending сверху)
   - Колонки: Order, Клиент, Контакт, Сумма, Создана, Статус, Действие
   - Для status=pending: кнопки «✓ Активировать» (с confirm) и «Отмена»
   - «Активировать» делает то же, что webhook TipTop: generatePassword(12), password_hash, expires_at +365d, is_active=1, notes=NULL, payment.status=completed, → sendWelcomeEmail (теперь с TG-group ссылкой)

5. **Sidebar nav во всех `/admin/*.php`** — добавил `<a href="/admin/manual-orders.php">🇷🇺 Ручные RU</a>` между «Платежи» и «Настройки» (sed-патч, бэкапы `admin/*.bak-pre-manual-link`).

6. **`sendWelcomeEmail` в `config.php`** — добавлен абзац с приглашением в Telegram-группу `https://t.me/+atqO6vaBZbhmOGFi`. Бэкап `config.php.bak-pre-tg-group-20260526-014403`. Письмо теперь содержит:
   - Email + пароль для входа
   - Ссылка на /login.php
   - Срок доступа (1 год)
   - **Новое:** ссылка на TG-группу «Фруктовый педикюр»
   - Подпись

### DB-схема — миграции НЕ потребовались
Все нужные колонки уже были в схеме:
- `users.payment_method varchar(50)` (для значения `'manual_ru'`)
- `users.notes text` (для `'pending_manual_ru'`)
- `payments.payment_method varchar(50)` (для `'manual_ru'`)
- `payments.status varchar(50)` (для `'pending'/'completed'/'cancelled'`)
- `payments.transaction_id varchar(255)` (для order_id `FP-RU-XXXXX`)
- `payments.currency varchar(3)` (для `'RUB'`)

### Тестирование
End-to-end проверено через curl: form POST → user create → manual-payment POST → JSON ok с order_id `FP-RU-16210`, telegram_url корректный. Тестовые юзеры (`paganel-test-*@example.com`) удалены из БД.

### Backup-стратегия
Все изменённые файлы имеют рядом `.bak-pre-...` копии. Откат — `cp filename.bak-* filename`.

## 2026-05-28 → 2026-06-07 — Prodamus вместо Raiffeisen + текущая боевая воронка

Pavel решил: ручной перевод на карту Райфа неудобен (телеграм-скрин, ручная активация). Заменили на полный hosted-payment через **Prodamus** (pronails.proeducation.kz). Карты РФ обрабатывает Prodamus, мы получаем webhook.

### Сделано (2026-05-28)
- **`/buy.php`**: убран Raiffeisen-блок (банк/карта/copy/telegram-pre-fill). Модалка теперь — короткое объяснение «оплата картами РФ через Prodamus, безопасно, без VPN, доступ за час», кнопка «Перейти к оплате →». Никакого order_id-в-Telegram не показывается клиенту (он остался внутри для webhook). Шапка покупки получила подпись «Оплата через TipTop Pay (все страны) или Prodamus для РФ». Основная кнопка переименована «Оплатить 45 000 ₸» → «Оплата (все страны)».
- **`/api/manual-payment.php`** (тот же endpoint, переделан): payment_method теперь `prodamus_ru`, возвращает `pay_url` = `RU_PRODAMUS_LINK . '?customer_email=…&order_id=FP-RU-…&_param_user_id=…'`. Поля проброшены в Prodamus, вернутся в webhook. Letter админу адаптирован.
- **`/api/prodamus-webhook.php`** (новый): принимает POST, валидирует HMAC-подпись по `PRODAMUS_SECRET`, ищет юзера по order_id → param_user_id → email, активирует (generatePassword + sendWelcomeEmail + payment.status=completed). Идемпотентен. Если PRODAMUS_SECRET не определён — отвечает 200 «secret not configured» (безопасный noop). Лог `/api/prodamus-webhook.log`.
- **`/admin/manual-orders.php`**: query расширен на `payment_method IN ('manual_ru','prodamus_ru')`. Карточка-описание перешита: упомянут Prodamus, объяснён вариант webhook vs ручной активации. Auto-reconcile при заходе (если юзер активен — заявка → completed) сохранён.

### Правки 2026-06-01 (Pavel дал новую Prodamus-ссылку)
- `RU_PRODAMUS_LINK` обновлён: `https://proeducation.kz/779ZGe/` → `https://proeducation.kz/jpa0So/`
- Сумма в RU-модалке изменена: «45 000 ₸ ≈ 8 500–9 000 ₽» → «41 900 ₸ ≈ 9 000 ₽» (Prodamus берёт 9 000 ₽ ≈ 41 900 ₸). Шапка цены курса осталась 45 000 ₸ (TipTop), это для KZT-покупателей.

### Боевые цифры (на 2026-06-07)
- prodamus_ru completed: **10** реальных оплат за 9 дней (29.05–07.06)
- prodamus_ru pending: **15** — часть из них тоже реально оплатили, но Pavel их активирует руками через `/admin/manual-orders.php` или `/admin/students.php`. Активация ручная т.к. **PRODAMUS_SECRET до сих пор не вписан**.
- Кнопка работает — за 9 дней принесла больше реальных оплат, чем предыдущий Raiffeisen-вариант (3 за неделю).

### Открытое — ждёт Pavel'я
- **PRODAMUS_SECRET** не передан (9 дней — отказался от автоматизации, сказал «учеников отслеживаю»). Webhook лог пуст кроме одной тестовой записи 29.05. Если Pavel в будущем согласится — нужно: (1) скрин нижней части настроек платежной формы Prodamus → подскажу куда вписать Notification URL `https://fp.babichnail.online/api/prodamus-webhook.php` + где Секретный ключ; (2) Pavel шлёт ключ в DM, я инжектю `define('PRODAMUS_SECRET','…')` в config.php через web-patch.
- **GitHub fp-site PAT** истёк (GitHub письмо 2026-06-07). Я никогда не использовал этот PAT с Paganel-хоста — он жил на decommissioned VPS (85.198.84.47) и пушил репо `pasha4046778-commits/fp-site` оттуда. Сейчас разработка идёт напрямую на Beget через SSH, github-зеркало неактивно. Если Pavel хочет восстановить — нужно: (a) сгенерить новый fine-grained PAT scoped на repo `fp-site`; (b) положить в `/root/secrets/github_token_fp_site.txt`; (c) настроить git remote в `/home/p/pasha/fp.babichnail.online/` на Beget и пушить оттуда. Спросить Pavel'я, нужно ли вообще — git-зеркало не критично, поскольку мы делаем .bak-файлы рядом с каждым изменением.

### Бэкап-стратегия (Beget)
Каждое моё изменение оставляет `.bak-pre-<change>-<timestamp>` рядом с файлом. На 2026-06-07 в репо около 13 .bak-файлов (от manual-payment, prodamus, admin/manual-orders, sidebar nav и т.д.). При откате — `cp file.bak-… file`.
