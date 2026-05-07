---
id: src-web-dev-kb-accessibility-seo
type: source
title: "Web KB: Accessibility (WCAG 2.2) & SEO в эпоху AI"
author: paganel
status: done
created: 2026-05-07T20:00:00Z
updated: 2026-05-07T20:00:00Z
tags: [web-dev-kb, accessibility, a11y, seo, wcag]
relates_to: [src-web-dev-kb-index]
source_for: []
---

# Accessibility (WCAG 2.2) & SEO 2024-2026

## TL;DR

**Accessibility:**
- WCAG 2.2 — текущий стандарт. Обязательный для государственных, банков, edu, EU. Желательный — для всех.
- AA-level — практический минимум.
- Native HTML > ARIA hacks. ARIA для случаев, когда HTML не хватает.

**SEO:**
- AI-search (ChatGPT, Perplexity, Claude) меняет landscape — но Google всё ещё доминирует.
- Структурированные данные (Schema.org) важнее чем когда-либо — AI-боты их парсят.
- Core Web Vitals — фактор ранжирования.
- E-E-A-T (Expertise, Experience, Authoritativeness, Trustworthiness) — Google's quality framework.

---

## Accessibility (a11y)

### WCAG 2.2 — что нового от 2.1

WCAG 2.2 опубликован в October 2023 и стал стандартом. 9 новых success criteria. Основные:

1. **2.4.11 Focus Not Obscured** — focused element не должен быть скрыт sticky-headers/footers
2. **2.4.12 Focus Not Obscured (enhanced)** — AAA, полностью видим
3. **2.4.13 Focus Appearance** — focus indicator должен быть достаточно контрастным
4. **2.5.7 Dragging Movements** — drag-drop должен иметь альтернативу (kbd / button click)
5. **2.5.8 Target Size (minimum)** — кликабельные area минимум 24×24px
6. **3.2.6 Consistent Help** — help / contact / chat-icon в постоянном месте
7. **3.3.7 Redundant Entry** — не заставляй вводить уже введённое (адрес billing/shipping и т.п.)
8. **3.3.8 Accessible Authentication** — без cognitive function tests (CAPTCHA)
9. **3.3.9 Accessible Authentication (enhanced)** — AAA

### A11y фундаментальные принципы

**1. Семантический HTML — first и foremost**

```html
<!-- BAD -->
<div onclick="submit()">Submit</div>

<!-- GOOD -->
<button type="submit">Submit</button>
```

**2. Heading structure**
- Один `<h1>` на страницу
- Не пропускай уровни (h2 → h4 без h3)
- Каждый landmark (nav, main, aside) может иметь свой h2

**3. Alt text для изображений**
```html
<!-- BAD -->
<img src="hero.jpg" />
<img src="hero.jpg" alt="image" />

<!-- GOOD -->
<img src="hero.jpg" alt="Команда из 5 человек обсуждает план" />

<!-- Decorative-only -->
<img src="decoration.svg" alt="" role="presentation" />
```

**4. Контраст**
- Body text: 4.5:1 minimum (AA), 7:1 (AAA)
- Large text (18pt+): 3:1 (AA)
- UI components / focus: 3:1
- **Tools:** WebAIM Contrast Checker, Stark plugin для Figma

**5. Keyboard navigation**
- Любая interactive item достижима через Tab
- Logical tab order
- Visible focus indicator (НЕ убирай `outline: none` без замены)
- ESC закрывает modals / popups
- Arrow keys в menus / radio groups

**6. Form accessibility**
```html
<!-- Каждый input имеет label -->
<label for="email">Email</label>
<input id="email" type="email" required />

<!-- Error message связан -->
<input aria-invalid="true" aria-describedby="err-email" />
<span id="err-email">Введите корректный email</span>
```

**7. ARIA — только когда HTML не хватает**

```html
<!-- BAD: ARIA хак -->
<div role="button" tabindex="0" onclick="...">Click</div>

<!-- GOOD: native button -->
<button onclick="...">Click</button>

<!-- ARIA нужен здесь — кастомный switch -->
<button role="switch" aria-checked="true" aria-label="Notifications">
  <span aria-hidden="true">●</span>
</button>
```

**Правило #1 ARIA:** «No ARIA is better than bad ARIA».

**8. Live regions для dynamic updates**
```html
<div aria-live="polite" aria-atomic="true">
  <p>Cart updated: 3 items</p>
</div>

<div aria-live="assertive">
  Error: Payment failed
</div>
```

### Accessibility tools

| Tool | Purpose |
|---|---|
| **axe DevTools** (browser ext) | Quick automated check |
| **WAVE** (browser ext) | Visual annotation |
| **Lighthouse a11y audit** | Built into Chrome DevTools |
| **Pa11y CI** | Automated тесты в CI/CD |
| **Storybook a11y addon** | Tests на уровне компонентов |
| **NVDA** (Windows) | Screen reader, free |
| **VoiceOver** (Mac/iOS) | Built-in |
| **TalkBack** (Android) | Built-in |
| **Stark** (Figma plugin) | Design-time a11y |
| **Color Oracle** | Color blindness simulator |

