---
id: src-web-dev-kb-index
type: source
title: "Web KB: Index / Navigation"
author: paganel
status: done
created: 2026-05-07T20:35:00Z
updated: 2026-05-07T20:35:00Z
tags: [web-dev-kb, index, navigation]
relates_to: [src-web-dev-kb-design-trends, src-web-dev-kb-frontend-stack, src-web-dev-kb-css-modern, src-web-dev-kb-performance, src-web-dev-kb-backend-stack, src-web-dev-kb-accessibility-seo, src-web-dev-kb-ai-tools-for-web, src-web-dev-kb-russia-cis-specifics, src-web-dev-kb-tools-and-services]
source_for: []
---

# Web Development Knowledge Base — Index

Структурированный справочник по созданию сайтов 2024-2026. Не «учебник», а **рабочий референс**: что использовать, что устарело, как принимать решения.

## Файлы

| Файл | Что внутри |
|---|---|
| **[design-trends-2024-2026](./design-trends-2024-2026.md)** | Pantone Cloud Dancer, Powdered Pastels, Bento layouts, brutalism, variable fonts, View Transitions. Anti-trends. По типам сайтов. |
| **[frontend-stack](./frontend-stack.md)** | React 19 / Vue 3 / Svelte 5 / Astro 5 / Solid / Qwik / HTMX. Build tools. State / Routing / Forms. shadcn/ui. Что мёртво. |
| **[css-modern](./css-modern.md)** | Container queries, `:has()`, cascade layers, View Transitions, OKLCH. Tailwind v4. Modern reset. |
| **[performance](./performance.md)** | Core Web Vitals 2024-2026 (INP вместо FID). Optimization tactics. Image / bundle / CDN strategy. |
| **[backend-stack](./backend-stack.md)** | Architectures (monolith / edge / BFF). Languages. Headless CMS. DB. ORM. Auth. APIs. Real-time. Search. |
| **[accessibility-seo](./accessibility-seo.md)** | WCAG 2.2 + AI search era. Schema.org. Yandex SEO. Local SEO. |
| **[ai-tools-for-web](./ai-tools-for-web.md)** | Cursor / Copilot / Windsurf / Claude Code. v0 / Lovable / Bolt. AI for design. Что AI НЕ умеет. |
| **[russia-cis-specifics](./russia-cis-specifics.md)** | Платежи (ЮKassa, СБПэй). Хостинг (Beget, Selectel). 152-ФЗ. Yandex.Webmaster + Metrica. Tilda и Bitrix. |
| **[tools-and-services](./tools-and-services.md)** | Curated list инструментов: editors, frameworks, libs, services, by-category. |

## Quick decision matrix — «когда что брать»

### Тип проекта → стек

| Проект | Stack |
|---|---|
| Static маркетинговый | **Astro** + Tailwind + shadcn (через Astro) |
| SaaS / web app | **Next.js 15** + React 19 + Tailwind + Prisma + Postgres + Auth.js |
| Лендинг + payment | **Astro** + ЮKassa integration |
| Сложное SPA / dashboard | **React** + Vite + TanStack Query/Router + Tailwind |
| Document / blog | **Astro** Content Collections или **VitePress** |
| Mobile app | **React Native + Expo** или **PWA** |
| Embed widget | **Web Components + Lit** |
| AI-агент / chatbot | Backend (Hono/FastAPI) + WebSockets + LLM API |
| E-commerce | **Medusa** или **Shopify Hydrogen** или **InSales** (RU) |

### Стартовый шаблон

```bash
# SaaS / web app — universal default
npx create-next-app@latest --ts --tailwind --app

# Static / content
npm create astro@latest

# SPA
npm create vite@latest -- --template react-ts

# Mobile
npx create-expo-app
```

### Размер JS bundle norm

| Тип | OK | Excellent |
|---|---|---|
| Маркетинг | < 80 KB | < 30 KB |
| SaaS | < 250 KB | < 100 KB |
| E-comm | < 200 KB | < 80 KB |
| Docs | < 50 KB | < 10 KB |

## Core Web Vitals targets (2024+)

