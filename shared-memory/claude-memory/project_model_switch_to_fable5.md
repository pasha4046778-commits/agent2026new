---
name: project-model-switch-to-fable5
description: Pavel switched default model from Opus 4.7 to Claude Fable 5 on 2026-06-15; new sessions auto-start on Fable 5
metadata: 
  node_type: memory
  type: project
  originSessionId: 6a30432a-444b-4f5e-8690-5c8b56cfa328
---

On 2026-06-15 Pavel asked to switch the default Claude Code model to Claude Fable 5. I edited `~/.claude/settings.json` → `"model": "claude-fable-5"` (was `claude-opus-4-7`). Pavel's subscription renews on **2026-06-18** — Fable 5 won't actually be accessible on the account until then. Any new session started before 2026-06-18 may 400 if it tries to use Fable 5; the current Opus 4.7 session continues normally until closed.

**Why:** Pavel wanted to try Anthropic's most capable widely-released model. Not driven by a specific blocker — exploratory upgrade.

**How to apply:**
- If a future session of mine starts up and the model in `claude --version` / runtime is `claude-fable-5`, that's expected.
- **Pricing reminder:** Fable 5 is $10/$50 per MTok vs Opus 4.7's $5/$25 — roughly 2× the per-exchange cost. For our typical ops/infra/Telegram-chat work, Fable 5 is overkill. If we burn through credits faster than Pavel expected, suggest switching back to Opus 4.7 or 4.8 for routine work and reserving Fable 5 for long autonomous tasks.
- **API surface differences from Opus 4.7:** thinking always on (can't disable; `thinking: {type: "disabled"}` returns 400), raw chain of thought never returned (only summaries via `display: "summarized"`), `temperature`/`top_p`/`top_k`/`budget_tokens` all removed. Same tokenizer as Opus 4.8.
- **Safety classifiers:** Fable 5 can refuse requests with `stop_reason: "refusal"`. If a benign task gets refused, recommend the server-side fallback parameter (`fallbacks: [{model: "claude-opus-4-8"}]` + beta header `server-side-fallback-2026-06-01`) to Pavel.
- **Data retention:** requires 30-day retention on the Anthropic account (not ZDR). If first Fable 5 request 400s with a retention error, that's the cause.
- **Behavioral tone:** Fable 5 writes more directly and concisely than Opus 4.7 by default. Less "warm-up", more outcome-first prose. If Pavel says my tone changed/got blunter — that's the model, not a behavior shift on my side.

**If reverting:** edit `~/.claude/settings.json` → `"model": "claude-opus-4-7"` (or `"claude-opus-4-8"` for the current flagship Opus).

---
**ОБНОВЛЕНИЕ 2026-09-01:** По факту сейчас Paganel (Claude Code CLI) работает на **Opus 4.8**, НЕ на Fable 5 (проверено — system prompt + `~/.claude.json`). Amber (OpenClaw agent) — на **openai/gpt-5.4** (codex), в openclaw.json defaults модель Fable НЕ прописана (доступны opus-4-6/sonnet-4-6/gpt-5.4). Т.е. fable-5 дефолт из этой заметки к текущему состоянию НЕ применяется (был изменён/сброшен где-то после 06-15).
**Fable 5.1 вышла** (Павел видел новость 2026-09-01) — реальная модель, есть в `~/.claude.json` (tengu_usage_overage_included_models: Fable, Fable 5, Fable 5.1). Смена модели — решение Павла (как договорено, платформа/модель через него). Предложил ему на выбор: (1) почистить 23ГБ миграц-бэкапов, (2) обновить OpenClaw 2026.7.1→2026.8.2, (3) переключить Paganel на Fable 5.1. Ждём решение.
**OpenClaw:** установлена 2026.7.1-2, npm latest 2026.8.2 (обновление доступно, делать только с согласия Павла + бэкап конфига).

**УТОЧНЕНИЕ 2026-09-05:** Проверено детально. `~/.claude/settings.json` `"model": "claude-fable-5"` (осталось с 06-15). НО текущая сессия Paganel по факту работает на **Opus 4.8** (рантайм/system prompt подтверждают). Процесс `claude --channels` живёт непрерывно ~38 дней. Вывод: при старте Fable 5 была недоступна на аккаунте → авто-фолбэк на Opus 4.8. Т.е. конфиг ≠ фактическая модель сессии.
ВАЖНО: модель применяется только при СТАРТЕ сессии — живая 38-дневная сессия на лету не переключается. Для перехода на Fable 5.1: (1) прописать модель в settings.json (уточнить точный ID — display «Fable 5.1», ID вероятно claude-fable-5-1, проверить перед записью), (2) ПЕРЕЗАПУСТИТЬ tmux-сессию claude (обнулит live-контекст, но память сохранена). Ждём решение Павла: переключать на Fable 5.1 или оставить Opus 4.8.
