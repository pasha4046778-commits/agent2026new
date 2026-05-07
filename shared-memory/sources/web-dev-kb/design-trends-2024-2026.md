---
id: src-web-dev-kb-design-trends
type: source
title: "Web KB: Design Trends 2024-2026"
author: paganel
status: done
created: 2026-05-07T19:30:00Z
updated: 2026-05-07T19:30:00Z
tags: [web-dev-kb, design, trends, ux, ui]
relates_to: [src-web-dev-kb-index]
source_for: []
---

# Дизайн-тренды 2024-2026

## TL;DR — что в моде сейчас

1. **AI-aesthetic** — генеративные иллюстрации, текстуры, морфирующие формы; «всё может быть сгенерировано».
2. **Brutalism + Editorial** — крупная типографика, асимметричные сетки, контрастные цвета, «как журнал».
3. **Bento-layouts** — заимствовано у Apple iOS 17/iPadOS — карточки разных размеров в сетке вместо традиционного hero+grid.
4. **Кастомные corner-shapes** — beveled/scooped/squircle вместо обычного `border-radius` (CSS-свойство `corner-shape` в work-in-progress).
5. **Глобальные тёмные темы по умолчанию** — много продуктов по умолчанию запускаются в dark, light как опция.
6. **Микро-анимации > большие parallax** — мелкие feedback-анимации (hover, scroll-triggered) важнее впечатляющих stories.
7. **3D и WebGL — точечно, не везде** — 3D-сцены отвалились от центра моды; используются только для конкретных целей (продуктовые превью, геймификация).
8. **«Дисперсия» и «глитч»** — chromatic-aberration текстовая, RGB-split, шрифты с fallback'ом на serif в брутальном стиле.

## Цвет

**Pantone Color of the Year 2026: Cloud Dancer** (мягкий тёплый off-white, нейтральная база). Сменил Mocha Mousse 2025 (тёплый коричневый).

