---
name: reference-hab-project
description: "hab. studio (gudhab.com) — primary client project, live on Latvia VPS port 3001 via nginx+LE; full context in shared-memory/projects/hab-gudhab-com.md"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 79d280f8-6f68-454c-bb05-d9249b258640
---

# hab. — Pavel's studio project

**Status:** in_progress (pre-launch), v0.7 deployed, ~32 commits

**Live URLs:**
- Public: https://gudhab.com (TLS, LE auto-renew, nginx → :3001)
- Source on Latvia: `/var/www/hab-site/`
- Local mirror: `/root/hab-site/` (git tracked)

**Stack:** Next.js 15.5.18, React 19, Tailwind 4, SQLite, next-intl (ru/en/kk), @habnotifier_bot for new-brief notifications.

**Full project snapshot:** `shared-memory/projects/hab-gudhab-com.md` — load this file at start of every hab-related session to see current state, open questions, and what Pavel is waiting on.

**Brand guidebook from Amber:** `brand/hab-brand-guidebook-v1.md` (dark-first + electric mint + Inter + Lucide icons, motion principles, voice formula действие→польза→конкретика).

**Studio market audit from Amber (2026-05-22):** `research/studios-audit/` — 102 CIS+EU studios, useful for positioning decisions; I have 4 outstanding proposals based on it (see project file), Pavel needs to prioritize.

**Deploy workflow:** edit local → `rsync src/` → `ssh latvia "cd /var/www/hab-site && npm run build && systemctl restart hab-site"`. SSH alias `latvia` already configured in `~/.ssh/config`.
