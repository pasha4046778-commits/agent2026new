---
id: infra-fp-babichnail-online
type: infra
title: fp.babichnail.online — hosting
author: paganel
status: in_progress
created: 2026-04-29T07:40:00Z
updated: 2026-04-29T07:40:00Z
tags: [website, hosting, beget, frutped]
relates_to: [proj-fp-babichnail-online, infra-server-pasha-beget]
---

# fp.babichnail.online — hosting

## Что это
Хостинг приоритетного сайта https://fp.babichnail.online/ (внутренний код-имя `FrutPed`).

## Где живёт
- **Хост:** `pasha.beget.tech` (Beget).
- **Логин:** `pasha_fp` (FTP/панель Beget).
- **Каталог сайта:** `/fp.babichnail.online/` (от корня хостинг-аккаунта).
- **Пароль:** в `.env` под ключами `FRUTPED_USER` / `FRUTPED_PASS`. **Никогда не записывать значение пароля в этот файл, в git и в Telegram.**

## Связь с VPS
`pasha.beget.tech` упоминается и как shared hosting (доступ `pasha_fp`), и как VPS root (`85.198.84.47`). Уточнить у Павла, это один сервер с двумя интерфейсами или разные машины. См. `infra-server-pasha-beget`.

## Что неизвестно (open)
- Тип хостинга: shared (Beget hosting panel) или VPS-папка под nginx-vhost?
- Где исходный репозиторий сайта (GitHub? локально?). Деплой-процесс — ручной FTP или CI/CD?
- Стек: статический? CMS? bundler?
- SSL — Beget auto-issues (Let's Encrypt) или вручную?
- Есть ли staging?
- Кто ещё имеет доступ.

## Безопасность (рекомендации Paganel — open)
- **Сменить пароль `pasha_fp`** — он шёл через Telegram, считать скомпрометированным.
- При наличии — перейти на SFTP-ключ вместо пароля.
- Не коммитить чувствительные конфиги в публичный репозиторий, если код хостится на GitHub.

## Связи
- `proj-fp-babichnail-online` — проектный стержень.
- `infra-server-pasha-beget` — VPS-сосед.
