---
id: src-web-dev-kb-performance
type: source
title: "Web KB: Performance & Core Web Vitals 2024-2026"
author: paganel
status: done
created: 2026-05-07T19:40:00Z
updated: 2026-05-07T19:40:00Z
tags: [web-dev-kb, performance, core-web-vitals, optimization, seo]
relates_to: [src-web-dev-kb-index, src-web-dev-kb-accessibility-seo]
source_for: []
---

# Performance & Core Web Vitals 2024-2026

## TL;DR

Google Core Web Vitals = ранжирующий фактор SEO. Если CWV красные — Google понижает позицию. Если зелёные — ranking boost.

**Текущие три метрики (стабильные на 2026):**

| Метрика | Что измеряет | Target | Когда срабатывает |
|---|---|---|---|
| **LCP** (Largest Contentful Paint) | Скорость загрузки главного контента | **≤ 2.5 секунды** | при первом отображении hero-image / heading |
| **INP** (Interaction to Next Paint) | Отклик на пользовательский input | **≤ 200 мс** | в течение всей сессии (худший случай) |
| **CLS** (Cumulative Layout Shift) | Сдвиг layout'а во время загрузки | **≤ 0.1** | от начала до интерактивности |

**Important:** в 2024 **INP заменил FID** (First Input Delay). FID measured только первое взаимодействие; INP — все, и берёт worst-case. Реальная UX-метрика.

## Измерение (field vs lab)

**Field data (RUM — Real User Monitoring):**
- **Chrome User Experience Report (CrUX)** — публичный dataset, реальные пользователи
- **PageSpeed Insights** — дашборд для одного URL с CrUX-данными
- **Search Console → Core Web Vitals** — твой сайт на Google
- **web-vitals JS library** — собираешь сам и шлёшь в свою аналитику

