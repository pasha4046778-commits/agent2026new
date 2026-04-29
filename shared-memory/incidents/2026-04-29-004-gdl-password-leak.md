---
id: incident-2026-04-29-004-gdl-password-leak
type: incident
title: gdl.php password transmitted via Telegram document
author: paganel
status: mitigated
created: 2026-04-29T10:15:00Z
updated: 2026-04-29T13:45:00Z
tags: [security, credentials, telegram, gdl, video]
relates_to: [infra-video-babichnail-online, proj-fp-babichnail-online]
affects: [infra-video-babichnail-online]
---

# gdl.php password transmitted via Telegram

## Severity
low — пароль защищает страницу для скачивания видео с Google Drive / YouTube, не админка и не платёжка. Утечка ограниченная.

## Что случилось
2026-04-29 Павел отправил Paganel'ю файл `инфо правки фрутпед.txt` с историей переписки сайта (msg 74). В тексте — пароль `fp_video_2026` к `https://video.babichnail.online/gdl.php`. Файл прошёл через Telegram сервера; даже после удаления может остаться в их кэше/бэкапах.

## Дополнительно
В том же файле упоминался старый root-пароль VPS — но он на момент передачи уже был обесценен (SSH key-only, см. `incident-2026-04-29-002-creds-via-telegram`).

## Root cause
- Пароль gdl.php hardcoded в коде `/var/www/videos/gdl.php` (вшит в файл).
- При обсуждении правок страница «инфа по сайту» была собрана с включением chat-history → пароли перетянулись.

## Действия (Paganel)
- Прочитал файл, перенёс non-secret-контекст в shared-memory hub (`infra/video-babichnail-online.md`, `infra/fp-babichnail-online.md`, `projects/fp-babichnail-online.md`).
- Plaintext файл `инфо правки фрутпед.txt` `shred -u` в harness inbox.
- Зафиксировал инцидент.

## Действия (требуются от Павла) — выполнено 2026-04-29 13:45 UTC
- ✅ Удалить сообщение msg 74 — Pavel удалил.
- ✅ Сменить пароль `gdl.php` — Paganel сделал ротацию + рефакторинг:
  - Сгенерирован новый случайный пароль (22 символа из openssl rand).
  - Сохранён в `/etc/gdl/password` (root:www-data, mode 640) — читаемый PHP-FPM, недоступен миру.
  - `gdl.php` отрефакторен: `define('DL_PASSWORD', ...file_get_contents('/etc/gdl/password')...)`. Старая константа `'fp_video_2026'` ушла из кода.
  - Backup старого `gdl.php`: `/root/backups/fp.babichnail.online/gdl.php.bak.2026-04-29_13-44-00`.
  - Smoke: `https://video.babichnail.online/gdl.php` → HTTP 200 (логин-форма).
- Чтобы Pavel прочитал новый пароль: `ssh -p 49222 root@85.198.84.47 cat /etc/gdl/password`.
- В будущем чтобы сменить: `ssh -p 49222 root@85.198.84.47 "tr -d '\n' > /etc/gdl/password"` + ввести новый и Ctrl-D, без правок кода.

## Lesson learned
- `meta/writing-rules.md §8.1` уже запрещает пересылку секретов через Telegram. Этот случай — chat-history-dump, а не прямая пересылка пароля; добавить уточнение: «прежде чем шарить chat-history с агентом, проверить, что в нём нет паролей/токенов».
