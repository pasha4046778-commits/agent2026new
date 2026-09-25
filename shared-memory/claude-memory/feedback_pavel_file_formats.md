---
name: pavel-file-formats
description: "Павлу отправлять документы PDF-ом, не .md — маркдаун у него не открывается"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 5d4cf02a-2b79-4795-98bb-dd05ba50edd1
  modified: 2026-09-24T20:12:21.771Z
---

2026-09-24 (msg 1688): отправил Павлу .md-файл вложением — «этот формат файла не открывается у меня».

**Why:** Павел читает вложения с телефона/Windows без markdown-вьювера; .md для него мёртвый формат.

**How to apply:** документы для Павла — PDF (паттерн exports/: писать HTML → `wkhtmltopdf --encoding utf-8`). ⚠️ wkhtmltopdf не рендерит эмодзи (🅰🔥 и т.п.) — заменять текстом до конвертации. Короткое (до ~15 строк) — просто текстом в сообщение. .md остаётся для внутренних рабочих файлов в workspace.
