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

## Новое направление: вторая система «Light System» (Лайт Систем) — 2026-08-25
Павел ставит задачу: добавить на существующий сайт fp.babichnail.online ВТОРОЙ курс — технику **«Light System»** (не новый сайт). От основателей «Фруктового педикюра».

**Что за техника:** ортониксия — коррекция вросшего ногтя и ониходистрофий прозрачными пластинами-«рессорами» (15 видов жёсткости, толщина 200/300/500/700 мкм, ширина 3-7мм). Клеевая система, приподнимает края ногтя (эффект «арки», анатомическая ротация). Автор: Вопилкина Елена (хирург-дерматовенеролог) + Вопилкин Евгений (к.ф.-м.н. ИФМ РАН). Разработка нижегородских подологов. Показания: вросший ноготь, онихолизис, онихогрифоз, онихомикоз; детская линейка с 0 лет. Материалы: методичка PDF (12 стр, в inbox), логотипы «Light System» (золотой отпечаток стопы + каллиграфия), фото продукта (клей 10г + прозрачные пластины). Всё в /root/.claude/channels/telegram/inbox/ (2026-08-25).

**Архитектурная находка (из кода):** сайт УЖЕ спроектирован под мультикурс — таблица `lessons` имеет `course_id` (сейчас захардкожен =1), таблица `user_courses` зарезервирована под доступ по курсам но пустая. Реальные таблицы: users, lessons, payments, lesson_progress, admins. Доступ сейчас = глобальный флаг `users.is_active` + `expires_at` (купил → видит ВСЕ уроки where is_active=1). Оплата (TipTop confirm-payment.php + Prodamus prodamus-webhook.php) ставит is_active=1, БЕЗ привязки к курсу. buy.php — одна захардкоженная цена 45000₸.

**Предложенный план (Вариант A — «правильный движок курсов», Павел ещё не финализировал):** справочник курсов; lessons.course_id=2 для новой системы; доступ через user_courses (per-course); payments.course_id; buy.php?course=N со своей ценой; webhook'и пишут user_courses; ЛК ученика фильтрует уроки по купленным курсам (вкладки если обе); дашборд админа — выбор курса у уроков, per-course доступ у учеников, статистика с разбивкой. Главная: описание 2 систем + переключатель, отдельный лендинг на каждую.

**Открытые вопросы Павлу:** цена курса Light System; авто-выдать существующим 10 ученикам доступ к «Системе 1» (рекоменд. да); разрешить докупку второй системы; сколько видеоуроков у Light System и где они; название/брендинг на сайте (золотой лого Light System).

**ДОСТУП-ограничение:** мой SSH-юзер pasha_paganel имеет ACL rwx на файлы public_html/ (могу читать/править код), но НЕ на ../config.php (секреты БД/платёжек закрыты) — к БД напрямую из CLI не подключиться. Дефолтный `php`=5.6, сайт на php8.3 (использовать `php8.3`), mysql-клиент /usr/local/bin/mysql. Для интроспекции БД нужен временный web-скрипт под FPM или запрос к Павлу.

## Light System — подтверждённые решения + реальная схема (2026-08-25, вечер)
Павел ответил на все вопросы, план утверждён:
- **Цена Light System (3 метода, инфраструктура УЖЕ есть в коде):** Prodamus (РФ) 13 000 ₽; TipTop (KZ) 60 000 ₸; ручной перевод на карту РФ (manual_ru) 11 000 ₽. Методы уже реализованы: confirm-payment.php=TipTop, prodamus-webhook.php=Prodamus, manual-payment.php+admin/manual-orders.php=ручной РФ.
- **Видео:** уже на YouTube, заливать на VPS через gdl.php (yt-dlp), ссылки пришлёт.
- **Ученики:** НЕ 10, а 73 активных (277 всего, 202 ждут активации, 13 уроков). Дашборд admin/students.php. Миграция: всем is_active=1 проставить user_courses→Курс 1.
- **Структура (Вариант 1 утверждён):** корень / = НОВАЯ развилка двух систем + переключатель; Фруктовый переедет на /frutped (страница 1-в-1, НЕ менять) + редиректы со старых ссылок; Light System на /light-system. Потом поправить success/webhook URL в кабинете TipTop под новые адреса покупки.
- **Брендинг Light System:** название «Light System», макет и шрифты как Frutped (Montserrat), палитра премиум-медицинская под золотой лого: золото/шампань #C9A24B (акцент), тёплый беж #F3E9DB (подложки), мраморно-белый #F7F5F2 (фон), графит #3A342C (текст). Ассеты (лого золотой отпечаток+каллиграфия, фото продукта клей+пластины) в /root/.claude/channels/telegram/inbox/. Frutped НЕ трогать.

