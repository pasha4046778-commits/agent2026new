---
id: src-web-dev-kb-css-modern
type: source
title: "Web KB: Modern CSS 2024-2026"
author: paganel
status: done
created: 2026-05-07T19:35:00Z
updated: 2026-05-07T19:35:00Z
tags: [web-dev-kb, css, frontend, styling]
relates_to: [src-web-dev-kb-index]
source_for: []
---

# Modern CSS 2024-2026

## TL;DR

CSS прошёл turning point в 2024. Цитата State of CSS: «мы оглянемся на 2024 как на момент перехода от CSS Classic к New CSS». Многое из того, что раньше требовало JS-обходов или препроцессоров (Sass), теперь нативно в браузере.

**Что СЕЙЧАС можно использовать без полифиллов** (Chrome 109+, Firefox 121+, Safari 16.4+):

- Container queries (`@container`)
- `:has()` selector
- Cascade layers (`@layer`)
- Custom properties / CSS variables
- Subgrid
- Logical properties (`margin-block`, `inline-size`)
- `:is()` and `:where()`
- `aspect-ratio`
- `clamp()`, `min()`, `max()`
- Modern color (`oklch()`, `color-mix()`)

**Что почти готово (95%+ browser support, можно без полифиллов в новых проектах):**

- View Transitions API
- `@scope`
- `text-wrap: balance/pretty`
- Anchor positioning
- Scroll-driven animations

## Container Queries — заменяют media queries для компонентов

```css
.card {
  container-type: inline-size;
}

@container (min-width: 400px) {
  .card-content {
    grid-template-columns: 1fr 1fr;
  }
}
```

**Зачем:** компонент адаптируется к контексту, не вьюпорту. Правильный mental model для component-based design.

**Когда использовать:** каждый раз когда у вас reusable component.

## `:has()` — родительский селектор

```css
/* Article с image больше тоньше */
article:has(img) {
  padding: 2rem;
}

/* Form с invalid input — красный border */
form:has(input:invalid) {
  border-color: red;
}

/* Card с favorite-icon — выделить */
.card:has(.favorite-icon) {
  background: gold;
}
```

**Game-changer:** убирает necessity of JS для огромного класса задач. Раньше: `if (article.querySelector('img')) article.classList.add('with-img')`. Теперь: чистый CSS.

## Cascade Layers — структурированная специфичность

```css
@layer reset, components, utilities;

@layer reset {
  * { margin: 0; padding: 0; }
}

@layer components {
  .button { background: blue; }
}

@layer utilities {
  .mt-4 { margin-top: 1rem; }
}
```

**Почему важно:** позволяет управлять каскадом ЯВНО. Tailwind использует layers внутри. Уменьшает «specificity wars» в больших codebase'ах.

**Tailwind v4** активно использует layers — `@layer base`, `@layer components`, `@layer utilities`.

## CSS Variables (Custom Properties) — must-have

```css
:root {
  --primary: #ff6b00;
  --primary-dark: oklch(from var(--primary) 0.4 c h);
  --bg: #fff;
  --text: #000;
}

[data-theme="dark"] {
  --bg: #000;
  --text: #fff;
}

button {
  background: var(--primary);
  color: var(--bg);
}
```

**Best practice 2026:**
- Все цвета — через CSS variables
- Все spacing/sizing — через variables (`--space-1: 0.25rem`)
- Theming: `[data-theme="..."]` атрибут на `<html>` или `<body>`
- При необходимости — type-safe variables (`@property --primary { syntax: '<color>'; ... }`)

## Subgrid — наконец работает везде

```css
.parent {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
}

.child {
  display: grid;
  grid-column: span 3;
  grid-template-columns: subgrid; /* наследует от parent */
}
```

**Когда:** вложенные grids (карточки внутри секции выравниваются по общим колонкам).

## Logical Properties — RTL/LTR-aware

```css
/* Раньше */
.box { margin-left: 1rem; }

/* Теперь */
.box { margin-inline-start: 1rem; }
```

`block` (вертикаль) / `inline` (горизонталь), `start` / `end` вместо `top/right/bottom/left`. Автоматически работает в RTL-языках.

**Полный список:** `margin-block-start`, `padding-inline`, `inset-block-end`, `border-inline-color`, `min-block-size`, etc.

## Modern Color — `oklch`, `color-mix`

```css
:root {
  --primary: oklch(70% 0.2 30);  /* lightness, chroma, hue */
}

.button:hover {
  background: oklch(from var(--primary) calc(l - 10%) c h);
  /* или */
  background: color-mix(in oklch, var(--primary), black 10%);
}
```

**Почему OKLCH > HSL:**
- Perceptually uniform — увеличиваешь lightness и видишь равномерное изменение
- Wider gamut — Display P3 поддержка
- `color-mix` позволяет программно строить палитры

**Поддержка:** Chrome 111+, Safari 15.4+, Firefox 113+. Безопасно использовать.

## Aspect Ratio — без хаков

```css
.video {
  aspect-ratio: 16/9;
  width: 100%;
}
```

Раньше требовался `padding-top: 56.25%` хак. Теперь нативно.

## clamp() для fluid typography

```css
h1 {
  font-size: clamp(2rem, 5vw, 4rem);
  /* min 32px, scale with vw, max 64px */
}

.container {
  width: clamp(20rem, 100%, 80rem);
}
```

**Кросс-устройство без media queries.**

## View Transitions API — page transitions без JS-роутеров

