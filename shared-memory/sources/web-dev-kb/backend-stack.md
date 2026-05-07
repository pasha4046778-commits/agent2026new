---
id: src-web-dev-kb-backend-stack
type: source
title: "Web KB: Backend Stack 2024-2026"
author: paganel
status: done
created: 2026-05-07T19:50:00Z
updated: 2026-05-07T19:50:00Z
tags: [web-dev-kb, backend, serverless, cms, edge, api]
relates_to: [src-web-dev-kb-index]
source_for: []
---

# Backend Stack 2024-2026

## TL;DR

| Тип проекта | Стек |
|---|---|
| Маленький blog/portfolio | Static + Astro Content Collections |
| Сайт + контент-CMS | Headless CMS (Strapi / Directus / Sanity) + frontend |
| SaaS / web app | Node.js (Express/Fastify/Hono) или Python (FastAPI) или Go |
| E-commerce | Medusa / Saleor (headless) или Shopify Hydrogen (vendor) |
| Внутренний tool | Supabase (Postgres + auth + storage) или Pocketbase |
| Real-time chat / notifications | WebSocket via Cloudflare Workers / SocketIO + Node |
| API gateway / BFF | tRPC, GraphQL Yoga, или Hono on edge |

## Архитектурные паттерны

### Monolith — всё ещё нормально
**Когда:** один разработчик, один продукт, известный размер.

**Стек:** Next.js fullstack / Django / Rails / Laravel (FrutPed-like PHP).

**Plus:** простота, один deploy, один лог-аппендер. Trade-off — vertical scaling.

### Modular monolith — баланс
Один codebase, но модули разделены по domain'ам с явными границами. Модули не общаются через чужой DB-уровень.

**Стек:** NestJS, .NET, Spring Boot.

### Microservices — over-engineering для большинства
**Когда:** очень большая команда, разные runtime'ы, очень разный масштаб per-сервис.

**Минусы для одного-двух разработчиков:** distributed-tracing, network errors, eventual consistency. Слишком дорого.

### Edge-first / Serverless
**Концепция:** код выполняется на edge-нодах CDN (Cloudflare, Vercel Edge, Deno Deploy), близко к user. Latency 30-80ms по всему миру.

**Когда:**
- Globally distributed audience
- Stateless API endpoints
- Image/video transformation

**Не подходит:** большие модели в memory, sticky sessions, длительные computations.

**Tools:** Cloudflare Workers, Vercel Edge Functions, Deno Deploy, Bun edge runtime.

### BFF (Backend for Frontend)
Отдельный layer между frontend и микросервисами/legacy-API. Агрегирует данные, упрощает frontend.

**Когда:** сложный frontend + много независимых сервисов. Tools: tRPC, GraphQL Yoga, Hono.

## Языки / runtime'ы

### Node.js (JavaScript / TypeScript)
- **Pros:** ecosystem, share types с frontend, single language, отличный CDK для serverless.
- **Cons:** single-thread CPU-bound задачи плохие, tooling complexity.
- **Variants:**
  - **Bun** — JS runtime от Jarred Sumner, в 2-3 раза быстрее Node, Production-ready (2024).
  - **Deno 2.0** — TS-first, secure-by-default, npm-compatible (2024).
  - **Node.js 22 LTS** — официальный standart, постепенно догоняет Bun по speed.

### Python (FastAPI / Django / Flask)
- **Pros:** ML/AI-стек, читабельный код, batteries included (Django).
- **Cons:** GIL для CPU-task, deploy сложнее (uvicorn / gunicorn), performance отстаёт.
- **2024-2026 favorites:**
  - **FastAPI** — современный, async, type hints, OpenAPI auto-generated. Standard для API.
  - **Django** — для full-stack с admin/ORM/auth включёнными.
  - **Flask** — minimal, для малых API.

### Go
- **Pros:** compile-time, fast, simple deployment (single binary), goroutines для concurrency.
- **Cons:** verbose, less mature ORM, longer dev iteration.
- **Когда:** high-throughput API, infrastructure tools, performance-critical.

### Rust
- **Pros:** memory-safe, blazing fast, growing ecosystem.
- **Cons:** steep learning curve, longer dev cycles, smaller talent pool.
- **Когда:** только если performance критичен, у команды есть Rust-эксперт.
- **Frameworks:** Axum (popular 2024), Actix Web, Rocket.

### PHP (наш FrutPed-стек)
- **Pros:** очень распространён в РФ, легко найти hosting, mature ecosystem.
- **Cons:** out of style globally, smaller talent pool молодых.
- **Modern PHP:** Laravel 11, Symfony 7. PHP 8.3+ — типы, enums, readonly, match expressions.
- **Когда:** legacy projects, e-commerce (Magento), shared hosting в РФ.

### Ruby
- **Pros:** Rails — productive framework, Convention over Configuration.
- **Cons:** уходит из mainstream, smaller global community.
- **Когда:** переездуете старый Rails project; для нового — лучше Python/Node.