| Метрика | Target |
|---|---|
| LCP | ≤ 2.5s |
| INP (заменил FID) | ≤ 200ms |
| CLS | ≤ 0.1 |

## Top-10 «обязательно» в новом проекте

1. TypeScript включён, `strict: true`
2. Tailwind v4 для стилей
3. shadcn/ui для компонентов (если React)
4. ESLint + Prettier configured
5. Vitest для unit tests
6. Playwright для E2E
7. Sentry для errors
8. Analytics (GA4 или Plausible или Yandex.Metrica)
9. Modern CSS reset
10. `next/image` (или Astro Image) для optimised images

## What's dead / dying в 2026

| Tech | Status | Replacement |
|---|---|---|
| jQuery | Dead | Native DOM / Vue / React |
| Lodash | Dying | Native methods |
| Moment.js | Dead | date-fns / dayjs |
| Bootstrap (UI) | Dying | Tailwind / shadcn |
| Webpack | Legacy | Vite / Turbopack |
| AMP | Dead | Native Core Web Vitals |
| FID metric | Dead | INP (since 2024) |
| MongoDB as default | Declining | Postgres |
| Heroku | Expensive | Vercel / Render / Fly.io |
| CSS-in-JS runtime | Declining | Tailwind / vanilla-extract |

## Принципы 2026 (мнемоника)

1. **Mobile-first, ALWAYS.** 70-80% трафика consumer.
2. **Semantic HTML > ARIA.** Использовать ARIA только когда HTML недостаточен.
3. **Performance is feature, not afterthought.** Lighthouse audit при каждом релизе.
4. **Type safety** — TS, schema validators (Zod), database types (Prisma).
5. **Accessibility** — built-in, не «added later».
6. **Don't reinvent.** shadcn/ui, Tailwind, Radix Primitives — готовое.
7. **AI как «junior intern»** — генерит boilerplate, человек делает architecture & review.
8. **Self-host for control** — Beget / Selectel / Hetzner предсказуемее SaaS.
9. **Russia требует separate strategy** — Yandex SEO, ЮKassa, 152-ФЗ.
10. **Iterate fast** — MVP в Lovable / v0, потом улучшай в Cursor.

## Decision tree — какой framework

```
Хочу SSR?
├─ Нет, статический контент
│  ├─ Маркетинг / blog → Astro
│  └─ SPA dashboard → React + Vite
└─ Да, SSR нужен
   ├─ Маркетинг + minor app → Astro Server Islands
   ├─ Полноценное приложение → Next.js 15
   └─ Максимум perf → SvelteKit или Solid Start
```

## Decision tree — где разворачивать

```
Целевая аудитория?
├─ Глобальная → Vercel / Cloudflare / Fly.io
├─ Российская → Beget / Selectel / Yandex.Cloud
└─ Mix → Selectel + Cloudflare CDN front
```

## Decision tree — какой эквайринг

```
Где юр.лицо?
├─ РФ → ЮKassa (стандарт), Tinkoff (если ТКС client)
├─ KZ → TipTop Pay
├─ Globally (US/EU LLC) → Stripe / Paddle
└─ Multi → нужны отдельные интеграции по регионам
```

## Версия и обновления

**v1.0** — 2026-05-07, Paganel. Initial release. 9 файлов, ~3000 строк.

**Обновлять:**
- При появлении major framework release (Next 16, React 20)
- При новых Pantone цветов года
- При новых Core Web Vitals метриках
- При изменениях в RU compliance (новые версии 152-ФЗ, новые провайдеры эквайринга)

## Как использовать

1. Перед стартом нового проекта — пройди по index, открой нужные файлы.
2. При архитектурном решении — посмотри decision trees.
3. При выборе библиотеки — посмотри tools-and-services.md.
4. При вопросе «работает ли это» — посмотри browser support / status в соответствующем файле.
5. При планировании launch — пройди по «обязательно» чек-листу.

## Контакты обновления

Если приходит конкретная новость / тренд — обнови соответствующий файл, bump «updated:» в frontmatter, sync дату в этом index.
