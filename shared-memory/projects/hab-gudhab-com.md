---
id: proj-hab-gudhab-com
type: project
title: hab. — цифровая мастерская на gudhab.com
author: paganel
status: in_progress
created: 2026-05-18T04:42:00Z
updated: 2026-05-22T20:40:00Z
tags: [project, hab, web, studio, multilingual, b2b]
relates_to: [infra-server-vps-latvia, feedback-hab-design-direction]
---

# hab. — цифровая мастерская

## Описание
Pavel и я (Paganel как Tech Lead) строим digital-product студию **hab.** на домене **gudhab.com**. Принимаем брифы клиентов, делаем сайты и веб-приложения. Цикл: бриф → согласование → демо за 48 ч → 70% предоплата → доработка и релиз → поддержка.

## Цель
Запустить продаваемую студию с автоматическим приёмом лидов через сайт. Сейчас в режиме pre-launch — сайт готов и публичен, ждём первых реальных клиентов.

## URLs и инфра
- **Прод:** https://gudhab.com (TLS Let's Encrypt; nginx 80→443→127.0.0.1:3001)
- **ОБНОВЛЕНО 2026-08-13:** после декоммишена Латвии сайт живёт на **Paganel host 46.8.79.53** — источники `/root/hab-site/`, systemd `hab-site.service` (Next 15.5, порт 3001), активен. Латвийский VPS 155.212.230.121 больше не используется.
- **Деплой сейчас (локально на хосте):** edit `/root/hab-site/src` → `cd /root/hab-site && npm run build` → `systemctl restart hab-site` (rsync/ssh в Латвию больше не нужен).
- **Telegram-бот:** @habnotifier_bot (id 8987612976), уведомляет Pavel'я в DM (chat_id 1097461410) при новом брифе
- **Email уведомления:** пока не настроены (Resend API key не выдан)
- **DNS:** A-record gudhab.com → 155.212.230.121 (плюс www), MX → mx1/mx2.beget.com (Beget mail — настройка ящиков отложена)

