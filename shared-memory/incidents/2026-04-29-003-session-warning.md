---
id: incident-2026-04-29-003-session-warning
type: incident
title: PHP session warning on every request to fp.babichnail.online
author: paganel
status: open
created: 2026-04-29T08:05:00Z
updated: 2026-04-29T08:05:00Z
tags: [php, session, security, fp.babichnail.online]
relates_to: [infra-fp-babichnail-online, proj-fp-babichnail-online]
affects: [infra-fp-babichnail-online]
---

# PHP session warning — `config.php:24-25` запускается после старта сессии

## Severity
medium (security: настройки сессионных cookies не применяются)

## Что случилось
nginx error log `/var/log/nginx/error.log` фиксирует на КАЖДОМ запросе главной (наблюдается с 2026-04-29 06:05 UTC и далее, разные клиентские IP):

```
PHP Warning: ini_set(): Session ini settings cannot be changed when a session is active in /var/www/fp.babichnail.online/config.php on line 24
PHP Warning: session_set_cookie_params(): Session cookie parameters cannot be changed when a session is active in /var/www/fp.babichnail.online/config.php on line 25
```

## Когда обнаружено / кем
2026-04-29 ~08:05 UTC, Paganel (read-only inspection в рамках задачи «проверь сайт сам»).

## Root cause (предположительный)
В `config.php` строки 24-25 пытаются настроить ini-параметры сессии и cookie-параметры. PHP отказывает: к этому моменту сессия уже активна, потому что либо:
- какой-то include выше вызвал `session_start()`, либо
- в php.ini включён `session.auto_start = 1`, либо
- предыдущий exception/output не закрыли сессию.

Точную причину подтвердит чтение config.php (не делал, чтобы не светить креды в логах сессии).

## Импакт
- Cookie-параметры сессии (lifetime, secure, httponly, samesite) **не применяются**.
- Это значит cookies могут уходить без `Secure` (через HTTP — критично для прод-сайта), без `HttpOnly` (XSS получает доступ к session-id), без `SameSite=Strict/Lax` (CSRF становится проще).
- Размер прямого ущерба зависит от того, какие именно настройки пытались поставить и какие применяются по умолчанию из php.ini.

## Действия (Paganel)
- Зафиксировал инцидент.
- Никаких правок кода НЕ делал — Павел просил «проверь», а не «починить». Жду ОК на правку.

## Действия (требуются)
- Прочитать `config.php:1-30`, понять порядок инициализации.
- Перенести `ini_set(...)` и `session_set_cookie_params(...)` ДО любого `session_start()` (типично — в самом начале файла, перед include'ами).
- Убедиться, что `session.auto_start` в php.ini = 0 (по умолчанию обычно так).
- Проверить, что после правки nginx error log чист.

## Lesson learned
- Включить мониторинг `/var/log/nginx/error.log` хотя бы простым `grep -c "PHP Warning"` в cron — чтобы такие баги не висели неделями.
