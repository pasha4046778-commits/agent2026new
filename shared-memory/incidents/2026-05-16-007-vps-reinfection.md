---
id: incident-2026-05-16-007-vps-reinfection
type: incident
title: VPS 85.198.84.47 reinfected — same Monero malware family persisted through May 12 cleanup
author: paganel
status: closed
created: 2026-05-16T21:00:00Z
updated: 2026-05-17T19:20:00Z
closed: 2026-05-17T19:20:00Z
tags: [security, malware, cryptominer, monero, vps, reinfection, persistence]
relates_to: [incident-2026-05-12-006-vps-cryptominer-compromise, infra-server-pasha-beget]
affects: [infra-vault-babichnail-online, infra-fp-babichnail-online, infra-video-babichnail-online, infra-server-pasha4bn-beget-shared]
---

# 2026-05-16 · Incident #007 — VPS reinfection

## Severity
critical

## Что случилось
Beget dedicated VPS `85.198.84.47` (`adkutxwhda`) обнаружен **повторно заражён** той же малварью что в инциденте #006 (12 мая). На момент обнаружения cryptominer работал минимум с 13 мая 21:13 (по mtime бинарей), активный майнинг подтверждён (load avg 4.40 сустайн на 4-ядерной машине).

В отличие от инцидента #006, на этот раз появилась дополнительная защитная мера малвари: **диагностические утилиты (`ps`, `top`, `ss`) убиваются `SIGKILL`'ом при попытке запуска** — watchdog следит за процессами мониторинга. Через `/proc` процессы всё ещё видны (163 PID entries), но через standard tools — нет.

## Когда обнаружено / кем
- **2026-05-16T20:57 UTC**, обнаружил Paganel.
- Триггер: Pavel спросил «есть ли ещё доступ к pasha4bn.beget.tech». Пошёл по цепочке `ssh paganel → VPS → /root/secrets/beget-tech-account.txt → ssh pasha4bn`. На VPS обнаружил что `/root/secrets/` отсутствует целиком, sshd слушает порт 22 а не 49222, load avg подозрительно высокий, `ps aux` пустой и killed.

## Timeline

