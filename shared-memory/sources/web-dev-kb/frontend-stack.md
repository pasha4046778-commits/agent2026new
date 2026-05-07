---
id: src-web-dev-kb-frontend-stack
type: source
title: "Web KB: Frontend Stack 2024-2026"
author: paganel
status: done
created: 2026-05-07T19:30:00Z
updated: 2026-05-07T19:30:00Z
tags: [web-dev-kb, frontend, javascript, react, vue, svelte, astro]
relates_to: [src-web-dev-kb-index]
source_for: []
---

# Frontend Stack 2024-2026

## TL;DR — что выбирать в 2026

| Цель | Стек |
|---|---|
| Маркетинговый лендинг (статика) | **Astro** + Tailwind + shadcn/ui |
| SaaS / web-приложение | **Next.js 15 (App Router)** + React 19 + Tailwind |
| Document/blog-сайт | **Astro** или **Hugo** (если SSG) |
| Сложное SPA / dashboard | **React 19** + Vite + TanStack Query/Router |
| Мобильно-первоначальный сайт | **Svelte 5** + SvelteKit OR **Solid Start** |
| Tiny enhancement to existing site | **HTMX** или vanilla JS |
| Mobile app cross-platform | **React Native** (Expo) или **Flutter** |
| Embeddable widget | Web Components + Lit |

## State of JS 2024 — главное

- **«Top 3 фронтенд-фреймворка все стартанули 10+ лет назад»** — индустрия стабилизировалась. React (2013), Vue (2014), Angular (2016 в нынешнем виде).
- **Vite + Vitest** — стали де-факто стандартом для нового проекта. Webpack-based стэки переходят.
- **TypeScript** — почти 100% adoption в новых проектах. Pure-JS — legacy сегмент.
- **Astro** — самый растущий мета-фреймворк, особенно для маркетинговых сайтов.

## Frameworks по уровням

### TIER 1 — production-ready, крупные команды

#### React 19 + Next.js 15
- **Plus:** огромная экосистема, любая библиотека работает, найм разработчиков лёгкий
- **Plus:** Server Components (RSC) реально снижают JS bundle на client
- **Plus:** App Router зрелый, Server Actions упрощают forms
- **Minus:** mental model сложна (Server vs Client components, async APIs)
- **Minus:** Vercel-lock-in без усилий — для self-host надо знать как делать
- **Minus:** Hydration-ошибки могут быть mind-bending
- **Когда брать:** SaaS, dashboard, любое приложение с auth/data

**Что нового в Next.js 15 (2024):**
- React 19 RC support
- Async Request APIs (`headers`, `cookies`, `params` теперь awaitable — breaking change!)
- Caching defaults упростились — `fetch` и `GET` Route Handlers НЕ кэшируются по умолчанию
- Turbopack Dev стабилен (до 76% faster startup)
- `<Form>` компонент с prefetch + progressive enhancement
- Server Actions Security: unguessable IDs, dead-code elimination
- React Compiler experimental — авто-мемоизация без `useMemo`/`useCallback`
- `next.config.ts` (TypeScript) поддерживается
- `instrumentation.js` стабилен (lifecycle hooks)
- Min Node 18.18+

#### Vue 3 + Nuxt 3
- **Plus:** мягче кривая обучения, шаблоны читабельнее JSX
- **Plus:** Vue.js Composition API похож на React Hooks но без тонкостей
- **Plus:** Pinia для state — легче чем Redux/Zustand
- **Minus:** меньше высококачественных библиотек чем у React
- **Минус:** найм Vue-разработчиков сложнее в РФ/СНГ
- **Когда брать:** маленькие команды, проекты где приоритет скорость dev

#### Angular 18+
- **Plus:** энтерпрайз-стандарт, всё в коробке (router, forms, http, di)
- **Plus:** Signals (новая реактивность) — модернизация
- **Plus:** zoneless mode (без Zone.js) — лучше performance
- **Minus:** verbose, много boilerplate
- **Minus:** в стартапах уже редко выбирают
- **Когда брать:** крупные проекты с TypeScript-командой; не для лендингов

### TIER 2 — растущие, perf-first