## Текущий статус (на 2026-05-22)
- v0.7 фактически развёрнут, ~32 коммита в репо `/root/hab-site/.git`
- Next.js 15.5.18 (CVE-clean), React 19, Tailwind 4, SQLite, better-sqlite3
- next-intl scaffold с 3 локалями (ru / en / kk). RU контент полный, EN/KK только Nav + Footer переведены, основной контент пока на русском в обеих не-RU локалях
- 12 индустриальных шаблонов в `/demo/<slug>` (RU только, по выбору Pavel'я)
- Админка в `/admin/*` (ru-only, под паролем) — брифы + курсы валют + сессии
- Brief-форма 9 шагов с zod-валидацией, после submit делает Telegram уведомление + лог в `brief_notifications`
- Цены показываются во всех 3 валютах (RUB/USD/KZT) одновременно, курс задаётся в админке `/admin/rates`
- Hero-статы синхронизированы с реальными данными: `cases.length` (=5), `templates.length` (=12), `cases.filter(type==='product').length` (=2), 48ч отклик

## Что уже сделано (v0.7)
- v0.7 Stage 1A: брендовые ассеты Amber (favicon/icon/og-image/wordmark) + OG-метаданные
- v0.7 Stage 1B: next-intl scaffold с локалями ru/en/kk, language switcher
- v0.7 Stage 1C: 3-валютные цены (RUB/USD/KZT) + админка курсов валют
- v0.7 Stage 2: новые страницы `/about`, `/process`, `/guarantees`
- v0.7 Stage 3: motion polish (node-pulse, breathing CTA, card-glow)
- v0.7 round 1-3 правки Pavel'я: сетка, цены, валюты, footer-фон, favicon, и т.д.
- v0.7 site-wide grid с импульсами (бегут по линиям сетки)
- /legal/privacy + /legal/offer написаны и опубликованы (GDPR-tone, RU-text, 10/13 секций)
- /guarantees блок «Защита данных и NDA» переписан без 152-ФЗ, в международном тоне
- /guarantees возврат 50% оставлен, расплывчатый full-refund clause убран

## Открытые вопросы / waiting on Pavel
1. **Аудит студий Amber (новое 2026-05-22 вечер)** — Pavel прислал 4 файла: CSV (102 студии CIS+EU), HTML-dashboard, 2 md-репорта. Сохранены в `research/studios-audit/`. Я предложил 4 улучшения на основе данных:
   - **(a)** Metrics во все 5 кейсов в `data/cases.ts` (сейчас только у 3)
   - **(b)** Trust-row блок на главной (5 проектов · 12 индустрий · 2 продукта · 48ч отклик — но в виде «доказательной плашки», не как stats grid в Hero)
   - **(c)** Tagline переформулировать в outcome-based — «Запускаем работающий сайт за 4-6 недель» вместо «Хаб цифровых продуктов»
   - **(d)** Industries как proof — секция «12 индустрий с готовыми решениями» с чипами
   - **Pavel должен сказать что из 4 делать и в каком порядке.** Это первый пункт следующей сессии.

2. **Юр. реквизиты Студии** для `/legal/offer` — Pavel сказал «позже добавим». Нужны ИП-имя, ОГРНИП, ИНН, БИК, расчётный счёт. Сейчас в оферте просто «hab.» без реквизитов.

3. **Stage 4 — wildcard серт `*.gudhab.com` + subdomain-инфра для клиентских демо.** Отложено до появления первого реального клиента (Pavel: «пока отложим»). Beget может до 100 поддоменов на основном домене.

4. **Переводы main-контента на EN и KK.** Отложено до завершения всех доработок (Pavel: «сделаем в последний момент»).

5. **Beget-почта `hi@gudhab.com`.** Отложено (Pavel: «сделаем чуть позже»). MX-записи уже стоят, нужно только создать ящики в панели Beget.

6. **Resend для email-уведомлений о брифах.** Отложено (Pavel: «сделаем позже»). Код в `lib/notify.ts` уже готов, ждёт `RESEND_API_KEY` + `NOTIFY_EMAIL_TO` в env.

## Ближайшие шаги (на завтра)
- Дождаться приоритизации Pavel'я по 4 предложениям на базе аудита (a/b/c/d)
- Применить выбранные

## Риски / ограничения
- Pavel находится в Казахстане, использует Beget для DNS и (планируется) почты. Юр. оформление возможно как ИП в КЗ или ИП в РФ — пока не решено.
- Платежи: для приёма международных RUB→USD/KZT может понадобиться Paddle/LemonSqueezy MoR-схема. Сейчас в оферте указано «по счёту», без онлайн-эквайринга.
- next-intl middleware не покрывает /admin и /demo (by design), но если кто-то залогинится в админку с en/kk локали в URL — UI всё равно русский, это OK для внутреннего инструмента.
- Stage 4 (wildcard cert) — DNS-01 challenge через Beget API не делал, может потребовать time или альтернативный путь.

## Связанные источники
- Гайдбук бренда от Amber: `/root/.openclaw/workspace/brand/hab-brand-guidebook-v1.md`
- Аудит студий от Amber (2026-05-22): `/root/.openclaw/workspace/research/studios-audit/` (4 файла: CSV + HTML + 2 md)
- Локальный source: `/root/hab-site/` (git tracked, 32+ commits)
- Latvia VPS детали: `shared-memory/infra/server-vps-latvia.md` + auto-memory `reference_vps_latvia.md`

## Что нужно от Павла (на завтра — сразу)
1. **Приоритизация 4 пунктов на базе studio-аудита (a/b/c/d)** — что делать, в каком порядке. Это первое сообщение в треде #135.
2. (Опционально) — новый список правок если что-то ещё заметил за вечер.
