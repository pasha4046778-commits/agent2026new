---
id: src-2026-05-06-lms-saas-multitenant-tech-breakdown
type: source
title: "Tech breakdown: миграция FrutPed → multi-tenant SaaS"
author: paganel
status: done
created: 2026-05-06T05:30:00Z
updated: 2026-05-06T05:30:00Z
tags: [source, tech-analysis, multi-tenant, lms, saas, php, mysql]
relates_to: [idea-lms-saas-platform, proj-fp-babichnail-online, infra-fp-babichnail-online, infra-video-babichnail-online]
source_for: [idea-lms-saas-platform]
---

# Tech breakdown: FrutPed → Multi-tenant SaaS

Step **C** of план Pavel'а 2026-05-05 (см. `idea-lms-saas-platform`).

Цель: разобрать, что конкретно надо переделать в текущем коде FrutPed, чтобы получить multi-tenant SaaS, и сколько это стоит по времени.

## Текущее состояние (single-tenant)
- **Code:** `/var/www/fp.babichnail.online/`. PHP 8.3 + nginx 1.24 + MySQL.
- **Document root:** `public_html/`. 27 файлов, ~150 KB кода.
- **DB:** `fruitpedicure` (916 KB). 7 таблиц: users, admins, courses, lessons, lesson_progress, user_courses, payments.
- **Конфиг:** `config.php` хардкодом — `SITE_URL`, `ADMIN_EMAIL`, `TIPTOP_PUBLIC_ID`, `TIPTOP_API_KEY`, `VIDEO_PATH`, `VIDEO_URL`.
- **Дизайн:** хардкодом в HTML/CSS — «Fruit Pedicure», цветовая палитра, фавикон-апельсин.
- **nginx vhost:** один на `fp.babichnail.online`. Document root жёстко прописан.
- **Видео:** `/var/www/videos/`, общий для всех (один tenant), отдача через `check-access.php` + token.
- **Email:** `info@galereya-krasoti.com` хардкодом.

Один клиент, один сайт, один DB, один admin, одна тема — типичный single-tenant.

---

## Как делать multi-tenant: ключевые решения

### 1. Изоляция данных в БД

Три варианта:

**A. Schema-per-tenant** (одна MySQL-инстанс, отдельная схема `tenant_<id>` под каждого клиента).
- ➕ Полная изоляция (если хакнут одну схему — другие живы).
- ➕ Backup/restore tenant'а независим.
- ➕ Простой SQL — приложение видит только свою схему.
- ➖ Migration painful: схема меняется → надо проходить по всем tenant'ам (50, 500 — управляемо; 5,000 — больно).
- ➖ Ресурсы: каждая схема = свой пул соединений, ~5-10 MB RAM на простой случай.

**B. Row-level (shared schema)** (одна таблица `users` с колонкой `tenant_id`).
- ➕ Простая миграция (один ALTER TABLE).
- ➕ Минимум ресурсов.
- ➖ Каждый SQL-запрос обязан фильтровать по `tenant_id` — забудешь однажды → leak между tenant'ами (катастрофа). Нужны guards в коде.
- ➖ Backup отдельного tenant'а сложнее (нужен `mysqldump --where="tenant_id=X"`).

**C. Database-per-tenant** (отдельный физический MySQL для каждого).
- ➕ Максимальная изоляция.
- ➖ Operational ад: 100 клиентов = 100 баз.

**Моя рекомендация для нашего масштаба:** **B (row-level) с строгим framework-обёрткой** запросов. Все SELECT/UPDATE/INSERT идут через хелпер, который автоматически добавляет `tenant_id = $current_tenant`. Reduces leak risk почти до нуля.

Если масштаб перевалит ~500 tenants и появится compliance-требование «изоляция on storage level» — мигрируем на (A). Но не сразу.

### 2. Routing: subdomain vs path

**A. Subdomain-per-tenant:** `<tenant-slug>.lms.example.com` → каждый клиент видит свой URL.
- ➕ Чище для SEO и брендинга клиента.
- ➕ Изолированы cookies (не leak'ают между tenant'ами).
- ➖ DNS wildcard A-record `*.lms.example.com → IP`. Клиент сам не управляет DNS.
- ➖ TLS: нужен wildcard certificate Let's Encrypt (можно через DNS-01 challenge) ИЛИ certbot per-subdomain (HTTP-01) — оба работают.

**B. Path-based:** `lms.example.com/<tenant-slug>/`.
- ➕ Один TLS cert.
- ➖ Cookies между путями могут утекать (нужно ставить `Path=` явно).
- ➖ Хуже для брендинга.

**C. Custom domains** (опционально, поверх любого варианта): клиент привязывает `kursy.tatyana.ru` к нашему серверу. Premium-feature.

**Моя рекомендация:** **A (subdomain)** с возможностью добавить custom domain для платных тарифов в V2.

### 3. White-label / теминг

