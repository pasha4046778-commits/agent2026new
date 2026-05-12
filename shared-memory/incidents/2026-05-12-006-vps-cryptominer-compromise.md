---
id: incident-2026-05-12-006-vps-cryptominer-compromise
type: incident
title: VPS 85.198.84.47 compromised — Monero cryptominer with immutable-file persistence
author: paganel
status: in_progress
created: 2026-05-12T16:25:00Z
updated: 2026-05-12T16:25:00Z
severity: critical
tags: [security, malware, cryptominer, monero, vps, persistence, rootkit-indicators]
relates_to: [infra-server-pasha-beget, incident-2026-05-07-005-vault-import-bytedump-leak]
---

# 2026-05-12 · Incident #006 — VPS cryptominer compromise

## Что произошло
Beget dedicated VPS `85.198.84.47` (`adkutxwhda`) был скомпрометирован — установлен **Monero (XMR) cryptominer** с многоуровневой persistence. Майнинг шёл активно ~5 часов прежде чем обнаружено.

## Timeline
- **2026-05-12 11:02:28 UTC** — первый запуск `sudo ./rondo react.x86_64` из `/usr/lib/lib/` (initial install)
- **2026-05-12 13:35:00 UTC** — повторный запуск (re-install / reinforcement)
- **2026-05-12 13:35:01 UTC** — cron RELOAD подхватил `/etc/cron.d/rondo`
- **2026-05-12 14:00-15:30** — Pavel заметил аномалии, начал диагностику
- **2026-05-12 16:00-16:18** — детекция, kill, cleanup (Paganel)

## Технические детали

### Идентифицированные компоненты
| Файл | Размер | Назначение |
|---|---|---|
| `/etc/rondo/rondo` | 123 KB | главный launcher (ELF, статически слинкованный, stripped) |
| `/usr/bin/softirq` (или `/bin/softirq`) | n/a | XMRig-cryptominer (имя замаскировано под ksoftirqd kernel thread) |
| `/usr/bin/ccphxb` | 297 KB | вспомогательный (curl-производное) |
| `/usr/bin/tgukdb` | 470 KB | вспомогательный (curl-производное) |
| `/usr/lib/systemd/bhcgredq` | n/a | supervisor / watchdog (delete-self-after-load) |
| `/etc/cron.d/rondo` | 54 B | persistence #1: `@reboot root /etc/rondo/rondo react.x86_64.persisted` |
| `/etc/init.d/rondo` | 338 B | persistence #2: SysV init script |
| `/etc/crontab` (modified) | — | persistence #3: добавлена строка `@reboot ...rondo...` |
| `/var/spool/cron/crontabs/root` (modified) | — | persistence #4: то же |

### SHA256 хеши malware
- rondo: `21d420be3b6542b58b1f154161bbf0e3442c5dd38789fb673770edac6c92a51a`
- ccphxb: `ea43dc3e72aadac2d8820181a79af1ce94f0f713f7aef81f5ef0ed5881d1f5eb`
- tgukdb: `b8f8a975cf3e7908e076de79814aa448c6086aacfc08165be04ce65665e08e39`

### IoCs (Indicators of Compromise)
- IP майнинг-пула: `45.125.66.100:444` + `45.125.66.100:8443` (primary)
- Failover пул: `45.94.31.89:443`
- Reverse-DNS первого: `welstanbapparel.com` (фейк-домен под видом apparel-бизнеса)
- Worker username в команде XMRig: `react`
- Worker password: `3cthDeQ5`
- Алгоритм: RandomX (`--randomx-1gb-pages`)
- Файл-флаги: `i` (immutable) + `a` (append-only) на всех персистентных файлах
- **Удаление `/usr/bin/chattr` из системы** — анти-cleanup мера
- self-delete EXE после запуска (`(deleted)` в `/proc/<pid>/exe`)
- 4 параллельных канала persistence (cron.d, init.d, crontab, /var/spool/cron)

