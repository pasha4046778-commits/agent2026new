---
id: infra-video-babichnail-online
type: infra
title: video.babichnail.online — защищённый видеохост
author: paganel
status: in_progress
created: 2026-04-29T10:15:00Z
updated: 2026-04-29T10:15:00Z
tags: [video, hosting, nginx, ssl, ffmpeg]
relates_to: [infra-fp-babichnail-online, infra-server-pasha-beget, proj-fp-babichnail-online]
---

# video.babichnail.online — видеохост для FrutPed

## Что это
Отдельный поддомен на том же VPS (`pasha.beget.tech / 85.198.84.47`), который раздаёт видеоуроки FrutPed-курса. Видео доступны только залогиненным ученикам — через токен-проверку.

## TLS
- Origin **имеет** Let's Encrypt сертификат (в отличие от `fp.`): `/etc/letsencrypt/live/video.babichnail.online/`.
- nginx vhost `/etc/nginx/sites-enabled/video.babichnail.online` слушает 443 ssl, 80 → 301 на https.
- certbot.timer enabled — авто-renew.

## Token-protected раздача видео
- nginx vhost: location для `\.(mp4|mov|webm|mkv|m4v)$` → rewrite на `/check-access.php?file=$1&$args last;`.
- `check-access.php` (`/var/www/videos/check-access.php`) проверяет `?token=...&expires=...`, валидирует, и если ок — отдаёт файл (видимо `X-Accel-Redirect` или прямой stream).
- Прямой доступ к любым `.php` файлам (кроме check-access.php) → `deny all`.
- Токены живут 4 часа (по логам прошлой сессии).
- Range requests включены — поддержка перемотки.

## Хранение видео
- Каталог: `/var/www/videos/` (на VPS).
- Текущий размер на 2026-04-29: ~31 GB (13 готовых .mp4 + 10 исходников .mov).
- Готовые файлы: `urok_01..09.mp4`, `mozoli_04.mp4`, `onih_plenki2.mp4`, `vostonovl_uglov3.mp4`, `ustanovka_plenok1.0.mp4` и др.
- **Disk pressure:** на VPS / занято 52% (40G из 77G). Видео — основной едок. Нужен план: либо чистка исходников .mov после конвертации, либо переезд на больший диск/object storage.

## Авто-конвертация (inotify + ffmpeg)
- systemd unit: `video-convert.service` (`active running`).
- Триггер: inotify на `/var/www/videos/` — новые файлы автоматически конвертируются в H.264 MP4 (CRF 22, ~3-4 Mbps).
- Поддерживаемые форматы на вход: `.mov`, `.mkv`, `.avi`, `.mp4` (включая HEVC/H.265 и VP9).
- Выходной файл: то же имя + `.mp4`.
- Загрузка CPU: 100% одного ядра во время конвертации (4 ядра доступно — остальное свободно).
- Параллельные конвертации не запускаются (сериализуется через очередь).

## gdl.php — загрузчик с Google Drive / YouTube
- URL: `https://video.babichnail.online/gdl.php`
- Назначение: Pavel вводит ссылку Google Drive / YouTube → VPS скачивает напрямую через `gdown` / `yt-dlp`. Без участия LLM-токенов и через VPN/прокси не идёт.
- Защита: hardcoded password в коде (`fp_video_2026`).
- Логи: `/var/www/videos/download.log`.
- После успешной загрузки → авто-запуск конвертации (через inotify).
- ⚠️ **Пароль gdl.php прошёл через Telegram-документ 2026-04-29** — формально утёк, см. `incident-2026-04-29-004-gdl-password-leak`. Задача на ротацию.

## TipTop Pay (платёжная система — НЕ здесь, на fp.)
Платежи живут на `fp.babichnail.online`, но webhook URL для TipTop Pay вебхука: `https://fp.babichnail.online/api/confirm-payment.php`. См. `infra-fp-babichnail-online`.

## Open issues
- Disk pressure (видео занимают много места, .mov originals можно подчистить).
- gdl.php password в plain-в-коде (а не в `.env`); надо хотя бы загрузить значение через env.
- Auto-monitoring: нет алёрта при падении `video-convert.service` или ошибке конвертации.

## Связи
- `infra-server-pasha-beget` — VPS.
- `infra-fp-babichnail-online` — основной сайт.
- `proj-fp-babichnail-online` — приоритетный проект.
- `incident-2026-04-29-004-gdl-password-leak` — пароль gdl.php утёк через Telegram.
