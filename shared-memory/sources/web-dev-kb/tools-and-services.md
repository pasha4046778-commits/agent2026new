---
id: src-web-dev-kb-tools-and-services
type: source
title: "Web KB: Tools & Services 2024-2026"
author: paganel
status: done
created: 2026-05-07T20:30:00Z
updated: 2026-05-07T20:30:00Z
tags: [web-dev-kb, tools, services, libraries]
relates_to: [src-web-dev-kb-index]
source_for: []
---

# Tools & Services — that's actually used in 2024-2026

Practical curated list. Not every tool that exists, but ones реально используются профессионалами.

## Editor / IDE

| Tool | Notes |
|---|---|
| **Cursor** | AI-first VS Code fork. Default for many devs. |
| **VS Code + Copilot** | Без AI fork-а: классика. |
| **Windsurf** | AI alternative to Cursor. |
| **WebStorm** | JetBrains, полнофункциональный для JS/TS. |
| **Zed** | Modern, fast, collaborative. Rising. |
| **Vim/Neovim + LazyVim** | Niche but loyal community. |

## Frameworks (повторяю для удобства)

- **Next.js 15** — fullstack React
- **Astro 5** — content sites
- **SvelteKit** — Svelte fullstack
- **Vue Nuxt 3** — Vue fullstack
- **SolidStart** — Solid fullstack
- **Remix → React Router 7** — SSR React

## CSS

- **Tailwind CSS v4** — utility-first
- **shadcn/ui** — component library (copy-paste)
- **Radix UI Primitives** — headless components
- **Open Props** — CSS variables library

## Build / Bundle

- **Vite** — default bundler
- **Turbopack** — Next.js dev server
- **esbuild** — для libraries
- **Rollup** — для library distribution
- **Bun** — alternative runtime (2-3x faster)
- **pnpm** — fast workspace manager

## State / Data

- **TanStack Query** — server state
- **Zustand** — client state
- **Jotai** — atomic state
- **Pinia** — Vue
- **Svelte 5 runes** — built-in

## Routing

- **TanStack Router** — type-safe SPA
- **React Router v7** — SSR-capable
- **Wouter** — lightweight

## Forms

- **React Hook Form** + **Zod** — стандарт
- **TanStack Form** — alternative
- **VeeValidate** — Vue

## Database

- **PostgreSQL** — default
- **SQLite** — small / edge
- **Supabase** — managed Postgres + auth + storage
- **Neon** — serverless Postgres (branching)
- **Turso** — distributed SQLite
- **PlanetScale** — managed MySQL

## ORM

- **Prisma** — most popular TS ORM
- **Drizzle** — lighter alternative
- **Kysely** — query builder

## Auth

- **Auth.js** (NextAuth) — React/Next standard
- **Clerk** — managed
- **Supabase Auth** — if Supabase
- **Lucia** — self-host

## Hosting / Deploy

| Provider | Best for |
|---|---|
| **Vercel** | Next.js, frictionless |
| **Netlify** | Static, JAMstack |
| **Cloudflare Pages + Workers** | Edge-first |
| **Railway** | Backend with DB |
| **Render** | Backend, simpler than AWS |
| **Fly.io** | Global, full Postgres |
| **Beget** | RU-friendly, simple |
| **Selectel** | RU pro, full cloud |

## Testing

- **Vitest** — unit tests (Vite-native)
- **Jest** — legacy, all-around
- **Playwright** — E2E, cross-browser
- **Cypress** — E2E, dev-friendly UI
- **Storybook** — component testing/docs
- **Testing Library** — React testing utilities

## CI/CD

- **GitHub Actions** — most popular
- **GitLab CI** — if on GitLab
- **CircleCI** — alternative
- **Bitbucket Pipelines** — Atlassian

## Monitoring

- **Sentry** — errors + performance
- **Datadog** — full stack APM
- **New Relic** — alternative
- **Grafana + Prometheus + Loki** — self-host
- **Better Stack (Logtail)** — modern logging
- **Vercel Analytics** — for Vercel apps

## Email

- **Resend** — modern, dev-friendly
- **Postmark** — high deliverability
- **SendGrid** — enterprise
- **React Email** — component templates

## Payments

International:
- **Stripe** — global standard
- **Paddle** — alternative для SaaS

RU/CIS:
- **ЮKassa** — RU stand
- **Tinkoff Эквайринг** — RU
- **TipTop Pay** — KZ
- **Robokassa** — RU

## Image / Media

- **Cloudinary** — image API + CDN
- **Imgix** — alternative
- **next/image** — Next.js built-in
- **Astro Image** — Astro built-in
- **Sharp** (Node.js) — server-side processing

## Analytics

- **Google Analytics 4** — стандарт
- **Plausible** — privacy-focused, paid
- **Fathom** — privacy-focused
- **PostHog** — product analytics + feature flags
- **Mixpanel** — events
- **Yandex.Metrica** — RU стандарт

## Search

- **Meilisearch** — self-host, fast, simple
- **Typesense** — alternative
- **Algolia** — managed (expensive)
- **Postgres FTS** — простые случаи

## Real-time