```css
::view-transition-old(root) {
  animation: 0.5s fade-out;
}

::view-transition-new(root) {
  animation: 0.5s fade-in;
}

@keyframes fade-out { to { opacity: 0; } }
@keyframes fade-in { from { opacity: 0; } }
```

```js
// Trigger transition
document.startViewTransition(() => {
  // обновить DOM
  document.querySelector('h1').textContent = 'New page';
});
```

**Когда:** SPA navigation, theme switching, accordion expand. **Browser support:** Chrome 111+, Safari 18+. Firefox — за чертой.

## Scroll-Driven Animations — без библиотек

```css
@keyframes slide-in {
  from { transform: translateX(-100%); }
  to { transform: translateX(0); }
}

.element {
  animation: slide-in linear;
  animation-timeline: scroll(); /* привязка к scroll */
  animation-range: cover 0% cover 50%;
}
```

**Когда:** scroll-triggered animations без GSAP / Intersection Observer. Chrome 115+. Firefox/Safari подтягиваются.

## `text-wrap: balance/pretty`

```css
h1, h2 { text-wrap: balance; }   /* выравнивает строки заголовка */
p { text-wrap: pretty; }         /* нет orphans */
```

Game changer для типографики. Browser support: Chrome 114+, Firefox 121+, Safari 17.5+.

## Anchor Positioning — tooltips/popovers без JS

```css
.target {
  anchor-name: --my-target;
}

.tooltip {
  position: absolute;
  position-anchor: --my-target;
  bottom: anchor(top);
  left: anchor(center);
}
```

Native CSS-tooltips, popovers, dropdowns. Chrome 125+. Другие браузеры в работе.

## Frameworks-уровень

### Tailwind CSS v4
- **Релиз:** end of 2024.
- **Что нового:**
  - Engine переписан в Rust — в 5-10 раз быстрее
  - Конфиг через CSS-переменные, без `tailwind.config.js` (опционально)
  - First-class CSS variables support
  - Container query utilities (`@container`)
  - Native cascade layers
  - Smaller bundle (через PostCSS оптимизацию)
- **Когда брать:** новый проект — однозначно.

### shadcn/ui (de-facto pair to Tailwind)
- Radix Primitives + Tailwind, скопированные в твой проект
- Не библиотека, а методология
- Поддержка React, Vue, Svelte (через port'ы)

### Open Props
- Бесплатные CSS variables (цвета, spacing, типографика, анимации)
- Альтернатива Tailwind для тех, кто хочет vanilla CSS
- https://open-props.style/

### CSS-in-JS — куда движется
- **styled-components** теряет позиции (runtime cost)
- **emotion** — тоже legacy
- **vanilla-extract** — type-safe build-time (хороший выбор для TS-команд)
- **Panda CSS** — новая generation, build-time, conf-driven
- **Linaria** — zero-runtime CSS-in-JS

**Тренд:** уходить от runtime CSS в utility-классы (Tailwind) или build-time (vanilla-extract, Panda).

## Что устарело

- **CSS preprocessors как обязательный шаг** — Sass, Less, Stylus. Многие фичи теперь нативно (variables, nesting, modules через layers). Однако для legacy projects они остаются.
- **`@import` для CSS bundling** — медленный, заменяется bundler'ом.
- **BEM как единственный naming standard** — устарело при наличии CSS Modules / Tailwind / scoped styles.
- **CSS reset как обязательный** — modern CSS-reset libraries (`@modern-normalize`, `Andy Bell's CSS Reset`) минимальные.

## Practical reset для 2026

```css
/* Modern CSS Reset — Andy Bell + Кагра-инструменты */

*, *::before, *::after {
  box-sizing: border-box;
}

* {
  margin: 0;
}

body {
  line-height: 1.5;
  -webkit-font-smoothing: antialiased;
  font-family: system-ui, sans-serif;
}

img, picture, video, canvas, svg {
  display: block;
  max-width: 100%;
}

input, button, textarea, select {
  font: inherit;
}

p, h1, h2, h3, h4, h5, h6 {
  overflow-wrap: break-word;
  text-wrap: pretty;
}

h1, h2, h3 {
  text-wrap: balance;
}
```

## Resources

- **State of CSS 2024:** https://2024.stateofcss.com/
- **Modern CSS Solutions** (https://moderncss.dev/) — gradient hover effects, scroll animations
- **Josh Comeau's blog** (https://www.joshwcomeau.com/) — отличные deep-dives
- **Web.dev / Learn CSS** (https://web.dev/learn/css) — official Google course
- **Can I Use** (https://caniuse.com/) — browser support matrix
- **CSS Tricks Almanac** (https://css-tricks.com/almanac/) — справочник свойств
- **The Modern CSS Reset** (https://andy-bell.co.uk/a-more-modern-css-reset/) — Andy Bell

## Quick reference — when to use what

| Задача | Решение |
|---|---|
| Дизайн-токены | CSS Variables (`:root`) |
| Темная тема | `[data-theme="dark"]` + variables |
| Адаптивная типографика | `clamp()` |
| Component responsive | Container Queries |
| Layout grids | CSS Grid (с subgrid если нужно) |
| Page transitions | View Transitions API |
| Scroll animations | `animation-timeline: scroll()` |
| Цветовые переходы | `oklch()` + `color-mix()` |
| Tooltips | Anchor Positioning (если поддержка ок) |
| Reset | Andy Bell modern reset |
| Utility CSS | Tailwind v4 |
| Component library | shadcn/ui (для React) |