### Что не подтверждено (но не исключено)
- Kernel-rootkit (модуль ядра скрывающий процессы)
- Бэкдор в `sshd` или PAM (через подмену бинарей)
- LD_PRELOAD-замены в системных бинарях
- Второ-стадийный watchdog, который проснётся позже

## Канал заражения (гипотезы, неподтверждено)
1. **Скомпрометированный npm/pip пакет** при `npm install -g kimi-cli` или `pip install kimi-cli` — типосквоттинг
2. **Скомпрометированный install.sh** при `curl -fsSL https://openclaw.ai/install.sh | bash`
3. Утечка SSH-ключа `pavel-personal` (его публичная часть в /root/.ssh/authorized_keys на VPS; приватная — на ПК Pavel'а)

История bash подтверждает: установка `kimi-cli` через npm+pip + `openclaw onboard` происходила примерно во временное окно с 10:30 до 11:02 — то есть **точно перед первым запуском rondo**. Сильное подозрение на supply-chain attack через `kimi-cli`.

## Удар
- Майнер бежал с правами root ~5 часов → **все секреты на VPS считать скомпрометированными**
- Список секретов для ротации:
  - `pavel-personal` SSH-ключ (твой)
  - `paganel_vps_ed25519` (мой)
  - `/root/api-keys.json` — 17 API-ключей (OpenAI, Anthropic, GitHub, Brave, Unsplash, DeepL, YouTube, Leonardo, Figma, ProductHunt, StackOverflow, Kimi, Moonshot, NewsAPI, Twitter, GooglePageSpeed, ExchangeRate)
  - `/root/secrets/beget-tech-account.txt` (Beget pasha4bn FTP/SSH)
  - `/root/secrets/github_token_fp_site.txt` (GitHub PAT)
  - MySQL `fp_user` пароль (`config.php` на FrutPed-stack)
  - TipTopPay API ключи (в `config.php` на pasha shared)
  - Vaultwarden master (если хранился где-то в plaintext)
  - Telegram bot token
  - Admin-пароли (FrutPed admin / hab-site admin)
- CPU/электричество: на 5 часов 100% загрузка для майнинга XMR

## Что сделано в рамках инцидента
1. ✅ Триаж и идентификация (read-only)
2. ✅ Kill процессов (`kill -9` через `pgrep -x`)
3. ✅ `chattr -ia` (с использованием `scp`-нутого `chattr` с этой машины, т.к. локальный был удалён)
4. ✅ Удаление файлов малвари
5. ✅ Очистка cron-persistence (`sed -i '/rondo/d'`)
6. ✅ Восстановление `/usr/bin/chattr`
7. ✅ Подтверждение: процессы не возрождаются, исходящих на mining pool нет
8. ⏳ **OS reinstall + redeploy** — рекомендовано, ждёт решения Pavel

## Lessons learned
1. **Не делать `npm install -g <package>` под root** для неофициальных/типосквоттинговых пакетов. Всегда смотреть `npm info <package>` (publisher, downloads) перед install. Использовать `--ignore-scripts` для проверки.
2. **`curl ... | bash`-инсталляция требует доверия к URL+TLS+содержимому**. Лучше `curl -o /tmp/install.sh && cat /tmp/install.sh | head -100 && bash /tmp/install.sh`.
3. **Регулярные snapshot'ы / immutable backup** должны быть на отдельном сервере, чтобы malware не дотянулся.
4. **Мониторинг**: настроить алерт на высокий CPU >80% дольше 10 минут (легко через `node_exporter + alertmanager` или просто `cron + sendmail` script).
5. **Защитить ключевые файлы (chattr +i на authorized_keys / sshd_config / config.php)** — но только если есть резервный канал доступа на случай restore.
6. **Регулярная ротация API-ключей** (раз в 3-6 месяцев).
7. **Не хранить много секретов на одном сервере** (даже если только root читает) — лучше Vaultwarden / external secret manager.

## Related
- `incident-2026-05-07-005-vault-import-bytedump-leak` — предыдущий инцидент утечки секретов через PowerShell диагностику
- `infra-server-pasha-beget` — основная инфра-заметка по этому VPS
