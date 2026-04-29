---
id: incident-2026-04-29-004-gdl-password-leak
type: incident
title: gdl.php password transmitted via Telegram document
author: paganel
status: open
created: 2026-04-29T10:15:00Z
updated: 2026-04-29T10:15:00Z
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

## Действия (требуются от Павла)
- Сменить пароль `gdl.php` (правка `/var/www/videos/gdl.php` на VPS).
- Удалить сообщение msg 74 (с прикреплённым файлом) из Telegram-чата.
- Желательно: вынести пароль из кода в `.env` (через `getenv()` в gdl.php).

## Lesson learned
- `meta/writing-rules.md §8.1` уже запрещает пересылку секретов через Telegram. Этот случай — chat-history-dump, а не прямая пересылка пароля; добавить уточнение: «прежде чем шарить chat-history с агентом, проверить, что в нём нет паролей/токенов».