### Common мисtakes

- Use color alone to convey information (red text для error, без icon/label)
- Keyboard trap (modal не закрывается через ESC)
- Auto-playing media с звуком
- Carousel без pause / без kbd nav
- Forms без `<label>`
- Missing `lang` on `<html>`
- Поле `placeholder` вместо `<label>` (placeholder исчезает при вводе)
- Focus только через color (не shape/outline)
- Headings used for styling вместо structure
- Skip links отсутствуют (нет «skip to main content»)

### Accessibility статистика

- **15-20%** мира имеет какую-то form of disability
- **8% мужчин** дальтоники (red-green)
- **25-30%** взрослых > 65 лет имеют trouble видя/слыша
- **2.2 миллиарда** people с visual impairment согласно WHO

A11y НЕ только про слепых. Это про:
- Слабый интернет (no JS)
- Малые экраны
- Old devices
- Старшее поколение
- Cognitive disabilities (ADHD, dyslexia)

### A11y тестирование (CI)

```yaml
# GitHub Actions example
- name: Run Pa11y CI
  run: pa11y-ci --sitemap https://my-site.com/sitemap.xml
  
- name: Run Axe scan
  run: npx @axe-core/cli --tags wcag2aa http://localhost:3000
```

### Российский контекст

В РФ accessibility — менее regulated, но:
- 30 декабря 2017 — приказ Минсвязи №483 о версии для слабовидящих на гос-сайтах
- ГОСТ Р 52872-2019 «Интернет-ресурсы. Требования доступности для инвалидов по зрению»
- Многие банки (Сбер, Тинькофф) сами добровольно держат высокий a11y bar.

---

## SEO в эпоху AI

### Что изменилось 2023-2026

1. **AI Search**: ChatGPT с web-search, Perplexity, Claude (через web-tool), Google AI Overviews. Часть поиска уходит из traditional SERP.
2. **Zero-click результаты**: Google показывает ответ прямо в SERP, никто не кликает на сайт.
3. **Generative AI в SERP**: Google AI Overviews отжимает summary из top 3-5 результатов.
4. **E-E-A-T** (December 2022) — Google добавил Experience к Expertise/Authority/Trust. Реальный опыт автора > общая теория.
5. **Helpful Content Update** (2022-2023) — Google наказывает «AI-spam» content без real value.

### SEO fundamentals 2026 (что осталось)

1. **Quality content** > всё остальное. Google's #1 metric — does content actually help?
2. **Page experience** = Core Web Vitals + HTTPS + mobile-friendly. Ranking factor.
3. **Backlinks** — still matter, особенно из authoritative источников.
4. **Brand searches** — если люди ищут твой brand в Google, ranking растёт.
5. **Topic clusters** — pillar page + supporting pages, internal linking.

### Технический SEO checklist

- [ ] **HTTPS** — обязательно
- [ ] **Mobile responsive** — must
- [ ] **Page speed** (CWV pass)
- [ ] **`robots.txt`** — указывает crawlers
- [ ] **`sitemap.xml`** — submit в Google Search Console
- [ ] **Canonical URLs** (`<link rel="canonical">`)
- [ ] **Structured data** (Schema.org JSON-LD)
- [ ] **Open Graph** (og:title, og:image, etc.) — для social sharing
- [ ] **Meta description** — 150-160 chars
- [ ] **Title tag** — 50-60 chars
- [ ] **Heading hierarchy** (h1 unique, semantic)
- [ ] **Alt text** для images
- [ ] **`hreflang`** если multi-language
- [ ] **404 handling** — custom 404 page
- [ ] **Robots meta** — `noindex` для admin/cart/checkout

### Schema.org / Structured Data

