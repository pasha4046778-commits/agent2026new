---
name: wireguard-vpn
description: "WireGuard VPN на Paganel-хосте (46.8.79.53) — сервер, слоты, как добавить клиента"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f234e779-0f5f-4305-8fff-b02292287a1f
  modified: 2026-08-08T08:21:34.100Z
---

WireGuard VPN на VPS 46.8.79.53, служба `wg-quick@wg0` (active+enabled), конфиг `/etc/wireguard/wg0.conf`, интерфейс wg0 = 10.0.0.1/24, порт 51820/UDP (открыт в ufw). Полный туннель (клиенты AllowedIPs 0.0.0.0/0, NAT через eth0 в PostUp). Сервер pubkey: `siuExfVRD0htv/hVgvisYp8dbEgnbrJ6oShL+UtV/yg=`. Endpoint для клиентов: `46.8.79.53:51820`.

**2026-08-08 расширено до 5 слотов** (по просьбе Павла — 2 ПК + 3 телефона): 10.0.0.2 ПК Павла (его ключ, конфиг только у него — приватника нет на сервере), 10.0.0.3 ПК-2, 10.0.0.4/.5/.6 Телефон-1/2/3. Конфиги .3–.6 сгенерированы мной (приватники были в scratchpad/wg/, отправлены Павлу текстом+QR). Бэкап старого конфига: /etc/wireguard/wg0.conf.bak-*. Установлен `qrencode` для QR.

**Добавить клиента:** `wg genkey|wg pubkey` → добавить `[Peer]` (PublicKey + AllowedIPs 10.0.0.X/32) в wg0.conf → применить БЕЗ разрыва: `wg syncconf wg0 <(wg-quick strip wg0)` (PATH нужен /usr/sbin). Клиентский конфиг: [Interface] PrivateKey/Address 10.0.0.X/24/DNS + [Peer] server pubkey/Endpoint/AllowedIPs 0.0.0.0/0/PersistentKeepalive 25. Проверка подключения: `wg show wg0 latest-handshakes` (свежий handshake = на связи). Один конфиг = одно устройство. См. [[paganel-host-access]].