#### Astro 5 (2024-2025)
- **Концепция:** «Islands architecture» — статика по умолчанию, JS только где надо.
- **Plus:** zero-JS для контентных сайтов; результат — сайт в 5-10 раз легче чем Next.
- **Plus:** Можешь вкрутить React/Vue/Svelte/Solid компонент в .astro файл
- **Plus:** Content Collections (TypeSafe MD/MDX контент)
- **Plus:** Server Islands (новое в 5) — стрим серверных частей в статический HTML
- **Minus:** Не для интерактивных приложений (где state управляет всем UI)
- **Когда брать:** маркетинговые сайты, blogs, документация, портфолио

#### SvelteKit + Svelte 5
- **Plus:** компилятор → меньше JS bundle чем React
- **Plus:** Svelte 5 ввёл runes (`$state`, `$derived`, `$effect`) — более явная реактивность
- **Plus:** less code для тех же задач
- **Minus:** меньшее community, меньше библиотек
- **Когда брать:** performance-critical, личные проекты, mobile-first

#### Solid + SolidStart
- **Plus:** API похож на React, но без Virtual DOM — все примитивы реактивные
- **Plus:** один из самых быстрых фреймворков по benchmarks
- **Minus:** редкая в production, нанять сложно
- **Когда брать:** перформанс-критичные SPA, эксперименты

#### Qwik + Qwik City
- **Plus:** Resumability — серверный рендер не нуждается в hydration на клиенте
- **Plus:** теоретически лучшее TTI (Time-to-Interactive)
- **Minus:** очень нишевая, mental model нестандартная
- **Когда брать:** только если знаешь, что делаешь, для очень специфичных кейсов

### TIER 3 — специальные случаи

#### HTMX + Server-rendered HTML
- **Концепция:** интерактивность через HTML-атрибуты + AJAX, без JS-фреймворка.
- **Plus:** zero JS-bundle, серверная логика на любом языке (PHP/Python/Go)
- **Plus:** Backwards compat невероятный
- **Minus:** не для сложных SPA-стейтов
- **Когда брать:** добавляешь интерактивности в сайт (типа FrutPed), не делаешь дашборд

#### Web Components + Lit
- **Plus:** работает в любом фреймворке (или без него)
- **Plus:** идеально для embeddable widgets
- **Minus:** SSR сложен, hydration проблемы
- **Когда брать:** виджет для встраивания в чужие сайты

#### Vanilla JS / Alpine.js
- **Когда:** простая интерактивность, не хочется зависимости от фреймворка
- **Plus:** Alpine — `x-data`, `x-on:click` — Vue-like синтаксис без билда
- **Когда брать:** маркетинговые сайты, простые формы, lightweight enhancement

## Build tools

| Tool | Use case | Notes |
|---|---|---|
| **Vite** | Stable default for new projects | RolldownBundler заменит esbuild к 2026 |
| **Turbopack** | Next.js dev (production beta) | 76% faster startup vs Webpack |
| **esbuild** | Library bundling | Уходит в legacy |
| **Webpack** | Legacy projects | Не для новых проектов |
| **Rollup** | Library distribution | Особенно для NPM packages |
| **Bun** | Fastest installs + runtime | 2-3x faster than npm; production-ready |
| **pnpm** | Workspace mono-repos | Дисковая экономия через hardlinks |

## State management

**Текущий ландшафт:**

| Tool | When |
|---|---|
| **TanStack Query** (React Query) | Server state, fetching — must-have |
| **Zustand** | Small global state, alternative to Redux |
| **Jotai** | Atomic state |
| **Redux Toolkit** | Legacy большой проектов |
| **Context API + useReducer** | Маленький проект, без библиотек |
| **Pinia** | Vue, замена Vuex |
| **Svelte 5 runes** | Built-in для Svelte |
| **Solid signals** | Built-in для Solid |

**Тренд:** разделение **server state** (TanStack Query) и **client state** (Zustand/Jotai). Redux одной кучей — деприкейтится.

## Routing

| Tool | When |
|---|---|
| **Next.js App Router** | If using Next |
| **TanStack Router** | Type-safe SPA routing for React |
| **React Router v7** (formerly Remix) | Унифицировано — Remix влился в RR7 |
| **SvelteKit Router** | Built-in для Svelte |
| **Vue Router** | Built-in для Vue |
| **wouter** | Lightweight для React |

**Big shift 2024-2025:** **Remix → React Router v7** — Remix был куплен Shopify, и они слили его обратно в React Router. Теперь у тебя один продукт, который умеет и SPA и SSR (через адаптер).

## Forms

| Tool | When |
|---|---|
| **react-hook-form** + **zod** | React, де-факто стандарт |
| **TanStack Form** | Новая, type-safe, headless |
| **VeeValidate** | Vue |
| **Felte** | Svelte |
| **Native HTML form + Server Actions** | Next.js простые формы |