| Момент UTC | Событие |
|---|---|
| 2026-05-12 11:02 | Первичная установка rondo (инцидент #006) |
| 2026-05-12 ~16:18 | Cleanup Paganel'я: kill, chattr -ia, удаление файлов, очистка cron |
| 2026-05-12 21:56 | Reboot VPS (uptime в момент детекции — 3д 23ч) |
| 2026-05-13 21:13 | mtime новых `/bin/softirq` и `/usr/bin/softirq` (8 350 992 B) — первое известное возрождение |
| 2026-05-16 04:28 | mtime `/etc/rondo/rondo` и `/etc/cron.d/rondo` — последнее обновление persistence |
| 2026-05-16 20:57 | Детекция Paganel |
| 2026-05-16 21:04 | Pavel инициирует shutdown VPS через панель Beget |
| 2026-05-16 ~21:30 | VPS остановлен (подтверждение от Pavel) |

## Подтверждённые IoC (на момент 2026-05-16 20:57 UTC)

| Файл | Размер | mtime | Совпадение с #006 |
|---|---|---|---|
| `/etc/rondo/rondo` | 123 640 B | 2026-05-16 04:28 | ✅ точное (123 KB) |
| `/etc/cron.d/rondo` | 54 B | 2026-05-16 04:28 | ✅ точное (54 B) |
| `/bin/softirq` | 8 350 992 B | 2026-05-13 21:13 | XMRig launcher |
| `/usr/bin/softirq` | 8 350 992 B | 2026-05-13 21:13 | XMRig launcher (дубль) |
| `/usr/bin/ccphxb` | 297 288 B | 2026-05-16 04:28 | ✅ точное (297 KB) |
| `/usr/bin/tgukdb` | 470 032 B | 2026-05-16 04:28 | ✅ точное (470 KB) |

Содержательное отличие от #006: появился **anti-monitoring watchdog**, который убивает `ps`, `top`, `ss` (подтверждено через `ps aux > /tmp/ps_out.txt` → `bash: 144513 Killed`). Хеши малвари из инцидента #006 не проверены — `chattr` и `sha256sum` тоже могли быть compromised на момент детекции.

## Root cause
Гипотеза 1 (главная): **переустановка ОС после инцидента #006 не была сделана**. Cleanup от 12 мая лишь снял текущую инсталляцию малвари, не закрыв исходный канал заражения. Reboot 12 мая 21:56 UTC соответствует профильному перезапуску, не reinstall'у. Это объясняет почему:
- SSH port вернулся с 49222 на 22 (харднинг был только в running config sshd, не в `/etc/ssh/sshd_config`)
- authorized_keys содержит `paganel-2026-05-fresh-vps` (новый ключ, добавленный 12 мая после cleanup) и сохранился — значит файловая система та же
- `/root/secrets/` стёрт — возможно вычищен Pavel'ем после #006, но прочая структура `/root/` (.bashrc, .config, .npm, scripts/) уцелела

Гипотеза 2: переустановка была, но малварь зашла снова через тот же вектор. Возможно — поломанный `kimi-cli` всё ещё ставился, или скомпрометированный SSH-ключ Pavel'я использовался (но он был ротирован).

Гипотеза 3: маловероятно — kernel-level backdoor пережил reinstall (rootkit в firmware/BIOS / initramfs замена).

Чтобы различить (1) и (2/3) — нужно посмотреть на снапшот диска (Pavel должен был сделать перед shutdown) или зайти через Beget rescue mode и поднять auth.log, history root'а, время создания /root/.config/.

## Действия

- ✅ 2026-05-16 20:57-21:00 — read-only триаж: проверены `/etc/rondo`, `/usr/bin/{ccphxb,tgukdb,softirq}`, `ps`/`top` через `/proc/loadavg`, `last reboot`, состояние `/root/.ssh/authorized_keys` (чистый).
- ✅ 2026-05-16 21:00 — отправлен urgent алерт Pavel'ю через Telegram (msg 561 в thread 49).
- ✅ 2026-05-16 21:04 — Pavel дал go на shutdown.
- ✅ 2026-05-16 21:30 — Pavel остановил VPS через панель Beget.
- ⏳ Снапшот диска через Beget (если опция есть) — ждёт подтверждения Pavel'я.
- ✅ 2026-05-17 — Latvia VPS захардена, vault + video сервисы восстановлены, VIDEO_SECRET ротирован (см. `daily-2026-05-17` и `infra-server-vps-latvia`).
- ⏳ Pavel должен удалить старый VPS из Beget панели (не критично, остановлен).
- ⏳ Ротация прочих секретов (MySQL fp_user, TipTopPay, GitHub PAT) — отложено, не в активном leak-окне.

## Остаточный риск
- **Все секреты на VPS считать leaked повторно**, даже если ротированы после #006: vault-данные (E2E encrypted, master Pavel'я в плейн-тексте не лежал → низкий риск), SSH ключи (мой `paganel_vps_ed25519_2026-05` лежал в authorized_keys как pub — приватник у меня, не утёк), API-ключи в `/root/api-keys.json` если был восстановлен, MySQL `fp_user` пароль в `config.php`, gdl.php password (`fp_video_2026`), TipTopPay ключи.
- Видео уроков (11 GB) пока **только** на скомпрометированном диске и в .mov оригиналах на Google Drive Pavel'я. Локального бэкапа нет.
- Если малварь успела ходить наружу с правами root — могла подсунуть бэкдоры в Vaultwarden DB или PHP-код FrutPed-сайта. Восстановление **из backup'ов от 12 мая 18:50/18:55 UTC** (до возрождения 13 мая 21:13) считается чистым.
- Канал заражения всё ещё неизвестен — на новом VPS повторится, если ставить тот же набор.

## Рекомендации

### Pavel:
1. Сделать снапшот VPS в панели Beget до окончательного удаления — диск нужен для forensics.
2. **OS reinstall обязателен**, или вообще списать VPS с Beget (Latvia VPS лучше — другой провайдер, другой риск-профиль).
3. После hardening Latvia: **не делать** `npm install -g <не-первая-сотня-пакетов>` и `curl ... | bash` под root. Если без них никак — `--ignore-scripts`, проверка содержимого, отдельный non-root юзер.
4. Ротировать всё (task #7), пароль для pasha4bn через панель Beget (task #5).
5. На Latvia сразу: ufw + fail2ban + non-22 SSH port + key-only auth + `unattended-upgrades` + сетевой мониторинг (cron + script: алёрт при load >2.0 дольше 10 мин, или при outbound на не-whitelisted IP).

### Paganel (next session):
1. Когда придёт IP Latvia — harden (task #10).
2. Restore Vaultwarden из `/root/backups/vaultwarden-mirror/vaultwarden-2026-05-12T18-50-01Z.tar.gz` (task #11).
3. Restore LMS DB из `/root/backups/fp-db-mirror/fruitpedicure-2026-05-12T18-55-01Z.sql.gz` (task #12).
4. Видео — решить путь: rescue mode rsync vs Google Drive re-source (task #9).
5. После всего — закрыть incident #006 и #007 (move to status: closed).

## Lesson learned

1. **Cleanup ≠ remediation.** При компрометации с persistence на 4 уровнях и удалением системных утилит (chattr) единственно правильный путь — OS reinstall, не «kill + rm». Цена ленивого пути — повторение через 24-48 часов.
2. **Reinstall — это не reboot.** Нужно убедиться по факту: новые UUID ФС, новый hostname / новый kernel build / `last` показывает первый boot после reinstall date, отсутствие старых файлов вроде `/root/.config/old-stuff/`. Без проверки — «после-reinstall» состояние нельзя считать чистым.
3. **Backup-сайдкар должен пингать.** Mirror-cron на хосте Paganel молча перестал работать 13 мая (когда sshd-порт на VPS откатился на 22, а скрипт ходил на 49222). 4 дня без бэкапов мы узнали постфактум. Нужен алёрт «если новых файлов в `/root/backups/fp-db-mirror/` нет >36 часов → email/Telegram».
4. **Anti-monitoring watchdog — новая поверхность.** В следующий раз триаж должен начинаться с `cat /proc/loadavg && ls /proc | grep '^[0-9]' | wc -l && cat /proc/N/comm` — не `ps`. Если `ps` пустой при непустом `/proc` — это сигнал, не баг tooling'а.
5. **Видео-уроки = критичный ассет**. 11 GB live-production контента без offsite-бэкапа — структурная ошибка. На Latvia сделать rsync-mirror видео на хост Paganel (понадобится больше диска: запросить у провайдера расширение или отдельный backup storage).

## Связи
- `incident-2026-05-12-006-vps-cryptominer-compromise` — прямой родитель.
- `infra-server-pasha-beget` — нужно обновить заметку: VPS de-facto списан.
- Task list: #2 (этот документ), #4, #7, #8, #9, #10, #11, #12.