Сейчас «Fruit Pedicure» хардкодом. Нужно вынести в БД:
- Имя школы (заголовок)
- Логотип / favicon (URL)
- Цветовая палитра (3-5 переменных в CSS-vars)
- Контакты (email, телефон, адрес)
- Тексты лендинга (программа курса, преимущества, отзывы — это уже content, не theming)

**Решение:** добавить таблицу `tenants` с этими полями, в шаблонах — `<?= $tenant->name ?>` вместо хардкода. CSS-переменные подгружаются динамически:
```php
echo "<style>:root { --primary: {$tenant->color_primary}; }</style>";
```

### 4. Видео-хост multi-tenant

Сейчас `/var/www/videos/` общий. Нужно изолировать.

**Варианты:**
- **Folder-per-tenant:** `/var/www/videos/<tenant_id>/`. Token-проверка получает `tenant_id` из URL, проверяет, что текущий пользователь принадлежит этому tenant'у.
- **Token подписан tenant_id:** в `check-access.php` встраиваем tenant_id в HMAC-секрет, токен невалиден если запрашивает чужие видео.

**Квоты:** в БД-таблице `tenants` хранить `storage_used_bytes`, при загрузке через `gdl.php` или admin upload — увеличиваем; cron periodically recalculate.

Кодек-конвертация (`video-convert.service`) тут уже multi-tenant nativeно работает — она реагирует на любые файлы в watched folder. Только обновить watcher на `inotifywait -m -r /var/www/videos/`.

### 5. Биллинг