## Стилизация

| Tool | When |
|---|---|
| **Tailwind CSS v4** | Universal default — utility-first |
| **shadcn/ui** | React component lib (copy-paste, не npm) |
| **CSS Modules** | Если хочешь scoped CSS без utility |
| **vanilla-extract** | Type-safe CSS-in-TS |
| **styled-components** | Legacy (отстаёт от time) |
| **Emotion** | Legacy |

**Тренд:** уход от runtime-CSS-in-JS (styled-components, emotion) в build-time alternatives (Tailwind, CSS Modules, vanilla-extract). Reasoning: bundle size + zero runtime cost.

**Tailwind v4** (2024-2025) — переписан на Rust, новый engine, упрощённая конфигурация (без `tailwind.config.js`, использует CSS variables).

## Component libraries

| Library | Best for |
|---|---|
| **shadcn/ui** | React + Tailwind, copy-paste components |
| **Radix UI Primitives** | Headless, accessibility-first base for shadcn |
| **Mantine** | All-in-one для React (форма + UI + hooks) |
| **Ant Design** | Энтерпрайз dashboards |
| **MUI (Material-UI)** | Когда жёстко нужен Google Material стиль |
| **Chakra UI** | Когда хочешь готовый design-system |
| **HeadlessUI** | Tailwind Labs — accessibility-first headless |
| **Park UI** | Headless + Panda CSS |

**Doseasonal mention:** **shadcn/ui** доминирует в React-ноосфере 2024-2025. Главная фишка: ты копируешь код компонентов в свой проект, дальше он твой. Никакой "версии" не существует — есть только "то, что у меня в проекте".

## Mobile / Cross-platform

| Tool | When |
|---|---|
| **React Native + Expo** | Hybrid mobile, JS team |
| **Flutter** | Когда нужен пиксель-перфект на iOS+Android |
| **Capacitor + Web** | Если у тебя уже web-app, просто обёртка |
| **PWA** | Самое дешёвое — современный браузер уже умеет |
| **Native (Swift/Kotlin)** | Только если perf-critical или vendor-specific |

## TypeScript

- **2025 status:** TS practically required for any non-trivial project. Pure JS только для скриптов или прототипов.
- **TS 5.5+ features:** improved type inference, regex string types, set methods.
- **`tsconfig.json` defaults для нового проекта:** `strict: true`, `target: ES2022`, `moduleResolution: bundler`.

## Что мёртвое или умирает

- **jQuery** — НЕ нужен в новых проектах. Если работает legacy — оставь.
- **Lodash** — большинство методов уже в native JS (Object.entries, Array.prototype.flatMap, etc.). Tree-shaking слабый.
- **Moment.js** — deprecated. Используй **date-fns**, **dayjs**, или native `Intl.DateTimeFormat`.
- **Webpack для нового проекта** — Vite/Turbopack лучше во всём.
- **Bootstrap (UI)** — устарело визуально. Только если нужно очень быстро.
- **Pug / Jade** — exotic templating, не нужен.
- **CoffeeScript** — мёртвая. Только legacy.
- **CommonJS modules** — переходим на ESM везде.

## Стандартный setup для нового проекта в 2026

```bash
# SaaS / web app
npx create-next-app@latest --ts --tailwind --app

# Static site / blog
npm create astro@latest

# SPA (sin SSR)
npm create vite@latest -- --template react-ts

# Mobile
npx create-expo-app

# CLI tool / library
npm create vite@latest -- --template lib
```

## Когда что применять (decision tree)

```
Нужен ли мне SSR?
├─ Нет, это статика
│  ├─ Контент-сайт → Astro
│  └─ SPA (dashboard, etc.) → React + Vite + TanStack Router
└─ Да, нужен SSR
   ├─ Это маркетинг + minor app → Astro Server Islands
   ├─ Полноценное приложение → Next.js 15
   └─ Нужен максимум perf → Solid Start или SvelteKit
```

## Resources

- **State of JS 2024:** https://2024.stateofjs.com/
- **State of CSS 2024:** https://2024.stateofcss.com/
- **State of HTML 2024:** https://2024.stateofhtml.com/
- **Bundlephobia** (https://bundlephobia.com/) — размер любой npm-package
- **Web.dev** (https://web.dev/) — Google performance/PWA/best-practices
- **Smashing Magazine** — общие тренды
