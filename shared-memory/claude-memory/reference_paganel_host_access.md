---
name: reference-paganel-host-access
description: "SSH access details for 46.8.79.53 (Paganel + Amber + offsite backup mirrors) — non-default port 51842, ufw + fail2ban active"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 836f4cd2-57d7-445a-ae3d-52b6f8787b19
---

Host: `46.8.79.53` (hostname `server`, the box where Paganel and Amber processes run, also the offsite mirror for Vaultwarden and FrutPed DB backups).

**⚠️ I (Claude Code) run ON this host as root.** The SSH details below are for **Pavel's** access from his PC. For me, "checking the Paganel host" = running local commands directly (`uptime`, `systemctl`, etc.), NOT `ssh paganel ...`. If I find myself trying to SSH to 46.8.79.53, I'm SSHing to myself — stop and run the command locally. Confirmed 2026-06-14 after a reboot when I wasted time fighting key auth before Pavel pointed it out.

**SSH access (effective 2026-05-17 ~10:30 UTC):**
- **Only port: `51842`**. Port 22 closed both at ssh.socket override and in ufw. Confirmed by Pavel from PC Termius.
- ssh.socket override at `/etc/systemd/system/ssh.socket.d/override.conf` — only listens on 51842 IPv4 + IPv6.
- Auth: root password (19 chars, Pavel rotated 2026-05-16). `authorized_keys` still empty — Pavel chose to keep password auth instead of switching to key auth.
- Connect: `ssh -p 51842 root@46.8.79.53`

**Defensive posture set 2026-05-17:**
- `ufw` active and enabled-on-boot, default deny in / allow out. Allowed: 22 (temp), 51842, 80, 443, **51820/udp (WireGuard)**.
- `fail2ban` active with `banaction = ufw` in `/etc/fail2ban/jail.local` (not the default `iptables-multiport` — that one silently fails on Ubuntu 24.04's nftables backend). Bans show up as `REJECT IN` rules at top of `ufw status numbered`. Settings: 5 fails → 1h ban, 10min window. Pavel's IP `95.57.171.254` is in `ignoreip` so he can't accidentally lock himself out.
- `rkhunter` installed but no periodic scan in cron yet.

**WireGuard server lives on this box too:** `wg0` interface (10.0.0.1/24), listening UDP 51820. Pavel's personal VPN for bypassing Russian RKN blocks when needed. 3 peers configured (10.0.0.2/3/4 = Pavel's devices). NOT an agent-related service — Pavel uses it directly. **Don't touch the WG config or break inbound UDP 51820** without asking.

**Why this matters:** before hardening, the box had 2 637 SSH brute-force attempts in 24h from 100 unique IPs on port 22 with `PasswordAuthentication yes` + `PermitRootLogin yes` and no fail2ban / firewall. Pavel chose to keep password auth (just-rotated 19-char pw) but moved port and added the defenses listed above. See also [[reference-vps-pasha-beget]] (now-decommissioned compromised host) and incident-007.

**If the SSH port is later changed again,** update this memory and also `shared-memory/infra/` notes if the box gets one there.