### РЕАЛЬНАЯ СХЕМА БД (из дампа 2026-08-25) — мультикурс уже заложен физически:
- `courses`: id, title, description, price decimal, duration_days(365), is_active. 1 строка (Курс1=Фруктовый), next id=2.
- `user_courses`: id, user_id, course_id, purchased_at, expires_at, is_active. ПУСТАЯ (0 строк) — заполнить миграцией.
- `lessons`: id, **course_id**(есть!), title, description, video_path, video_type enum(file,url), video_url, thumbnail, duration_min, sort_order, is_active, created_at. 13-14 уроков, все course_id=1.
- `payments`: id, user_id, amount, currency, status, payment_method, transaction_id, created_at, updated_at. НЕТ course_id — единственное поле, что надо ДОБАВИТЬ.
- users: is_active + expires_at (текущий гейт доступа). admins, lesson_progress тоже есть.

### БД-доступ решён: creds в `/root/secrets/fp-db-creds.php` (DB_NAME/USER=pasha_fruitpedic, host localhost). Дамп/запросы гонять `mysqldump/mysql ... -u USER -pPASS DBN` ЧЕРЕЗ `ssh beget-fp` (mysql-клиент на Beget). Так работает ночной mirror-vps-backups.sh.

### БЭКАП перед стартом (сделан 2026-08-25): /root/backups/fp.babichnail.online/pre-lightsystem-20260825/ — db/pasha_fruitpedic-20260825.sql.gz (278 users) + code/frutped-public_html-20260825.tar.gz (34 php). config.php НЕ включён (нет прав чтения).

### План 6 этапов (утверждён, ждём финальный "go" на Этап 1):
1. Движок мультикурса: INSERT Курс2; +payments.course_id; миграция 73 активных→user_courses Курс1; гейт доступа переключить на user_courses (backward-compat). 2. Оплата ?course=N + 3 цены LS. 3. Витрина: развилка / + лендинг /light-system + перенос Frutped на /frutped+редиректы. 4. ЛК ученика: фильтр уроков по купленным курсам, вкладки если обе. 5. Дашборд: выбор курса у уроков, per-course доступ/статистика/оплаты. 6. Залив видео LS + e2e тест оплаты и доступа.

## ПРОГРЕСС Light System (2026-08-25, вечер) — Этап 1 ✅ + Этап 3 (видимая часть) ✅
**Этап 1 (движок мультикурса) — ВЫПОЛНЕН на боевой БД:**
- Курс 2 «Light System» создан (id=2, price 60000, 365 дней).
- payments.course_id добавлена, все 72 старые оплаты → course_id=1.
- Миграция: 75 активных (было 73 на скрине, стало 75) → user_courses course_id=1. Целостность 0/0 проверена.
- Frutped работает как раньше (код Этапа1 не трогал). Бэкап: /root/backups/fp.babichnail.online/pre-lightsystem-20260825/.
- БД-доступ: creds /root/secrets/fp-db-creds.php, запросы через `ssh beget-fp "mysql -u USER -pPASS pasha_fruitpedic -e ..."`.

