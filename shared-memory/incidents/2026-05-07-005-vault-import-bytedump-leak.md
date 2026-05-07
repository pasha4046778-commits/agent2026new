---
id: incident-2026-05-07-005-vault-import-bytedump-leak
type: incident
title: 6 secrets leaked via Telegram during Vaultwarden import diagnosis
author: paganel
status: in_progress
created: 2026-05-07T18:30:00Z
updated: 2026-05-07T18:42:00Z
tags: [security, credentials, telegram, vaultwarden, leak]
relates_to: [infra-vault-babichnail-online, infra-fp-babichnail-online, infra-video-babichnail-online, infra-server-pasha-beget]
affects: [infra-fp-babichnail-online, infra-video-babichnail-online, infra-vault-babichnail-online]
---

# Vault import byte-dump leak

## Severity
high — 5 production credentials exposed in Telegram chat history (one is a non-secret identifier).

## Что случилось
2026-05-07 во время диагностики импорта `vaultwarden-import.json` в Vaultwarden Pavel выполнил PowerShell-команду, которую дал Paganel:

```powershell
[byte[]]$bytes = Get-Content -Encoding Byte -ReadCount 0 -TotalCount 3 $f
"first 3 bytes: $($bytes -join ',')"
```

Цель команды была — показать только **первые 3 байта** файла (для проверки наличия BOM). Однако в Windows PowerShell 5.x `-TotalCount` в комбинации с `-ReadCount 0` ведёт себя неожиданно и возвращает **все байты файла**. Pavel скопировал полный вывод (msg 275 в чате `Paganel+Pavel` тема `Vault`), включая байт-сериализацию всего JSON'а с 6 секретами.

## Что утекло
Из 14 записей в JSON у 6 паролей были не пустые (auto-populated скриптом из VPS):

1. **gdl.php password** (для `https://video.babichnail.online/gdl.php`)
2. **Vaultwarden admin token** (для `/admin` панели)
3. **GitHub fp-site PAT** (fine-grained, scope: Contents=RW + Metadata=R, repo `fp-site`)
4. **TipTop Pay public_id** (это ID, не секрет — но в комплекте)
5. **TipTop Pay API key** (для webhook signature)
6. **MySQL fp_user password** (DB_PASS в config.php)

## Действия (Paganel) — 2026-05-07 18:39 UTC
- ✅ shred -u inbox-файл с байт-дампом локально на Amber/Paganel host
- ✅ ротация **gdl.php password** — новый 24-char random в `/etc/gdl/password`
- ✅ ротация **Vaultwarden admin token** — новый 48-char random в `/etc/vaultwarden/admin_token`, контейнер пересоздан
- ✅ ротация **MySQL fp_user pwd** — `ALTER USER` + config.php обновлён + бэкап `config.php.bak.<TS>` сохранён в `/root/backups/fp.babichnail.online/`
- ✅ smoke-тесты: fp.babichnail.online → HTTP 200 (БД работает с новым паролем); vault.babichnail.online → /alive ok

## Действия (Pavel) — в работе
- ⏳ Удалить msg 275 из Telegram-чата ✅ (Pavel подтвердил «удалил»)
- ⏳ Удалить `vaultwarden-import.json` локально с обоих ПК-локаций ✅
- ⏳ Ротация **GitHub fp-site PAT** через github.com/settings/personal-access-tokens (revoke + новый fine-grained)
- ⏳ Ротация **TipTop Pay API key** через lk.tiptoppay.kz
- После ротаций — обновить `/root/secrets/github_token_fp_site.txt`, `/root/.git-credentials`, `config.php (TIPTOP_API_KEY)` на VPS

## Root cause
Команда диагностики, которую дал Paganel, в Windows PowerShell 5.x работает не так как ожидается — `-TotalCount 3` с `-ReadCount 0` возвращает все байты вместо первых 3. Paganel предположил Linux/PowerShell 7-семантику.

Промежуточные факторы:
- `vaultwarden-import.json` содержал auto-populated значения — нужно для **импорта в Vault**, без них смысла в скрипте не было.
- При импорте через Bitwarden JSON формат — пароли неизбежно лежат в plain text внутри файла (это E2E-encrypted только в самом Vault, файл-источник — plaintext).
- Telegram-document — стандартный канал передачи между Pavel'ом и Paganel'ом, но writing-rules §8.1 запрещает кредам идти этим путём. В этом случае Pavel не передавал креды осознанно — глитч PowerShell вытащил.

## Lesson learned
1. **Не использовать `Get-Content -Encoding Byte -TotalCount` для PowerShell 5.x** — поведение не как в PS7. Альтернативы: `[System.IO.File]::ReadAllBytes($f) | Select -First 3` или `Format-Hex $f -Count 3`.
2. **Любая команда диагностики, которая может вывести содержимое файла с секретами**, должна вначале либо ограничиваться структурой / pattern (например только `head -c 3 | od`), либо явно предупреждать, либо выполняться **только на стороне Pavel'а без копирования output'а** (например через `Out-File` в файл, `Test-Path`-проверка, без `Write-Host`).
3. **При следующей миграции секретов** — лучше не auto-populate JSON-файл, а оставить placeholder'ы, чтобы Pavel вручную копировал каждое значение в Vault UI. Это медленнее, но безопаснее (значение не лежит на диске в plaintext).
4. Добавить в `meta/writing-rules.md` явное правило: «Команды, которые могут вывести содержимое файлов с секретами, всегда тестировать на dummy-файле перед отправкой Pavel'у. Особенно различия PS5/PS7 на Windows.»

## Связи
- `infra-vault-babichnail-online` — Vaultwarden setup; 6/14 секретов были на пути миграции туда.
- `incident-2026-04-29-002-creds-via-telegram` — предыдущий инцидент с кредами через Telegram (FrutPed FTP + VPS root).
- `incident-2026-04-29-004-gdl-password-leak` — предыдущая утечка gdl-password.
- `meta/writing-rules.md §8.1` — правила работы с кредами.