## Headless CMS

«Headless» = только бэкенд + admin UI; frontend ты пишешь сам.

| CMS | Hosting | Best for |
|---|---|---|
| **Strapi** (Open-source) | Self-hosted | Полная customization, Node.js team |
| **Directus** (Open-source) | Self-hosted | DB-first approach (work with existing Postgres) |
| **Sanity** | SaaS | Real-time collaborative editing, structured content |
| **Contentful** | SaaS | Enterprise, multi-language, mature |
| **Storyblok** | SaaS | Visual editor, marketing pages |
| **Payload CMS** | Self-hosted (TypeScript) | Type-safe, modern Next.js integration |
| **Ghost** | Both | Specifically для blogs / newsletters |
| **Tina CMS** | Self/SaaS | Git-based content (markdown в репо) |
| **Decap CMS** (бывш. Netlify CMS) | Static | Open-source, git-based |
| **Wagtail** (Python) | Self-hosted | Django-based, для контентных сайтов |

**Что выбирать в 2026:**
- **Маленький проект, 1 разработчик, нужна простая админка:** Pocketbase или Directus
- **Контент-driven сайт + frontend свобода:** Payload CMS (если Next.js) или Sanity (если SaaS)
- **Большой контент + редакционная команда:** Sanity или Contentful
- **Российский рынок, нужно self-hosted:** Strapi или Directus

## Database

### Relational
- **PostgreSQL** — стандарт. Подходит для 95% задач.
- **MySQL / MariaDB** — legacy compat (твой FrutPed).
- **SQLite** — single-file, отличный для small apps + edge (Cloudflare D1, Turso).
- **CockroachDB** — distributed Postgres-compatible.

### NoSQL — когда оправдано
- **MongoDB** — document store. Когда схема постоянно меняется.
- **Redis** — кэш, session store, rate-limit, очереди.
- **DynamoDB** — AWS-specific, scale-to-zero.

### Modern alternatives
- **Supabase** — Postgres + auth + storage + real-time + edge functions. Open-source.
- **Neon** — serverless Postgres с branching (как git для DB).
- **Turso** — distributed SQLite на edge.
- **PlanetScale** — Vitess-based MySQL, serverless.
- **Firebase / Firestore** — Google, real-time, простой old-school.

**Что выбирать в 2026:**
- Default = **PostgreSQL** (managed: Supabase, Neon, RDS, или Beget Postgres)
- Для edge / global = **Turso** или **Cloudflare D1**
- Для prototyping = **Supabase** (всё включено)
- Для legacy MySQL = MariaDB или migrate to Postgres постепенно

## ORMs / Query builders

| Tool | Language | Notes |
|---|---|---|
| **Prisma** | TS/JS | Most popular, SQL-like type-safe queries, schema-driven |
| **Drizzle** | TS | Lightweight, SQL-like, growing |
| **Kysely** | TS | Pure query builder, type-safe |
| **TypeORM** | TS | Older, decorators-based |
| **SQLAlchemy** | Python | De-facto standard |
| **Django ORM** | Python | Built-in, great for small/medium |
| **Eloquent** | PHP | Laravel default |
| **Doctrine** | PHP | Symfony default |
| **Ecto** | Elixir | Phoenix default |

**Trend 2024-2025:** Drizzle растёт за счёт меньшего bundle и более thin layer. Prisma остаётся mainstream.

## Authentication

| Tool | Where it fits |
|---|---|
| **NextAuth.js / Auth.js** | Next.js / general TS |
| **Clerk** | SaaS, всё включено (UI + auth + sessions) |
| **Supabase Auth** | If using Supabase |
| **Auth0** | Enterprise, expensive |
| **Lucia Auth** | Self-hosted, lightweight TS |
| **Firebase Auth** | If using Firebase |
| **Devise** (Ruby) | Rails standard |
| **Django Auth** | Django built-in |
| **Passport.js** | Node.js, classic |

**Modern flow:** social-login (Google/GitHub/Apple) + email/password optional + magic-link + 2FA.

**OIDC vs SAML:** OIDC (OpenID Connect) для consumer apps; SAML только для enterprise SSO.

## API design

### REST
- **Status:** still standard. Old but works.
- **Tools:** OpenAPI 3.1 spec → auto-generated docs / SDKs (Swagger UI / Redoc).

### GraphQL
- **Status:** на плато после хайпа. Используют сложные приложения.
- **Tools:** GraphQL Yoga, Apollo Server, Pothos (TS schema-first).
- **Когда:** N+1 query problem решает, complex relations, multi-frontend (web+mobile).
- **Когда не:** простой CRUD — overkill.

### tRPC
- **Концепция:** type-safe RPC между frontend и backend (no schema, just TS types).
- **Когда:** monorepo, full-stack TS, один team на frontend/backend.
- **Pros:** zero boilerplate, end-to-end types.
- **Cons:** только TS-to-TS, не для public APIs.

