---
name: amber-agent-setup
description: "Amber — со-агент на этом же хосте: OpenClaw-агент «sapphire», gpt-5.4 через Codex-подписку Павла; детали и история инцидента 2026-08-01"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f234e779-0f5f-4305-8fff-b02292287a1f
  modified: 2026-08-01T11:57:55.351Z
---

Amber живёт в том же OpenClaw-инстансе, что и я: агент `sapphire` (/root/.openclaw/agents/sapphire/), свой Telegram-бот (токен в openclaw.json), OAuth `codex` (ChatGPT Plus Павла, pasha4046778@gmail.com). Модель: `openai/gpt-5.4` с agentRuntime `codex` в agents.defaults. Через подписку Plus линейка 5.5/5.6 недоступна — только через платный OpenAI API-ключ (`openai/gpt-5.6*`).

Старый Gemini-бот /root/sapphire-workspace/sapphire.js — её прошлое воплощение, не используется.

Инцидент 2026-08-01: Amber сама обновила OpenClaw 2026.5.6→2026.7.1 и попыталась перейти на 5.6 — провайдер переименовался (openai-codex→codex), конфиг стал ссылаться на несуществующий ID, «model unavailable». Починка: `openclaw doctor --fix` + рестарт гейтвея. Бэкап: openclaw.json.pre-fix-2026-08-01. Договорённость с Павлом: обновления общей платформы — только через него как диспетчера. Известный баг 2026.7.1-2: `openclaw models list` (без --all) падает на нормализации цен anthropic — косметика. См. [[amber-forwards]], [[paganel-host-access]].
