---
name: dikidi-access
description: Доступ в панель DIKIDI Business Павла для ресёрча конкурента (проект booking-app)
metadata: 
  node_type: memory
  type: reference
  originSessionId: f234e779-0f5f-4305-8fff-b02292287a1f
  modified: 2026-08-01T14:20:53.235Z
---

Для аудита DIKIDI Павел дал доступ к своему аккаунту (2026-08-01). Проект «Галерея Красоты», Актобе, company id **1272400**, тариф Базовый. Логин: номер +7 701 404 67 78 + пароль (пароль НЕ храню в памяти — Павел присылал его в чат, посоветовал сменить; спросить у него при необходимости).

Флоу входа (обычный curl с браузерным UA, бот-защита не мешает): POST number → `auth.dikidi.ru/ajax/check/auth/`; POST password → `auth.dikidi.ru/ajax/user/auth/` (вернёт token-хэш); затем `dikidi.ru/business?token=<hash>` ставит cookie-сессию. Панель владельца: `dikidi.ru/ru/owner/<section>/?company=1272400`.

Полная карта разделов и структура — research/dikidi-audit.md. Использовать для проектирования [[booking-app-project]]. Безопасность: напомнить Павлу сменить пароль DIKIDI (светился в Telegram).