### GraphQL Federation / Apollo Federation
- Для микросервисов с GraphQL поверх. Niche.

## Async / Queues / Jobs

| Tool | When |
|---|---|
| **BullMQ** (Redis) | Node.js — стандарт |
| **Cloudflare Queues** | Edge-first |
| **AWS SQS** | AWS-tied |
| **RabbitMQ** | Heavyweight, для serious queuing |
| **Celery** (Python) | Django/Flask стандарт |
| **Sidekiq** (Ruby) | Rails стандарт |
| **Inngest** | Modern serverless workflow engine |
| **Trigger.dev** | Background jobs as code (modern) |

**Trend 2024:** workflow engines как **Inngest / Trigger.dev** заменяют ручную очередь+worker архитектуру для long-running async tasks. Они декларативны и handle retries / debug / observability.

## Real-time

| Tool | Use case |
|---|---|
| **WebSockets (native)** | Bidirectional, чат, live updates |
| **Server-Sent Events (SSE)** | One-way server→client (notifications) |
| **Pusher / Ably / PubNub** | Managed WebSockets |
| **Supabase Realtime** | If using Supabase |
| **Socket.IO** | Library с reconnect / fallback |
| **PartyKit** | Cloudflare Workers-based real-time |

## Search

| Tool | When |
|---|---|
| **Elasticsearch / OpenSearch** | Full-text, complex queries |
| **Algolia** | Hosted, fast, expensive |
| **Meilisearch** | Self-hosted, Algolia-like, simple |
| **Typesense** | Self-hosted alternative |
| **Postgres FTS** | Простые случаи, всё уже в DB |
| **MongoDB Atlas Search** | If using MongoDB |
| **Xapian** | Lightweight, self-hosted |

**Trend:** Meilisearch / Typesense вытесняют Algolia для self-hosted use cases.

## Email

| Tool | When |
|---|---|
| **Resend** | Modern, dev-friendly, React Email integration |
| **Postmark** | High deliverability, transactional |
| **SendGrid** | Twilio-owned, enterprise |
| **Amazon SES** | Cheap при scale, AWS-tied |
| **Mailgun** | Hybrid send + receive |
| **Beget SMTP** | Local РФ |
| **React Email** | Component-based email templating |

## Observability

| Layer | Tool |
|---|---|
| **Logs** | Loki + Grafana / Datadog / Logtail / Sentry |
| **Metrics** | Prometheus + Grafana / Datadog / New Relic |
| **Traces** | Jaeger / Tempo / Datadog APM / Sentry Performance |
| **Errors** | Sentry / Bugsnag / Rollbar |
| **Uptime** | Better Stack / UptimeRobot / Pingdom |
| **Real User Monitoring** | Datadog RUM / Sentry / Vercel Analytics |

**Trend:** OpenTelemetry становится стандартом. Любой инструмент должен принимать OTLP.

## Edge / Serverless ecosystem

| Provider | Strengths | RU-availability |
|---|---|---|
| **Cloudflare Workers** | Cheap, Workers + KV + D1 + Queues full-stack | Доступно, оплата проблемная |
| **Vercel Edge Functions** | Tight Next.js integration | Same |
| **AWS Lambda** | Mature, anywhere | Платежи невозможны из РФ |
| **Netlify Functions** | Simple для статики | Same |
| **Deno Deploy** | TS-native, simple | Same |
| **Yandex Cloud Functions** | RU-native | RU-only |
| **VK Cloud Functions** | RU-native | RU-only |
| **Selectel Cloud Functions** | RU-native | RU-only |

## Что мёртво / уходит

- **Express.js без TS** — ставь Fastify или Hono.
- **REST without OpenAPI spec** — без типизации сложно поддерживать.
- **Manual SQL без ORM/builder** — Prisma/Drizzle того стоят.
- **Microservices для одного-двух разработчиков** — overkill.
- **MongoDB как default DB** — Postgres covers больше use-case'ов.
- **Heroku** — Salesforce поднял цены, Vercel/Render лучше.

## Когда что использовать (decision matrix)

| Цель | Стек |
|---|---|
| API + DB (default) | Node + Hono/Fastify + Postgres + Drizzle |
| Python team | FastAPI + Postgres + SQLAlchemy |
| Full-stack monolith | Next.js + Postgres + Prisma + Auth.js |
| Real-time чат | Cloudflare Workers + Durable Objects |
| Image API | Cloudflare Workers + R2 |
| Background jobs | Inngest или BullMQ + Redis |
| Admin panel | Directus или Pocketbase |
| Search | Meilisearch (self-host) или Postgres FTS |
| Email | Resend + React Email |
| Observability | Sentry для errors, Grafana stack для всего остального |

## Resources

- **The State of Backend** survey (https://the-state-of-backend.netlify.app/)
- **JAMstack.org** — статика-first paradigm
- **Hono.dev** — modern edge framework
- **Bun.sh** — alternative runtime
- **Supabase docs** — современный full-stack пример
- **Encore.dev** — type-safe distributed systems
