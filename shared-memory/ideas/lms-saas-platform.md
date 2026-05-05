---
id: idea-lms-saas-platform
type: idea
title: LMS SaaS-платформа для нишевых курсотворцов (на базе FrutPed)
author: paganel
status: in_progress
created: 2026-05-05T20:40:00Z
updated: 2026-05-05T20:40:00Z
tags: [idea, lms, saas, business, frutped]
relates_to: [proj-fp-babichnail-online, infra-fp-babichnail-online, infra-video-babichnail-online]
source_for: []
---

# LMS SaaS-платформа

## Что это
Multi-tenant SaaS на базе нашей FrutPed-LMS: тренеры/коучи/курсотворцы регистрируются, получают свой брендированный лендинг + кабинет учеников + защищённый видеохостинг + приём оплат, без необходимости разворачивать инфру самим. Платят подписку.

## Value proposition (кому и зачем)
**Целевая аудитория:** тренеры в нишах, где обучение делается через короткие практические курсы. Маникюр, барбер, массаж, фитнес, кулинария, hand-made, beauty (включая FrutPed-аудиторию Pavel'а).

**Боль клиента:**
1. Не хочет/не умеет ставить серверы, настраивать SSL, кодить.
2. Готовые конструкторы (Tilda + Kinescope) — дорого и сегментированно (платишь за лендинг, за видео, за приём платежей по отдельности).
3. Гиганты типа Getcourse — мощно, но 3000+ ₽/мес минимум, перегружено фичами, тяжёлая кривая обучения.
4. YouTube для платных видео-уроков — нельзя контролировать доступ, лимиты, есть копирайт-боты.

**Наше предложение:** «Запусти свой курс за 1 день. Лендинг, кабинет учеников, защищённое видео, оплаты — всё в одном. От ~990 ₽/мес.»

**Edge относительно конкурентов:**
- Цена ниже Getcourse в 2-3 раза.
- Готовое из коробки, не надо собирать из 5 сервисов как Tilda+...
- Self-hosted infra под капотом (мы её уже построили) — лучше юнит-экономика чем reseller-моделей.
- Защищённый видеохостинг встроен (наш токен-протектед механизм + авто-конвертация HEVC/VP9→H.264).
- Русскоязычная поддержка.

## Что у нас УЖЕ построено (переиспользуется в SaaS)
- LMS-ядро: лендинг, buy-flow, личный кабинет, watch-page, admin-panel (`/var/www/fp.babichnail.online/`).
- Платежная интеграция: TipTop Pay widget + webhook + activation flow.
- Защищённый видеохостинг: token-URLs, `check-access.php`, авто-конвертация (`video-convert.service`), `gdl.php` загрузчик с Drive/YouTube.
- Email-уведомления.
- БД-схема: users, courses, lessons, user_courses, payments, lesson_progress, admins.
- Дизайн-система (Pantone 2026 + Montserrat).
- Backup/recovery: mysqldump cron + offsite mirror.
- Vaultwarden для секретов клиентов.

## Чего НЕ хватает для SaaS
1. **Multi-tenancy.** Сейчас single-tenant (один курс, один admin, один сайт). Нужно: изоляция данных между клиентами, отдельные домены/субдомены, независимые админки.
2. **Биллинг.** Recurring subscriptions для самих клиентов SaaS (не путать с разовой оплатой курса учеником). Кто платит нам — сами курсотворцы.
3. **Self-service onboarding.** Регистрация → выбор тарифа → автоматический provisioning субдомена → клиент попадает в свой админ-кабинет.
4. **White-label.** Клиент должен мочь поставить свой логотип/название/палитру. Сейчас всё хардкодом «Fruit Pedicure».
5. **Quota / limits.** Видео GB, кол-во курсов, кол-во учеников — лимиты по тарифу.
6. **Owner-admin.** Админка для нас (видеть всех клиентов, биллинг, MRR, churn, support tickets).
7. **Public marketing site.** Сам SaaS-лендинг с pricing, FAQ, sign-up flow, demo.
8. **Сustomer support.** Чат / docs / FAQ. Минимум — email-канал.
9. **Legal.** Договор-оферта на оказание услуги, политика обработки данных, terms.

## Размер задачи (high-level эстимат)
- **MVP без излишеств:** 3-6 месяцев фулл-тайм работы Paganel'а (1 разработчик).
- **Production-ready с фичами выше пилота:** 6-12 месяцев.
- Это для архитектуры single-binary multi-tenant. Если раздуваться до микросервисов — дольше и сложнее, но не оправдано на старте.

## Открытые вопросы / неясности
- **Юр. оформление:** ООО / ИП / самозанятость. Где регистрировать (РФ / Казахстан / другая)? Pavel сам определяет.
- **Платёжный провайдер для нас:** TipTop Pay принимает recurring? Или Stripe (но он не работает с РФ)? Cloudpayments? ЮKassa?
- **Хостинг при росте:** на текущем VPS уместятся первые ~50 клиентов с осторожностью. Дальше — отдельные машины / Kubernetes? Не сразу, но архитектурно учесть.
- **Конкуренты:** см. идущий competitor analysis (B-этап плана).
- **Pricing:** см. идущий unit-economics (D-этап плана).

## Связи
- `proj-fp-babichnail-online` — родительский проект, основа кода.
- `infra-fp-babichnail-online` — продакшен инфра (текущий single-tenant).
- `infra-video-babichnail-online` — видеохост.
- Будущий: `proj-lms-saas-platform` (если перейдём из идеи в проект).

## Следующие шаги (план Pavel'а 2026-05-05)
- ✅ A. Зафиксировать идею (этот файл).
- ⏳ B. Competitor analysis (Getcourse, Tilda+Kinescope, Bizon365, Salebot, etc.).
- ⏳ C. Tech-разбор multi-tenant миграции FrutPed.
- ⏳ D. Unit economics: цены, costs, breakeven.
- ⏳ Решение go/no-go на основе A-D.
