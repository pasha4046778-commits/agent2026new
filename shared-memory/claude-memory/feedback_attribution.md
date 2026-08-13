---
name: Don't guess message attribution between Paganel-self and co-agents
description: When Pavel shares a long prior message in Telegram, often it's my own prior-session work, not Amber/co-agent. Verify before attributing.
type: feedback
originSessionId: 27236019-13b6-4db7-8f56-a040ace1867f
---
When Pavel pastes or references a substantial prior message in a Telegram thread (especially "последнее сообщение в ветке" / "это твой ответ"), default assumption: **it's my own prior-session output**, not Amber or another co-agent. Between sessions I lose all working memory, so context Pavel restores is usually mine.

**Why:** On 2026-05-08 I twice misattributed my own prior-session reports as forwards from Amber/co-agent (Vault simplification proposal in thread 120, Beget hosting recon in thread 135). Pavel had to correct me both times. The "feedback_amber_forwards" rule (evaluate co-agent messages, raise to Pavel) made me too quick to label any unfamiliar long message as a co-agent forward.

**How to apply:**
- If a forwarded/quoted message uses *my* voice (analysis style, structured checklists, references to my actions like "я ротировал…"), it's almost certainly mine.
- If unsure, ask Pavel "это от Amber или моё?" rather than guessing.
- The amber-forwards rule still holds — but only triggers when the message is genuinely from a co-agent, not when Pavel is just restoring my lost context.
