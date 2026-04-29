---
id: incident-2026-04-29-002-creds-via-telegram
type: incident
title: FrutPed + VPS credentials transmitted via Telegram (plaintext)
author: paganel
status: in_progress
created: 2026-04-29T07:40:00Z
updated: 2026-04-29T07:40:00Z
tags: [security, credentials, telegram]
relates_to: [infra-server-pasha-beget, infra-fp-babichnail-online, proj-fp-babichnail-online]
affects: [infra-server-pasha-beget, infra-fp-babichnail-online]
---

# Credentials sent through Telegram

## Severity
medium (точнее — high до ротации, после ротации — done)

## Что случилось
Павел отправил два txt-файла в Telegram (тема `FrutPed`, msg 52 и 53):
- доступ к shared hosting Beget для сайта `fp.babichnail.online` (логин `pasha_fp` + пароль + путь);
- доступ root к VPS `pasha.beget.tech / 85.198.84.47` (логин root + пароль).

Telegram-сообщения хранятся на серверах Telegram, не end-to-end-encrypted для ботовых API. Любой, кто получит доступ к этому Telegram-аккаунту или к API-сессии бота, увидит эти креды.

## Действия (Paganel)
- Перенёс значения в `/root/.openclaw/workspace/.env` под ключами `FRUTPED_*` и `VPS_*` (chmod 600, gitignored).
- Удалил локальные копии файлов в инбоксе harness'а через `shred -u`:
  - `/root/.claude/channels/telegram/inbox/1777448122686-AgADA5gAAk4pkEs.txt`
  - `/root/.claude/channels/telegram/inbox/1777448128687-AgADBJgAAk4pkEs.txt`
- В shared-memory записал только не-секретное (хост, IP, путь, имя пользователя) с пометкой "значение в .env".

## Действия (требуются от Павла)
- Удалить оба сообщения из Telegram-чата (msg 52 и 53 в группе `Paganel+Павел`, тема `FrutPed`).
- **Сменить оба пароля** (FrutPed `pasha_fp` и VPS root). Пока не сменены — считаем скомпрометированными, даже если пока нет признаков утечки.
- После смены — прислать новые пароли через защищённый канал (запароленный 1Password share / age-encrypted file / минимум — отдельная одноразовая записка, сразу удалить).

## Остаточный риск
- Telegram-серверы могли уже захэшировать/закэшировать сообщения; даже после удаления чата следы могут остаться в аналитике/бэкапах Telegram.
- Файлы прошли через harness inbox в plaintext — если был включён debug-лог, могли попасть в системные логи. Не нашёл следов в /var/log, но не исчерпывающе.

## Lesson learned (фиксируется в правила)
- Кастомное правило: **никаких паролей через Telegram**. Будущие креды — через защищённый канал. См. `meta/writing-rules.md` дополнение к §8.
- Для VPS долгосрочно — SSH-ключи, парольный root-логин выключить.