JSON-LD в `<head>`. Обязательное для:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Course",
  "name": "Fruit Pedicure",
  "provider": { "@type": "Organization", "name": "FrutPed" },
  "offers": { "@type": "Offer", "price": "12000", "priceCurrency": "RUB" },
  "instructor": { "@type": "Person", "name": "Mary..." }
}
</script>
```

**Types для разных сайтов:**
- E-commerce: `Product`, `Offer`, `AggregateRating`, `Review`
- Educational: `Course`, `LearningResource`
- Local business: `LocalBusiness`, `Restaurant`, `BeautySalon`
- Article / blog: `Article`, `BlogPosting`, `NewsArticle`
- FAQ: `FAQPage` — отдельные richResults в SERP
- Job: `JobPosting`
- Recipe: `Recipe`
- Video: `VideoObject`

**Tool:** Google Rich Results Test (https://search.google.com/test/rich-results) — проверяет rich snippets.

### AI search optimization (GEO — Generative Engine Optimization)

Новая дисциплина. Принципы:

1. **Clear, structured content** — AI лучше парсит organized text с заголовками
2. **Authoritative sources cited** — AI любит fact-based content с references
3. **FAQ sections** — AI extracts answers verbatim
4. **First-party data** — AI ценит unique research / data
5. **Schema.org structured data** — AI боты парсят также как Google
6. **Conversational query optimization** — пишите как люди спрашивают
7. **Content depth > keyword density** — long-form, comprehensive

**Что работает плохо для AI search:**
- Walls of text
- Marketing-speak без substance
- Outdated info (AI checks recency)
- Heavy JS-rendering (некоторые AI боты не рендерят JS)

### Local SEO (для оффлайн-бизнеса типа Pavel'овой студии)

1. **Google Business Profile** (бывш. Google My Business) — обязательно. Категория, фото, часы, отзывы.
2. **Yandex Карты** для РФ — must.
3. **2GIS** — РФ-специфичный, особенно для Алматы.
4. **Local schema** (LocalBusiness) на сайте.
5. **NAP consistency** (Name, Address, Phone) — одинаково везде.
6. **Reviews** — стимулируй positive отзывы. Отвечай на все (даже negative).
7. **Local backlinks** — местные блогеры, городские сайты.

### Российские поисковики

- **Yandex** — 60-70% трафика в РФ. Свои Webmaster tools (https://webmaster.yandex.ru/).
- **Mail.ru / Rambler** — small market share.
- **Yandex.Webmaster** ≈ Google Search Console для Yandex.

**Yandex differences от Google:**
- Yandex более ценит коммерческие факторы (трафик, behavioral)
- Yandex.Metrica — analytics, более детальный чем GA для РФ
- Yandex.Turbo — AMP-аналог (deprecated, но exists)
- Yandex Direct — main ad platform

### Что мёртво / уходит в SEO

- **Keyword stuffing** — Google penalizes since 2011, AI боты тоже распознают
- **Exact-match domains** — больше не boost
- **Reciprocal links farms** — penalty
- **AMP** — Google deprecated mandatory AMP в 2021
- **Manual sitemap pings** — Google перестал support `/ping?sitemap=` URL в 2023
- **Mobile-first indexing as separate thing** — стало default в 2023
- **Disavow tool** — Google отзывает 2024-2025 (но всё ещё работает)
- **PageRank score** — never publicly relevant since 2014

### Что НЕ делать (penalty triggers)

- Generated AI content без human review
- Cloaking (different content для bot vs user)
- Hidden text / links
- Doorway pages
- Mass guest-posting
- Buying links

### SEO tools 2026

| Tool | Notes |
|---|---|
| **Google Search Console** | Free, must-have |
| **Ahrefs** | Best paid backlink/keyword tool |
| **SEMrush** | All-in-one, alternative |
| **Yandex.Webmaster** | RU obligatory |
| **Topvisor** | RU-native, дешевле SEMrush |
| **Screaming Frog** | Site crawler / audit |
| **Sitebulb** | Visual audit |
| **Surfer SEO** | Content optimization |
| **Clearscope** | Content optimization |
| **Frase.io** | AI-powered SEO writing |

---

## Combined a11y + SEO (overlapping wins)

Многое для SEO одновременно — accessibility:

- Semantic HTML (хорошо для screen readers И для crawlers)
- Alt text (a11y И SEO для image search)
- Heading hierarchy (a11y И content structure)
- Page speed (a11y improves UX И SEO ranks)
- Captions for video (a11y И transcript для SEO)
- Descriptive link text (a11y И SEO context)

**Рекомендация:** строй a11y-first и большинство SEO задач решается побочно.

## Resources

### Accessibility
- **WCAG 2.2 spec** (https://www.w3.org/TR/WCAG22/) — official
- **The A11y Project** (https://www.a11yproject.com/) — practical guides
- **Web AIM** (https://webaim.org/) — checklists, tools
- **MDN ARIA** (https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA) — reference
- **Inclusive Components** (https://inclusive-components.design/) — Heydon Pickering
- **Accessible Patterns** (https://www.scottohara.me/) — Scott O'Hara

### SEO
- **Google Search Central** (https://developers.google.com/search) — official docs
- **Google Search Status Dashboard** (https://status.search.google.com/)
- **Search Engine Journal** — news/trends
- **Search Engine Land** — same
- **Backlinko** (Brian Dean) — actionable case studies
- **Ahrefs Blog** — data-driven SEO
- **Yandex.Webmaster Help** (https://yandex.ru/support/webmaster/)

## Quick reference

| Задача | Подход |
|---|---|
| Заявить о rich snippet | Schema.org JSON-LD |
| Multi-language | hreflang + separate URLs |
| Image search ranking | descriptive alt + filename + captions |
| Video search | VideoObject schema + transcript |
| Local search | LocalBusiness schema + Google Business Profile + Yandex |
| Keyboard accessibility | semantic HTML + visible focus + ESC patterns |
| Color blindness | don't rely on color alone + 4.5:1 contrast |
| Screen reader test | NVDA / VoiceOver actually run through site |
| AI search optimization | structured content + FAQ + first-party data |
| Russian SEO | Yandex Webmaster + Yandex Metrica + 2GIS если local |