**Палитры в моде:**
- **«Powdered Pastels»** — мягкие тёплые пастели (Cloud White #F5F5F0, Powdered Pink #F8E8E8, Mint Soft #E8F4F0). Это тренд года.
- **Тёплые нейтрали** — кремовые, бежевые, серо-розовые. Уход от чисто белых задников.
- **Earth tones** — терракотовый (#9E5C3F), глиняный, шалфейный — продолжают доминировать.
- **Локальные акценты яркого** — апельсин (#FF6B00), электрик-blue, лайм-green как одна-две ключевые точки на странице.
- **Высокий контраст для accessibility** — ratios >7:1 становятся нормой для основного текста.

**Ушло из моды:**
- Чистый Material Design 2017-стиля с яркими flat-коробками
- Glassmorphism (был хит 2020-2022, теперь воспринимается как dated)
- Neon gradients (если только не для AI/tech-тематики)

## Типографика

**Что в тренде:**
- **Variable fonts** — массово заходят. Один шрифт-файл закрывает все варианты толщины/стиля. Уменьшает payload.
- **Serif возвращается** — для headlines (Editorial Old, Recoleta, Fraunces). Sans-serif для body. Гибрид.
- **Очень крупные заголовки (90-200px)** — на лендингах. Идёт от Awwwards-эстетики 2023-2025.
- **Italic в headlines** — продолжение Editorial-тренда.
- **Display-fonts с уникальным характером** — geometric sans (Geist Sans от Vercel), monospace в headlines (Inter Tight, JetBrains Mono для tech-вайба).
- **Customer-loved sans-serif стандарты:** Inter (универсал), Geist (modern tech), Plus Jakarta Sans, Manrope.

**Что ушло:**
- Single Roboto / Open Sans для всего сайта
- Excessive font-weight variations (300/400/500/600/700) — сейчас чаще 400+700 без полутонов
- All-caps для всего меню (использовать точечно)

## Layout

**Тренды:**
- **Container queries вместо media queries** — компонент адаптируется к своему контейнеру, а не вьюпорту. Это меняет mental model.
- **Bento grids** — асимметричные карточки, drag-attention.
- **Responsive beyond breakpoints** — fluid scaling через CSS-функции (`clamp`, `min`, `max`). «Pixel perfect» уходит.
- **Sticky-но-умные элементы** — заголовки, навигация, CTA, которые меняют поведение при scroll'е.
- **Whitespace как design element** — больше пространства, меньше «забитой» страницы.
- **Asymmetric layouts** — намеренно не центрированные блоки, наклонённые grids.

**Что ушло:**
- Hero + 3 columns + footer как универсальный шаблон
- Карусели на главной (низкий conversion, плохая accessibility)
- Sidebar nav на маркетинговых страницах

## Анимация и микро-интеракции

**Тренды:**
- **View Transitions API** — теперь стабильно в браузерах. Плавные переходы между страницами без JS-роутеров.
- **Scroll-driven animations** через CSS (`animation-timeline: scroll()`) — без JS-библиотек.
- **Lottie и After Effects-экспорты** для иллюстраций.
- **GSAP + ScrollTrigger** остаётся стандартом для сложного.
- **Hover-эффекты с физическим feel** — подёргивание, упругость, magnetic-cursor.

**Что ушло / редкое:**
- Heavy parallax на каждом блоке
- Loading-screens с длинными анимациями (instead — skeleton states)
- Auto-playing video-backgrounds (плохо для performance + accessibility)

## Компонентный язык

- **shadcn/ui** — стал де-факто стандартом для React. Компоненты копируешь в свой проект, а не импортируешь как библиотеку. Полный контроль, минимум зависимостей.
- **Radix UI primitives** — основа shadcn и многих других. Headless, accessibility-first.
- **Vaul** — drawer-компонент для mobile, очень популярен.
- **Sonner** — toast/notification де-факто стандарт.
- **react-hot-toast, react-toastify** — старые звёзды, начинают терять долю.

## Декорации

- **Noise textures** — шумовая текстура поверх grafiень. Делает «органично», не digitally-clean.
- **Hand-drawn arrows / annotations** — для marketing-сайтов в стартапной нише.
- **Sticker-style elements** — наклейки, badges, stamps.
- **Glassmorphism — в редких местах** (например только в floating bars).
- **Gradient backgrounds — медленные, многоцветные** — Vercel-style, не aggressive.

## Тренды по типам сайтов

### Лендинги SaaS
- Bento-grid features
- Live-preview демо в hero
- AI-generated illustrations
- Social proof (logos, testimonials) выше fold
- Sticky CTA на scroll

### E-commerce
- Карточки товаров с hover-видео-превью
- Quick-add в корзину без перехода на страницу
- AI-driven «похожие товары» / personalization
- Свободный checkout без обязательной регистрации
- Visual search (загрузил фото → нашёл похожее)

### Образовательные / курсы
- Video-first структура (как у тебя FrutPed, кстати — это тренд)
- Прогресс-бары / гамификация
- Мобильное-first потребление контента
- Темы для разных контекстов (light/dark/sepia)

### Портфолио / личные сайты
- Editorial-typography
- Минимальные сетки
- 3D или WebGL точечно
- Awwwards-эстетика (asymmetric, expressive)

### Корпоративные
- Сдержанность, но не sterile
- Кастомные иллюстрации vs стоковые
- Strong typography, simple palette

## Anti-trends — чего избегать

- **Излишний AI-look** — всё уже подустало от midjourney-сгенерированных hero-иллюстраций. Уникальность важнее.
- **Перегруженные landing-pages** — 10 секций + 5 CTA = низкая конверсия.
- **Cookie-banners как преграда** — третьесторонние cookies уходят, banners становятся менее обязательными.
- **Carousel-героев** — A/B тесты показывают, что только первый слайд видят.
- **Auto-playing video с звуком** — почти везде запрещено браузерами.
- **Skeumorphism из 2010-х** — кнопки с тенями+gradients, выглядят dated.

## Источники / куда смотреть для inspirations

- **Awwwards** (https://www.awwwards.com/) — premium design showcase
- **SiteInspire** (https://www.siteinspire.com/) — куратории
- **Land-book** (https://land-book.com/) — лендинги
- **Mobbin** (https://mobbin.com/) — mobile UI patterns
- **Refero.design** — UI patterns library
- **Smashing Magazine** — статьи о трендах
- **CSS-Tricks Snippets** — actionable code
- **Vercel Geist Design** — современный стандарт от vercel.com
- **Linear** (https://linear.app/) — референс для product UX
- **Stripe Dashboard** — референс для финансовых интерфейсов

## Когда что применять

| Если делаем | Тренды-фавориты |
|---|---|
| SaaS landing | Bento + AI-illustrations + sticky CTA |
| Курсы / education | Video-first + clear progress + warm palette |
| E-commerce | Card-grids + quick-add + product preview hover |
| Портфолио / personal | Editorial typography + minimal palette + asymmetric |
| Корпоративное | Strong typography + restraint + custom illustrations |
| Tech / dev tool | Geist-style minimal + dark default + sharp contrasts |
| Beauty / lifestyle | Powdered Pastels + warm serifs + soft shadows |
