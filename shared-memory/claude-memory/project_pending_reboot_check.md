---
name: pending-reboot-postcheck
description: "ХЕНДОФФ: после ребута 46.8.79.53 (23.09 вечер или позже) новая сессия должна прогнать пост-проверку и отчитаться Павлу в тред 248"
metadata:
  type: project
---

2026-09-23: обновление хоста по плану (тред 248) выполнено до фазы ребута. Ядро 6.8.0-142 + libc установлены, ждут перезагрузки. Павел спрошен «ребутаю сейчас или позже» (msg 1605) — если ребут состоялся, СЕССИЯ ПАГАНЕЛЯ УМЕРЛА В МОМЕНТ РЕБУТА, и эта заметка — хендофф.

ПОСТ-ПРОВЕРКА (прогнать и отчитаться в тред 248):
1. `uname -r` → должно быть 6.8.0-142; `ls /var/run/reboot-required` → должен ОТСУТСТВОВАТЬ
2. Сервисы: nginx, hab-site (3001), booking-app (3002), docker vaultwarden (healthy), fail2ban, wg-quick@wg0, openclaw-gateway (user)
3. Сайты: gudhab.com (browser UA! щит режет curl), zapis.gudhab.com, vault.babichnail.online, fp.babichnail.online (Beget, не наш — но проверить)
4. Amber: `timeout 150 openclaw agent --agent main -m "тест" --json` → model gpt-6-astra
5. Телеграм-мост жив (сам факт получения сообщения Павла = жив)
6. После успеха: удалить эту заметку и строку из MEMORY.md, отчитаться Павлу.
ЕСЛИ что-то не поднялось: journalctl -u <svc>, docker start vaultwarden, systemctl --user start openclaw-gateway.
НЕ СДЕЛАНО из плана обновления: миграция секретов openclaw.json → SecretRef (фаза 3.7) — предложить Павлу отдельно.