Текущий `payments` — это НА учеников (которые покупают курс у tenant'а). Для биллинга tenant'ов (которые платят НАМ за подписку) — отдельная таблица `tenant_subscriptions` + интеграция с recurring-payment провайдером.

**TipTop Pay recurring:** вроде поддерживают, надо проверить документацию.
**ЮKassa recurring:** да, есть.
**Stripe:** не работает с РФ.

В MVP можно начать с **manual invoicing** (выставляем счёт через email, платят разом за месяц) — пока 5-20 клиентов это проще, чем городить recurring.

### 6. Self-service onboarding

Поток нового клиента:
1. Заходит на наш marketing-сайт (отдельный от LMS) → жмёт «Попробовать бесплатно».
2. Регистрируется (email + master-password).
3. Выбирает slug (`<tenant-slug>.lms.example.com`).
4. Получает trial 14 дней. Создаётся запись в `tenants`, добавляется DNS (через wildcard уже работает), добавляется default content.
5. Логинится в свой `<tenant-slug>.lms.example.com/admin/` и настраивает курс.
6. По истечении trial — выбирает тариф, вводит карту → recurring billing включается.

**Implementation:** скрипт provisioning'а, который при создании tenant'а:
- Insert row в `tenants`
- Создаёт default `courses[1]` пустой
- Создаёт default `admins[1]` (= переданный email + хэш пароля).
- Опционально добавляет `aliases:` для `<tenant>.lms.example.com` в DNS (если есть API провайдера) или этого делать не надо при wildcard A-record.

### 7. Owner-admin (для нас)

Отдельный slug — `admin.lms.example.com` (или просто `lms.example.com/admin/super`). Видим:
- Список tenants (status, plan, MRR contribution, signup date, last activity).
- Биллинг агрегированно.
- Support tickets.
- Аналитика (DAU/MAU по tenant'ам, churn, conversion trial→paid).

Это отдельная мини-админка. Месяц работы на её саму без слишком умных дашбордов.

### 8. Public marketing site

`lms.example.com` (root, без tenant-slug) — наш собственный лендинг продукта:
- Описание сервиса
- Pricing tiers
- Demo video
- Sign-up flow
- Blog / docs
- Footer (юр. инфо, оферта)

Это отдельный код от LMS-движка (или может быть тот же template-engine, отдельный сайт-конфигурацией).

---

## Concrete рефакторинг FrutPed-кода (как именно меняем)

### Этап 1: вычищаем хардкоды (1-2 недели)
1. Создать таблицу `tenants` (id, slug, name, email, plan, status, created_at, theme JSON, contacts JSON).
2. В `config.php`: вместо `define('ADMIN_EMAIL', ...)` — `$tenant = Tenant::loadBySubdomain($_SERVER['HTTP_HOST'])`. Все хардкоды вытащить в `$tenant->...`.
3. Убрать «Fruit Pedicure» из всех шаблонов → `<?= htmlspecialchars($tenant->name) ?>`.
4. Цвета — вынести в CSS-vars, переопределяемые на уровне tenant'а.
5. Логотип/favicon — динамический URL.

### Этап 2: tenant_id во всех таблицах (1 неделя)
1. `ALTER TABLE users ADD COLUMN tenant_id INT NOT NULL`. И на courses, lessons, payments, lesson_progress, admins, user_courses.
2. Миграция данных: для существующего FrutPed → `UPDATE * SET tenant_id = 1` (мы первый tenant).
3. Foreign keys: на `tenants(id)` через ON DELETE CASCADE.
4. Все SQL-запросы обернуть в helper, который автоматически добавляет `WHERE tenant_id = ?`. Это самая важная работа — пропустить хоть один запрос = data leak.

### Этап 3: routing на subdomain (3-5 дней)
1. nginx wildcard vhost: `server_name *.lms.example.com;`
2. Wildcard TLS: `certbot --dns-<provider>` — получаем `*.lms.example.com`.
3. PHP: парсим `$_SERVER['HTTP_HOST']`, тенант определяется до прочего кода.
4. Если subdomain не найден → 404 / редирект на marketing-сайт.

### Этап 4: видео isolation (1 неделя)
1. Реструктурировать `/var/www/videos/` → `/var/www/videos/<tenant_id>/`.
2. `check-access.php` получает `tenant_id` из URL pattern или из подписанного token'а.
3. Проверка cross-tenant: текущий пользователь принадлежит к `tenant_id`?
4. Migrate FrutPed videos: `mv /var/www/videos/*.mp4 /var/www/videos/1/`.
5. Update `gdl.php`: загрузка идёт в папку текущего tenant'а.

### Этап 5: tenant билинг (1-2 недели)
1. Таблица `tenant_subscriptions` (tenant_id, plan, started_at, ends_at, payment_method, status, last_paid_at).
2. Интеграция с recurring TipTop Pay или ЮKassa.
3. Trial-логика: 14 дней с момента создания tenant'а, потом downgrade на free (read-only) или suspend.
4. Webhook на наш биллинг-acquirer.

### Этап 6: provisioning + signup (1 неделя)
1. `lms.example.com/signup.php` — регистрация tenant'а.
2. Создание `tenants` row + default `admins[1]` + default `courses[1]`.
3. Email-уведомление новому tenant'у с ссылкой `<slug>.lms.example.com/admin/login.php`.

### Этап 7: owner-admin (3-4 недели)
Отдельная мини-админка для нас — список клиентов, метрики, биллинг, support.

### Этап 8: marketing-сайт (1-2 недели)
`lms.example.com` (без subdomain) — лендинг с pricing.

### Этап 9: testing + polish (2-3 недели)
- Cross-tenant data leak проверки (ручные + автотесты).
- Load test (50 одновременных tenant-сессий).
- Performance tuning.
- Docs.

---

## Total estimate

| Этап | Время (1 разработчик-агент full-time) |
|---|---|
| 1. Вычистить хардкоды | 1-2 нед |
| 2. tenant_id в БД | 1 нед |
| 3. Subdomain routing | 3-5 дней |
| 4. Видео isolation | 1 нед |
| 5. Биллинг | 1-2 нед |
| 6. Provisioning / signup | 1 нед |
| 7. Owner-admin | 3-4 нед |
| 8. Marketing-сайт | 1-2 нед |
| 9. Testing / polish | 2-3 нед |
| **Итого** | **12-19 недель ≈ 3-5 месяцев** |

Это для **полного MVP, готового брать платных клиентов**. Pre-MVP (вычистить хардкоды + tenant_id + subdomain — этапы 1-3) уже **позволяет вручную поднять 2-3 tenant'а** и проверить концепцию — это **3-4 недели**.

---

## Migration strategy: что делать с продакшен FrutPed

Чтобы не сломать живой курс Павла:

1. **Не редактировать `/var/www/fp.babichnail.online/` directly.** Делаем форк в `/var/www/lms-platform/` или новом git-репо `pasha4046778-commits/lms-platform`.
2. Развиваем форк до multi-tenant. FrutPed остаётся single-tenant до миграции.
3. Когда форк готов и протестирован → переносим FrutPed как первого tenant'а, его DNS меняем на `frutped.lms.example.com` (или оставляем `fp.babichnail.online` как custom-domain).
4. Оригинальный FrutPed-репо консервируется (read-only архив).

---

## Риски

1. **Cross-tenant data leak.** Любой пропущенный `WHERE tenant_id` = катастрофа. Нужны: helper для query'ев, code review, integration-тесты с двумя tenant'ами + asserts «один не видит данные другого».
2. **Subdomain DNS provisioning.** Если wildcard A-record не работает на каком-то DNS-провайдере, придётся вручную добавлять каждый. Beget — поддерживает (надо проверить).
3. **Recurring billing.** Если TipTop Pay recurring не подходит → переключаемся на ЮKassa (нужен переход у самого Pavel'а с TipTop). Может стать блокером на день.
4. **Performance.** Один MySQL для 100 tenants — должен справиться (наш FrutPed = 916 KB, 100 × 10 MB = 1 GB, ничего страшного). Но при 500+ tenants — partitioning / read replicas могут понадобиться.
5. **Support burden.** SaaS с 50 клиентами генерирует ~2-3 support-тикета в день. Один разработчик не выдержит индефинитно — нужен план найма.

---

## Sources / артефакты
- Текущий код FrutPed: `/var/www/fp.babichnail.online/` (27 файлов).
- Реальная инфраструктура: `infra-fp-babichnail-online`, `infra-video-babichnail-online`, `infra-server-pasha-beget`.
- Конкуренты для референса архитектуры: см. `src-2026-05-06-lms-saas-competitor-analysis`.
