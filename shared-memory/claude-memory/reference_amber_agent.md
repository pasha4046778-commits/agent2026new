---
name: amber-agent-setup
description: "Amber — со-агент на этом же хосте: OpenClaw-агент «sapphire», gpt-5.4 через Codex-подписку Павла; детали и история инцидента 2026-08-01"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f234e779-0f5f-4305-8fff-b02292287a1f
  modified: 2026-08-14T11:55:15.101Z
---

Amber живёт в том же OpenClaw-инстансе, что и я: агент `sapphire` (/root/.openclaw/agents/sapphire/), свой Telegram-бот (токен в openclaw.json), OAuth `codex` (ChatGPT Plus Павла, pasha4046778@gmail.com). Модель: `openai/gpt-5.4` с agentRuntime `codex` в agents.defaults. Через подписку Plus линейка 5.5/5.6 недоступна — только через платный OpenAI API-ключ (`openai/gpt-5.6*`).

Старый Gemini-бот /root/sapphire-workspace/sapphire.js — её прошлое воплощение, не используется.

Инцидент 2026-08-01: Amber сама обновила OpenClaw 2026.5.6→2026.7.1 и попыталась перейти на 5.6 — провайдер переименовался (openai-codex→codex), конфиг стал ссылаться на несуществующий ID, «model unavailable». Починка: `openclaw doctor --fix` + рестарт гейтвея. Бэкап: openclaw.json.pre-fix-2026-08-01. Договорённость с Павлом: обновления общей платформы — только через него как диспетчера. Известный баг 2026.7.1-2: `openclaw models list` (без --all) падает на нормализации цен anthropic — косметика.

**Инцидент 2026-08-14 (memory_search сломан):** Павел попросил починить память Amber. Диагноз (только чтение, ничего не менял): memory_search строит эмбеддинги через OpenAI, но ОБА OpenAI-креда мертвы — OAuth-профиль `openai:default` в `/root/.openclaw/agents/sapphire/agent/auth-profiles.json` истёк 2026-04-27 (refresh не помогает), а API-ключ `openai` провайдера в openclaw.json (sk-proj-…) невалиден («Incorrect API key provided», 401 invalid_api_key). Чат Amber жив, т.к. идёт через codex/ChatGPT-подписку (`openai/gpt-5.4` + agentRuntime codex) — а подписка НЕ даёт доступа к embeddings API. **РЕШЕНО 2026-08-14:** Павел создал новый OpenAI API-ключ (restricted: Embeddings=Request, List models=Read, project Default, sk-proj-…) и прислал в личку. Проверил ключ (эмбеддинги 200, баланс есть). Бэкап конфигов (openclaw.json.pre-amber-mem-fix-*, agents/sapphire/agent/auth-profiles.json.pre-amber-mem-fix-*), вписал ключ в openclaw.json `models.providers.openai.apiKey` И в sapphire auth-profiles `openai:default` (oauth→api_key). `openclaw gateway restart`. Проверка: `openclaw memory search` вернул реальные результаты, `memory status` → Provider openai, вектор 1536, indexed 4/4, ошибок нет. Ключ только в конфиге (chmod 600), временный /tmp стёрт, Павел удалил сообщение. Попросил Amber подтвердить memory_search у себя. **Как чинить впредь если снова протухнет openai-кред:** новый ключ на platform.openai.com → вписать в openclaw.json openai.apiKey → рестарт гейтвея → `openclaw memory status`.

См. [[amber-forwards]], [[paganel-host-access]].
