---
name: reference-hetzner-vpn
description: "Hetzner VPN server 2.29.51.239 (Хельсинки, CPX/1GB, Ubuntu 26.04) — WireGuard для Павла, настроен 2026-10-06; SSH порт 51842 по ключу hetzner_vpn_ed25519"
metadata:
  node_type: memory
  type: reference
  originSessionId: 579b2a18-035e-4829-9be3-87c818147376
  modified: 2026-10-06T20:33:52.858Z
---

**Hetzner Cloud сервер Павла под VPN** (вторая точка выхода к GOhost-wg0): `2.29.51.239` (IPv6 2a01:4f9:c015:93e7::/64), ubuntu-1gb-hel1-1, **Хельсинки** (Павел выбрал вместо Германии), Ubuntu 26.04.1 LTS. Настроен 2026-10-06.

**Мой доступ**: `ssh hetzner-vpn` (алиас в ~/.ssh/config: порт 51842, ключ `~/.ssh/hetzner_vpn_ed25519`). Пароль root знает только Павел — он ТРЕБУЕТ оставить парольный вход включённым (не отключать!).

**SSH**: только порт 51842 (socket-activation, override в /etc/systemd/system/ssh.socket.d/). Порт 22 закрыт.
**ufw**: deny in; открыты 51842/tcp, 51820/udp.
**fail2ban**: banaction=ufw (nftables-урок GOhost), sshd 5 fail → 1h ban; ignoreip: 95.57.171.254 (Павел) + 46.8.79.53 (GOhost — чтобы я не самобанился).

**WireGuard** (`/etc/wireguard/wg0.conf`): 10.9.0.1/24, порт 51820, NAT через eth0 (PostUp iptables MASQUERADE), ip_forward в /etc/sysctl.d/99-wireguard.conf, автозапуск wg-quick@wg0.
Клиенты (ключи в /etc/wireguard/clients/ на сервере; копии конфигов+QR на GOhost `/root/secrets/hetzner-wg/`):
- pavel-phone → 10.9.0.2
- pavel-pc → 10.9.0.3
- pavel-reserve → 10.9.0.4
DNS клиентов 1.1.1.1; Endpoint 2.29.51.239:51820.

Добавить клиента: по образцу [[reference-wireguard-vpn]] (генерация ключей + peer в wg0.conf + `wg syncconf wg0 <(wg-quick strip wg0)`).

Related: [[reference-paganel-host-access]] (первый VPN wg0 на GOhost), [[reference-wireguard-vpn]].
