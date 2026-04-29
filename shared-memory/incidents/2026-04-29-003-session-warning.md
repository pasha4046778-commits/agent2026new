---
id: incident-2026-04-29-003-session-warning
type: incident
title: PHP session warning on every request to fp.babichnail.online
author: paganel
status: done
created: 2026-04-29T08:05:00Z
updated: 2026-04-29T08:55:00Z
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

## Действия (Paganel) — выполнено 2026-04-29 08:54 UTC
- Прочитал `config.php`. Подтвердил root cause: 14 entry-скриптов делают `session_start()` на строке 2, ПОТОМ `require config.php` — поэтому `ini_set/session_set_cookie_params` в config.php (строки 24-25) запускались уже после старта сессии и не работали.
- Пробил php-defaults: `session.gc_maxlifetime=1440`, `session.cookie_lifetime=0`, `session.auto_start=0`. Текущее реальное поведение сайта = эти дефолты, **а не** 3600s, которые автор хотел поставить.
- Решение выбрано **F1: убрать сломанный блок**, потому что Павел сказал «функционал должен остаться прежним». Реальное поведение и так = PHP defaults; перенос `ini_set` в рабочую позицию (F2) изменил бы функционал (расширил бы сессию с 24 мин до 1ч).
- Сделал backup `/root/backups/fp.babichnail.online/config.php.bak.2026-04-29_08-54-17` (вне git, на VPS).
- Заменил блок в `config.php` строки 23-25 на explanatory комментарий (в файле теперь 4608 байт vs 4249 до). Проверил `php -l` — синтаксис ок.
- Comment в файле объясняет, как при желании реально применить 1h-lifetime: добавить в pool.d:
  ```
  php_admin_value[session.gc_maxlifetime] = 3600
  php_admin_value[session.cookie_lifetime] = 3600
  ```
- ownership/perms сохранены (`644 www-data:www-data`).

## Верификация
- Прогнал 4 запроса (3 на главную + 1 на login) → все HTTP 200.
- Подсчёт session-warning'ов в `/var/log/nginx/error.log` за сегодня:
  - до 08:54 UTC: **19**
  - после 08:54 UTC: **0**
- Регрессий не обнаружено.

## Lesson learned
- При написании session-related кода: ini_set + session_set_cookie_params должны идти ДО session_start. Идиоматично — в config.php в самом верху, и сам же config.php потом вызывает session_start. Тогда entry-скриптам остаётся только `require_once 'config.php'`, без отдельного `session_start()`.
- Полезный мониторинг: `grep -c "PHP Warning" /var/log/nginx/error.log` в cron / heartbeat (доб. в todo).