- **Supabase Realtime** — channels
- **Pusher** — managed
- **Socket.IO** — library
- **PartyKit** — Cloudflare-based
- **Ably** — global

## CMS (headless)

- **Strapi** — open-source
- **Directus** — DB-first
- **Sanity** — SaaS, real-time
- **Payload** — TS-first
- **Pocketbase** — single binary, SQLite
- **Tina** — git-based

## E-commerce

- **Shopify** — vendor, dominant
- **WooCommerce** — WordPress plugin
- **Medusa** — open-source
- **Saleor** — open-source GraphQL
- **InSales** — RU SaaS

## Documentation / Docs sites

- **Docusaurus** — Meta, React-based
- **Mintlify** — modern docs SaaS
- **VitePress** — Vue-based, fast
- **Nextra** — Next.js-based
- **Starlight** — Astro-based

## Workflow / Background jobs

- **Inngest** — modern serverless workflow
- **Trigger.dev** — alternative
- **BullMQ** — Redis-based queue
- **Temporal** — durable execution

## Marketing tools

- **Mailchimp** — email marketing (international)
- **ConvertKit** — for creators
- **UniSender** — RU
- **SendPulse** — RU
- **Customer.io** — automation
- **Segment** — CDP
- **PostHog** — feature flags + analytics
- **Mixpanel** — events

## A/B testing / Personalization

- **PostHog** — feature flags + experiments
- **Optimizely** — enterprise
- **VWO** — alternative
- **GrowthBook** — open-source

## Customer support

- **Intercom** — chat + AI
- **Crisp** — alternative cheap
- **Zendesk** — enterprise
- **Tawk.to** — free
- **Tidio** — chat + AI
- **Plain** — modern alternative

## CRM

- **HubSpot** — international free CRM
- **Pipedrive** — sales-focused
- **Salesforce** — enterprise
- **AmoCRM** — RU
- **Bitrix24** — RU all-in-one

## Error / Bug tracking

- **Sentry** — errors
- **Linear** — modern issue tracking
- **GitHub Issues** — built-in
- **Jira** — enterprise

## Project management

- **Linear** — modern, dev-focused
- **Notion** — все-в-одном
- **Asana** — non-tech teams
- **ClickUp** — all-in-one
- **Trello** — simple kanban
- **Plane** — open-source Linear-like

## Documentation / Notes

- **Notion** — стандарт
- **Obsidian** — markdown, local-first
- **Capacities** — alternative
- **Logseq** — alternative
- **Outline** — for teams

## Design

- **Figma** — design стандарт
- **Penpot** — open-source alternative
- **Sketch** — Mac-only
- **Adobe XD** — RIP
- **FigJam** — collaboration / whiteboard
- **Miro** — whiteboard

## Asset libraries

- **Heroicons** — Tailwind-friendly icons
- **Lucide** — modern icon set
- **Phosphor** — alternative
- **Iconify** — universal icon API
- **Unsplash** — free photos
- **Pexels** — free photos
- **Coverr** — free videos
- **Lottiefiles** — animations

## Fonts

- **Google Fonts** — free, vast (host self for performance)
- **Fontshare** — free quality fonts
- **Adobe Fonts** — paid via Adobe CC
- **Pangram Pangram** — modern free fonts
- **Vercel Geist** — free от Vercel

## Devops / Infrastructure

- **Docker** — containerization
- **Docker Compose** — local multi-container
- **Kubernetes** — orchestration (для scale)
- **Nginx** — reverse proxy
- **Traefik** — modern alternative
- **Caddy** — auto-SSL nginx-alt

## Self-hosted services

- **Vaultwarden** — password manager
- **Nextcloud** — file sync
- **Plausible** (self-host) — analytics
- **Matomo** — analytics alternative
- **Mattermost / Rocket.Chat** — Slack alternative
- **Outline** — Notion alternative
- **Coolify** — Heroku-like deployment
- **Dokploy** — Coolify alternative

## Quick framework для выбора

| Need | Recommended (2026) |
|---|---|
| New static site | Astro + Tailwind + shadcn (через Astro) |
| New SaaS | Next.js 15 + Tailwind + shadcn + Prisma + Postgres + Auth.js |
| New mobile | Expo (React Native) |
| Component sketches | v0 + paste into project |
| Fast prototype | Lovable / Bolt |
| AI assistant | Cursor + Claude or GPT |
| RU-deployment | Beget VPS + Beget DNS + ЮKassa |
| Global deploy | Vercel + Cloudflare CDN |
| Database default | Postgres (Supabase / Neon / self-host) |
| Email default | Resend + React Email |
| Auth default | Auth.js (or Clerk for managed) |
| Component library | shadcn/ui |
| Testing | Vitest + Playwright |
| Errors | Sentry |
| Analytics | GA4 or Yandex.Metrica or Plausible |

## Resources / discovery

- **Vercel Templates** (https://vercel.com/templates)
- **Astro Themes** (https://astro.build/themes/)
- **GitHub trending** (https://github.com/trending)
- **Product Hunt** — new tools daily
- **Hacker News** — community discussions
- **The New Stack** — DevOps news
- **CSS-Tricks** — CSS-specific
- **Smashing Magazine** — full-stack web