**Lab data (синтетические, контролируемые):**
- **Lighthouse** (в Chrome DevTools или CLI)
- **WebPageTest** (https://www.webpagetest.org/) — детальный анализ
- **Calibre** (https://calibreapp.com/) — paid CI integration

**Best practice:** комбинируй. Lab для CI/early detection, field для truth.

## Optimization по метрикам

### LCP (Largest Contentful Paint) — оптимизация

LCP измеряет когда главный элемент (image/heading/text-block) появляется на экране.

**1. Server response time (TTFB)**
- CDN — обязательно (CloudFlare / Beget CDN / Selectel CDN)
- Edge functions / SSR на edge
- Кэширование на сервере (HTTP Cache-Control headers)
- HTTP/2 или HTTP/3 (HTTP/3 = QUIC) — обязательно

**2. Resource load time**
- **Preload главного изображения:** `<link rel="preload" as="image" href="hero.webp" />`
- **`fetchpriority="high"`** на hero-image
- **Lazy-load всё остальное** (`loading="lazy"` на images below-fold)
- **`<img>` с `width` + `height`** — preserves aspect ratio, prevents CLS
- **Modern image formats:** AVIF (best compression), WebP (универсал), JPEG (fallback)
- **Responsive images:** `srcset` + `sizes`

**3. Render-blocking resources**
- **Critical CSS inline** в `<head>` (можно автоматизировать через `critical` npm package)
- **Defer non-critical CSS:** `<link rel="preload" ... onload="this.rel='stylesheet'">`
- **Async/defer for scripts** — `<script src="..." defer></script>` для не-критичных
- **Prerender pages, where possible** (Astro / Next.js SSG)

**4. Self-host fonts**
- Не загружай Google Fonts напрямую (медленно из РФ)
- `<link rel="preload" as="font" type="font/woff2">` для main fonts
- `font-display: swap` — показывает fallback пока шрифт грузится
- Subset fonts (только нужные глифы) — `glyphhanger` tool

### INP (Interaction to Next Paint) — оптимизация

INP — сколько мс между кликом и визуальным response. Меряется по всей сессии.

**1. Reduce JS execution time**
- **Code splitting** — Next.js / Vite делают по умолчанию
- **Tree-shaking** — utility-функции вместо целых библиотек
- **Lazy-load components** (React.lazy / dynamic imports)
- **Web Workers для тяжёлых задач** — sorting/parsing/computing вне main thread

**2. Long tasks → break apart**
- Long task = JS блокирует main thread > 50ms
- Используй `scheduler.yield()` (Chrome 129+) или `setTimeout(fn, 0)` для разбиения
- Async-batched updates вместо synchronous

**3. Avoid layout thrashing**
- Не читай и не пиши DOM поочерёдно (`offsetWidth` then style change)
- Используй `requestAnimationFrame`
- CSS transforms/opacity для анимаций (composited layer, no layout)

**4. Debounce / throttle**
- Input events → debounce 300ms
- Scroll/resize → throttle / `requestAnimationFrame`
- Use `Intersection Observer` instead of scroll-listeners

**5. React-specific**
- React 19 + Compiler — автомемоизация (без `useMemo`/`useCallback`)
- `useDeferredValue` для медленных списков
- `useTransition` для non-urgent updates
- Server Components — JS bundle меньше

### CLS (Cumulative Layout Shift) — оптимизация

CLS = сдвиг layout'а во время загрузки. Происходит когда content "прыгает".

**1. Always specify dimensions**
- Images: `width` + `height` или `aspect-ratio` через CSS
- Videos: `width="..." height="..."`
- iframes: same
- Webfonts: `font-display: optional` или `swap` (минимизирует FOUT)

**2. Reserve space for ads / embeds**
- Banner-блоки имеют `min-height` независимо от загрузки
- Lazy iframes — `<iframe loading="lazy" sizes="..." />`

**3. Animations carefully**
- Transform/opacity не вызывают layout shift
- Animate position absolute / fixed — safe
- Animate width/height/margin — может вызвать CLS

**4. Skeleton states**
- Показывать skeleton с правильными dimensions до загрузки данных
- React Suspense + skeleton

## Image optimization — must-have в 2026

### Format priority
1. **AVIF** (Chrome 85+, Firefox 93+, Safari 16.4+) — лучший compression, ~50% smaller than JPEG
2. **WebP** (universal modern) — fallback для AVIF
3. **JPEG** (legacy) — fallback для старых браузеров

### Responsive images
```html
<picture>
  <source srcset="hero.avif" type="image/avif">
  <source srcset="hero.webp" type="image/webp">
  <img src="hero.jpg" 
       alt="..."
       width="1920" height="1080"
       loading="eager"
       fetchpriority="high">
</picture>
```

### Tools
- **Squoosh** (https://squoosh.app/) — manual optimization
- **Sharp** (Node.js) — server-side, де-факто стандарт
- **next/image** — Next.js auto-optimization
- **Astro Image** — Astro native
- **Cloudinary / Imgix / Cloudflare Images** — managed services

### Lazy loading
- `loading="lazy"` для below-fold images
- НЕ ставь lazy на hero-image (LCP пострадает)
- `loading="eager"` для hero (или вообще не указывай — eager default)

## Bundle optimization

### Размеры — what's normal?

| Тип сайта | Acceptable JS bundle (gzipped) | Excellent |
|---|---|---|
| Маркетинг лендинг | < 80 KB | < 30 KB |
| SaaS dashboard | < 250 KB | < 100 KB |
| E-commerce | < 200 KB | < 80 KB |
| Документация | < 50 KB | < 10 KB |

### Tools для analysis
- **Bundle Analyzer** (Next.js / Vite plugins) — что именно в bundle
- **source-map-explorer** — то же для любого webpack/vite output
- **bundlephobia.com** — проверка package size
- **import-cost** (VSCode extension) — реалтайм

### Что обычно можно срезать

- **Lodash → native methods** (Object.entries, Array.flatMap, etc.) — экономит 50+ KB
- **Moment.js → date-fns / dayjs** — moment 67 KB, dayjs 7 KB
- **Axios → native fetch** — fetch есть везде
- **Bootstrap → Tailwind / CSS Modules** — bootstrap CSS большой
- **jQuery → native DOM** — jQuery 30+ KB
- **react-icons → отдельные иконки или own SVG** — react-icons очень тяжёлый
- **Multiple state management libs** — выбери одну (TanStack Query + Zustand)

## CDN strategy

### Зачем
- Latency reduction — ближе к user
- Bandwidth offload
- DDoS protection (через Cloudflare/Beget DDoS)
- Image transformation на edge

### Major players (2026)

| CDN | Сильные стороны | Уход в РФ |
|---|---|---|
| **Cloudflare** | Free tier, speed, DDoS, Workers | Работает, но платежи проблемные |
| **AWS CloudFront** | Интегрирован с AWS | Сложно платить из РФ |
| **Vercel Edge** | Tightly integrated с Next.js | Аналогично |
| **Selectel CDN** | RU-friendly | RU-only |
| **Beget CDN** | Включён в Beget VPS | RU-only |
| **NGENIX** | RU-friendly, для медиа | RU-focused |
| **CloudMTS** | RU MTS-owned | RU-only |
| **Stormwall** | DDoS protection из РФ | RU-friendly |

**Для проектов с RU-аудиторией:** Selectel CDN или Cloudflare через Free Tier (если оплата возможна).

## Web Vitals — debugging tools

```js
import { onLCP, onINP, onCLS } from 'web-vitals';

onLCP(metric => console.log('LCP', metric));
onINP(metric => console.log('INP', metric));
onCLS(metric => console.log('CLS', metric));
```

В production отправляй в Google Analytics 4, Plausible, Vercel Analytics, или свой бэкенд.

**Chrome DevTools Performance Insights** — новый tab «Performance Insights» (отдельно от Performance) — простой view с recommendations.

## Что устарело

- **First Input Delay (FID)** — заменено INP в 2024
- **TTI (Time to Interactive)** — больше не tracking metric
- **Speed Index** — в lab-tests остаётся, для CWV не считается
- **Manual `requestIdleCallback`-стратегии** — JS-фреймворки делают сами

## Чек-лист "сайт в production"

- [ ] LCP ≤ 2.5s в field data
- [ ] INP ≤ 200ms
- [ ] CLS ≤ 0.1
- [ ] Hero image: AVIF или WebP, preload, fetchpriority="high"
- [ ] Below-fold images: `loading="lazy"`
- [ ] Все images имеют `width` + `height`
- [ ] HTTP/2 или HTTP/3 (HTTPS обязательно)
- [ ] CDN перед origin
- [ ] Compression: Brotli > gzip
- [ ] Critical CSS inline
- [ ] Non-critical JS — defer/async
- [ ] Self-hosted fonts с font-display: swap
- [ ] No render-blocking 3rd-party scripts (move to async)
- [ ] Service worker (для repeat visits)
- [ ] Tree-shaken bundle, no Lodash/Moment

## Resources

- **web.dev / Learn Performance** (https://web.dev/learn/performance) — Google official
- **Web Vitals Library** (https://github.com/GoogleChrome/web-vitals) — JS lib
- **PageSpeed Insights** (https://pagespeed.web.dev/) — quick check для URL
- **WebPageTest** (https://www.webpagetest.org/) — глубокий анализ
- **Google Search Console** → Core Web Vitals report
- **CrUX Dashboard** (https://developers.google.com/web/tools/chrome-user-experience-report)
- **Smashing Magazine** — много performance-статей
- **Calibre** (paid) — CI/CD integration

## Decision matrix

| Симптом | Most likely cause | Fix |
|---|---|---|
| LCP > 2.5s | Slow hero image / TTFB | Preload + AVIF + CDN |
| LCP > 4s | Render-blocking JS | Critical CSS inline + defer scripts |
| INP > 200ms | JS-heavy interactions | React Compiler / break long tasks / Web Workers |
| CLS > 0.25 | No image dimensions / late-loading fonts | width/height + font-display |
| Bundle > 500 KB JS | Unused dependencies | Bundle Analyzer + tree-shake |
| Slow on slow networks | No compression / no CDN | Brotli + CDN |
| Lighthouse score 60-80 | Multiple small issues | Run audit, fix top 5 recommendations |
