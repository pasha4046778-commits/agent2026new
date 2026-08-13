---
name: feedback-telegram-must-use-reply-tool
description: "Telegram replies require calling the reply tool — transcript output alone never reaches Pavel's chat"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6a30432a-444b-4f5e-8690-5c8b56cfa328
---

When Pavel writes in Telegram, **every visible reply MUST go through `mcp__plugin_telegram_telegram__reply`**. Plain text in my response is invisible to him — only the tool call delivers a message to Telegram.

**Why:** 2026-06-15 I wrote out a full answer to Pavel's question about VPS power-off in plain text in my turn, then said "waiting for next step" — but never called the reply tool. From Pavel's side it looked like I had gone silent. He had to prod me with "Paganel жду ответ от тебя" before I noticed. The MCP server's own instructions warn about this explicitly: *"The sender reads Telegram, not this session. Anything you want them to see must go through the reply tool — your transcript output never reaches their chat."*

**How to apply:**
- Any time I'm answering a `<channel source="plugin:telegram:telegram">` message, the answer goes through the reply tool. Full stop.
- If I have something to say to Pavel and the inbound was on Telegram, never end a turn without at least one reply tool call.
- Even short acknowledgements ("на связи", "понял") use the reply tool. React is fine for emoji-only acknowledgements via `react`, but anything textual = reply.
- Plain text in my turn is for *thinking out loud / status to myself*, not for Pavel.