**ВАЖНО про структуру сайта:** живой лендинг Frutped на корне = **`index.html`** (53609 байт, title «…| 2026»), НЕ index.php! На Beget index.html приоритетнее. (index.php была неактивная v2.)

**Этап 3 (витрина) — видимая часть ВЫПОЛНЕНА, задеплоена, ждём фидбэк Павла по дизайну:**
- Локальный worktree: `/root/.openclaw/workspace/fp-worktree/public_html/` (распакован из бэкапа; правлю тут → scp на beget-fp).
- НОВЫЙ `index.php` = развилка двух систем (Montserrat, беж-фон, 2 карточки: оранжевая Фруктовый→/frutped, золотая Light System→/light-system).
- `frutped.php` = точная копия живого `index.html` (лендинг Frutped, служит на /frutped).
- `light-system.php` = лендинг Light System (палитра золото #C9A24B/#8a6f3c/беж #F3E9DB/мрамор #F7F5F2/графит #3A342C; hero+лого, problems, stats 15 видов, галерея 3 фото, 7 модулей-программа из методички, price-блок с 3 ценами 60000₸/13000₽/11000₽, FAQ, footer; switchbar сверху для перехода между системами). Кнопка Купить → /buy.php?course=2.
- `.htaccess`: `DirectoryIndex index.php index.html` + rewrite /frutped→frutped.php, /light-system→light-system.php. mod_rewrite на Beget работает.
- Ассеты Light System: /assets/lightsystem/ (logo-gold.jpg, product-tray.jpg, product-glue.jpg, product-plate.jpg — последний оказался лого, не пластиной; попросил у Павла реальные фото процесса/до-после).
- Проверено: / =развилка(200), /frutped=живой лендинг(200, hero-cat.mp4 на месте), /light-system(200), /buy.php(200), /dashboard.php(302). Скрины отправлены Павлу (msg 1119-1121).

**ОСТАЛОСЬ:**
- Ждём фидбэк Павла по дизайну (палитра/развилка/фото).
- Этап 2: buy.php?course=2 — своя цена LS + 3 метода; webhook'и (confirm-payment.php/prodamus-webhook.php/manual-payment.php+manual-orders.php) должны писать user_courses(course_id) и payments.course_id. Кнопка Купить на LS пока ведёт на форму Frutped 45000 — НЕ покупать LS по-настоящему.
- Этап 4: dashboard.php/watch.php — фильтр уроков по купленным курсам (сейчас гейт по users.is_active показывает ВСЕ is_active уроки; переключить ДО заливки уроков course_id=2, иначе Frutped-ученики увидят LS-уроки).
- Этап 5: admin — выбор курса у уроков (add-lesson course_id захардкожен=1), per-course доступ у students, статистика/оплаты по курсам.
- Этап 6: залив видео LS (YouTube→gdl.php yt-dlp), e2e тест.
- Потом: обновить success/webhook URL в кабинете TipTop под новые адреса (Павел упоминал).

## Light System лендинг v2 (2026-08-26) — доработки по фидбэку Павла
Правки внесены и задеплоены на /light-system:
- Логотип: очищен ImageMagick (trim+white bg) из 1787668461939 → /assets/lightsystem/logo-clean.png (полный локап «Light System» на белом), вынесен на белую карточку в hero, крупнее.
- Анимации: добавлен scroll-reveal (IntersectionObserver + .reveal/.in классы, fadeInUp) на все блоки — как просил Павел «как у фруктового».
- Доп.инфа (файл «доп инфа лайт систем.txt»): программа 7→9 модулей. Добавлены модуль 07 «Раневой процесс и работа с вросшим ногтем» и 08 «Протезирование ногтевой пластины» (масса Владмива, восстановление утраченной части, комбинация с коррекцией).
- Новая секция «Результаты: до и после» — 6 клинических фото /assets/lightsystem/results/result-1..6.jpg (обработаны resize 900px). Источники: фото до/после Light System 1.5-7 мес.
- Ассеты результатов: result-1=«До/После Light Sistem 1,5мес», result-2=«Динамика 7 мес/Podoinstruktor_nastya» (ЧУЖОЙ ник — спросил Павла заменить/оставить), result-3=«март2024/окт2024», result-4/5/6 = прочие до/после.
- Скрин отправлен Павлу 3 частями (Telegram лимит: сумма сторон фото ≤10000, рендер был 1200x9065 — резать на части; wkhtmltoimage с --user-style-sheet reveal-off.css чтобы reveal-блоки были видны на статике).

ОТКРЫТО Павлу: (1) вотермарка чужого ника на фото result-2 — заменить? (2) прислать фото реальных пластин/процесса для продуктовой галереи (3-е фото пока лого). Дальше — Этап 2 (оплата LS).

## Light System лендинг v3 (2026-08-26) — правки Павла внесены
- Логотип hero: заменён на «ls Light System · корекционная система» (из 1787668484076, был в галерее) → logo-clean.png. Убран из галереи (осталось 2 фото: tray, glue).
- Название: «Light System + Протезирование» (h1), badge «ONLINE-курс · авторская методика». Title обновлён.
- Описание hero (текст Павла): «Прозрачная запатентованная система... разработанная совместно с Институтом физики микроструктур РАН. Более 5 лет успешной практики. Для мастеров педикюра и подологов.»
- Программа: заменена на чек-лист «На курсе» (13 пунктов Павла), блок «ПРОТЕЗИРОВАНИЕ» выделен золотом (.course-item.hot). Модули 01-09 удалены.
- Плашка «официальная регистрация с рег. номером» (.reg-badge) + строка в price-features.
- Вотермарки на фото-результатах оставлены (Павел: «не страшно»).
- Скрин v3 отправлен (msg 1136-1139). Ждём ОК Павла → Этап 2 (оплата LS).

## Light System лендинг v4 (2026-08-27) — карусель + юр-реквизиты
- Секция «до/после» переделана в КАРУСЕЛЬ (scroll-snap track + кнопки ‹ › + swipe на мобиле). CSS .carousel/.carousel-track/.carousel-btn, JS по data-car="results".
- ЮР-СТРАНИЦЫ: обнаружено что LS вёл на /offer.php,/privacy.php,/contacts.php — там ПЛЕЙСХОЛДЕРЫ. Живой Frutped использует .html-версии (offer.html/contacts.html/privacy.html) с РЕАЛЬНЫМИ реквизитами. Создал для LS свои: offer-ls.html, contacts-ls.html, privacy-ls.html (золотая палитра, курс «Light System + Протезирование», цены 60000₸/13000₽/11000₽). Футер LS обновлён на них (+ payment-security.php общий).
- РЕКВИЗИТЫ (ИП, для будущих задач): ИП Бабич-Гудебская Мария Викторовна, ИИН 930225400083, г. Актобе ул. Маресьева 4А, info@galereya-krasoti.com, +7 702 126 6054, Банк ЦентрКредит, БИК KCJBKZKX, ИИК KZ42 8562 2041 4645 8224, КБе 19.
- Ждём проверку Павла → Этап 2 (оплата LS). Павлу нужно: продукт в Prodamus под LS (13000₽) + реквизиты перевода (11000₽).

## Этап 2 старт (2026-08-27) — бэкап + разбор платежей + курсовая изоляция (Этап 4) ГОТОВА
БЭКАП: /root/backups/fp.babichnail.online/pre-payment-etap2-20260827/ (db 28K + payment-files tar: buy.php, api/confirm-payment.php, api/prodamus-webhook.php, api/manual-payment.php, admin/manual-orders.php, payment*.php).

ПЛАТЁЖНЫЙ ФЛОУ (разобран):
- TipTop: buy.php widget → externalId=user_id → webhook api/confirm-payment.php (InvoiceId=user_id, HMAC X-Content-HMAC, ставит is_active=1 +password +expires 365, payment_method 'tiptoppay').
- Prodamus RU: buy.php «Оплата из России» modal → POST /api/manual-payment.php → создаёт pending payment 'prodamus_ru' order FP-RU-XXXXX + redirect на RU_PRODAMUS_LINK='https://proeducation.kz/jpa0So/' (это Frutped-ссылка) + _param_user_id/order_id/customer_email → webhook api/prodamus-webhook.php (HMAC Sign, PRODAMUS_SECRET, ставит is_active=1). Сумма реальная из Prodamus.
- Ручной manual_ru: admin/manual-orders.php апрувит pending (manual_ru/prodamus_ru) → активирует.

КУРСОВАЯ ИЗОЛЯЦИЯ (Этап 4) — ВНЕДРЕНА и задеплоена:
- dashboard.php: уроки фильтруются по user_courses (owned course_ids), группировка по курсам если >1, backward-compat (активный без uc → курс1). Проверено на боевой: user id=3 → 13 уроков (как было).
- watch.php: проверка доступа к course_id урока через user_courses + backward-compat; prev/next в рамках курса.
- Тест: 75 активных все имеют uc course 1, 0 без uc. php8.3 -l чисто, HTTP 302.

ОСТАЛОСЬ Этап 2 (жду данные Павла для end-to-end):
- buy.php course-aware (?course=2 → LS цена/название, 3 метода). Branch: course=1 = как сейчас (Frutped не менять).
- confirm-payment.php: externalId кодировать 'userId-courseId' (без разделителя→курс1), писать user_courses(courseId)+payments.course_id.
- manual-payment.php: course-aware, LS Prodamus link (ЖДЁМ от Павла) для 13000₽.
- НОВЫЙ метод «перевод на карту РФ» 11000₽ (transfer_ru): нужны реквизиты карты от Павла; флоу pending→admin/manual-orders апрув→user_courses.
- admin/manual-orders.php: добавить transfer_ru + писать user_courses при активации.
- НУЖНО от Павла: (1) Prodamus-ссылка/продукт LS 13000₽; (2) номер карты+имя для перевода 11000₽.

## Этап 2 ЗАВЕРШЁН + протестирован (2026-08-27) — оплата Light System работает
Данные Павла: Prodamus LS = https://proeducation.kz/3jamku/ (13000₽); перевод Сбербанк карта 2202 2023 5005 4791 / тел +7 922 846-85-40 / получатель «Павел Г.» / без комментария (11000₽); TipTop тот же терминал, 60000₸.

РЕАЛИЗОВАНО (все файлы задеплоены + php8.3 lint чист):
- buy.php: мультикурс через $COURSES[$course_id] (?course=1|2). course=1 = Frutped БАЙТ-в-байт как было. course=2 = LS: TipTop 60000₸, кнопка Prodamus, НОВАЯ кнопка+модалка «Перевод на карту РФ» (Сбербанк реквизиты, копирование карты, «Я оплатил»→заявка). externalId кодируется "userId-courseId" (курс1 = просто userId, обратно совместимо). Оферта/политика ссылки по курсу.
- api/confirm-payment.php (TipTop webhook): парсит courseId из InvoiceId, payments.course_id, upsert user_courses.
- api/manual-payment.php: переписан, $COURSE_PAY per-course. method=prodamus (ссылка по курсу) | transfer (transfer_ru, 11000). Заявки с course_id, order-префикс FP/LS. Prodamus URL пробрасывает _param_course_id.
- api/prodamus-webhook.php: определяет courseId (param/из платежа), идемпотентность по СТАТУСУ платежа (не по is_active — важно для докупки 2-го курса активным юзером), грант user_courses, welcome-письмо только новым.
- admin/manual-orders.php: +transfer_ru в фильтрах, +course_id, грант user_courses при активации, авто-сверка теперь по наличию user_courses (мультикурс-безопасно), пароль не сбрасывается уже активным.
- dashboard.php/watch.php (Этап 4): фильтр уроков по user_courses (сделано ранее).

ТЕСТ (live, потом очищено): POST buy?course=2 → pending показал карту+60000+externalId 290-2; manual-payment prodamus→3jamku+13000+course_id=2; transfer→11000 transfer_ru; payments с course_id=2. Тестовый юзер 290 + платежи удалены, счётчики в норме (75 активных, 72 платежа).

НУЖНО от Павла (конфиг на его стороне):
- Prodamus: в продукте LS (3jamku) прописать Notification/webhook URL = https://fp.babichnail.online/api/prodamus-webhook.php (секрет PRODAMUS_SECRET тот же, если аккаунт один). TipTop — ничего не надо (тот же терминал/webhook).
- Перевод — ручное подтверждение в /admin/manual-orders.php.

ОСТАЛОСЬ до полного запуска LS:
- Этап 5: admin/add-lesson.php курс-селектор (сейчас course_id захардкожен=1) → уроки LS в course_id=2. Плюс admin/lessons.php фильтр/колонка курса, students per-course.
- Этап 6: залив видео LS (YouTube→gdl.php) как course 2. ВАЖНО: пока нет уроков course 2, покупатель LS увидит пустой кабинет — не продавать LS до заливки видео.

## Оплата LS — стилизация + правки (2026-08-27, вечер)
- buy.php: добавлен $back_url (course2→/light-system, course1→/frutped) + course-2 style override блок (золото #C9A24B/#8a6f3c, поверх базовой оранжевой; Frutped стиль НЕ тронут). features-list теперь из $C['features'] (LS: протезирование/офиц.регистрация; Frutped прежний). success/fail redirect'ы пробрасывают &course.
- payment-success.php + payment-fail.php: курсо-зависимы (?course), название/акцент/back-ссылки; retry на fail → /buy.php?course=N.
- Про TipTop (ответ Павлу): сумму настраивать в ЛК TipTop НЕ надо — виджет передаёт amount из кода страницы (LS=60000, FP=45000), один терминал, разные суммы по коду.
- Всё задеплоено, протестировано (course2=золото+LS-фичи+/light-system back; course1 не изменён).
ОСТАЛОСЬ: Павлу — webhook в Prodamus-продукте LS. Далее Этап 5 (admin курс-селектор add-lesson) + Этап 6 (видео LS).

## Этап 5 (админ курс-селектор) ГОТОВ + видео-пайплайн (2026-08-27)
ВИДЕО-ПАЙПЛАЙН (на этом VPS 46.8.79.53):
- Видео-хранилище: /var/www/videos/ (14 mp4, ~10.5G). Отдаётся через video.babichnail.online по ПОДПИСАННЫМ ссылкам (check-access.php + watch.php makeSignedVideoUrl, VIDEO_SECRET, TTL 4ч).
- yt-dlp /usr/local/bin/yt-dlp (v2026.03.17), gdown, ffmpeg — ЕСТЬ. gdl.php загрузчик в /var/www/videos/. Диск: 21G свободно (64%).
- Формат урока: video_type='url', video_url='https://video.babichnail.online/<file>.mp4', sort_order. Существующие: urok_01.mp4… (course 1).
- ПЛАН заливки LS: yt-dlp качает YouTube → /var/www/videos/ls_NN.mp4 (H.264 mp4) → INSERT lesson course_id=2, video_url на video.babichnail.online, is_active=1, по порядку.

АДМИН (Этап 5, задеплоено):
- admin/add-lesson.php: селектор курса (было захардкожено course_id=1), sort_order по курсу (JS MAX_ORDER), редирект на lessons.php?course=N.
- admin/edit-lesson.php: селектор курса + UPDATE course_id (можно перемещать урок между курсами).
- admin/lessons.php: фильтр-табы (Все/Fruit Pedicure/Light System) через ?course, колонка «Курс» (бейдж), +Добавить с курсом.
ОСТАЛОСЬ: admin/students.php per-course доступ (не критично для заливки). Ждём YouTube-ссылки LS от Павла → качаю + создаю уроки course 2 + тест.
