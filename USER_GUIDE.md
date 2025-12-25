# WinApps Setup Guide - Ubuntu 24.04

Complete guide for running Windows applications seamlessly on Ubuntu using Docker.

## Quick Start

**What's Installed:**
- Windows 11 VM in Docker (4GB RAM, 4 CPU cores, 64GB disk)
- WinApps Launcher (system tray icon)
- Resource Monitor tool
- VNC web access
- Auto-start on login

## Daily Usage

### System Tray Launcher
Look for the **WinApps icon** in your top panel → Click to:
- Launch Windows applications
- Start/Stop/Restart/Pause VM
- Open full Windows desktop

### Quick Access Apps
Press `Super` key, then type:
- **"Resource"** → View CPU/RAM usage
- **"VNC"** → Open Windows in browser (http://127.0.0.1:8006)
- **"Windows"** → Full desktop session

### VM Control

**Via System Tray:** Click WinApps icon → Select action

**Via Terminal:**
```bash
# Start VM
docker compose --file ~/.config/winapps/compose.yaml start

# Stop VM  
docker compose --file ~/.config/winapps/compose.yaml stop

# Check status
docker ps | grep WinApps
```

## Installing Windows Applications

1. Open VNC: http://127.0.0.1:8006
2. Install apps in Windows (Office, Photoshop, etc.)
3. Re-run WinApps installer to add shortcuts:
   ```bash
   bash <(curl https://raw.githubusercontent.com/winapps-org/winapps/main/setup.sh)
   ```
4. New apps appear in launcher automatically!

## Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/winapps/winapps.conf` | Main settings (username, password, backend) |
| `~/.config/winapps/compose.yaml` | VM resources (RAM, CPU, disk) |

**Default Credentials:**
- Username: `MyWindowsUser`
- Password: `MyWindowsPassword`

## Changing VM Resources

Edit `~/.config/winapps/compose.yaml`:
```yaml
RAM_SIZE: "8G"      # Change from 4G to 8G
CPU_CORES: "8"      # Change from 4 to 8
DISK_SIZE: "128G"   # Change from 64G to 128G
```

Then recreate VM:
```bash
docker compose --file ~/.config/winapps/compose.yaml down
docker compose --file ~/.config/winapps/compose.yaml up -d
```

## Git Workflow

**Branches:**
- `main` → syncs with official winapps-org/winapps
- `personal-setup` → your custom changes

**Daily work:**
```bash
git checkout personal-setup
# Make changes...
git add .
git commit -m "Description"
git push origin personal-setup
```

**Sync with upstream:**
```bash
git checkout main
git pull upstream main
git checkout personal-setup
git merge main
```

## Key Locations

```
~/.config/winapps/
├── winapps.conf          # WinApps configuration
└── compose.yaml          # Docker VM settings

~/.local/bin/
├── winapps               # WinApps command
└── winapps-monitor.sh    # Resource monitor

~/.local/share/applications/
├── winapps-launcher.desktop
├── winapps-monitor.desktop
└── Windows*.desktop      # Windows app shortcuts
```

## Troubleshooting

**System tray icon not visible?**
```bash
# Install AppIndicator extension
sudo apt install gnome-shell-extension-manager
# Then install "AppIndicator" from Extensions Manager

# Or restart launcher
systemctl --user restart winapps-launcher
```

**Apps won't launch?**
```bash
# Check VM status
docker ps | grep WinApps

# Start if stopped
docker compose --file ~/.config/winapps/compose.yaml start

# Check logs
tail -f ~/.local/share/winapps/winapps.log
```

**VM running slow?**
- Increase RAM/CPU in `compose.yaml` (see above)
- Restart VM after changes

## Uninstall

**WinApps only:**
```bash
bash <(curl https://raw.githubusercontent.com/winapps-org/winapps/main/setup.sh)
# Select "Uninstall"
```

**Everything (including VM):**
```bash
docker compose --file ~/.config/winapps/compose.yaml down --volumes --rmi all
rm -rf ~/.config/winapps ~/.local/bin/winapps*
```

## Useful Commands

```bash
# Resource usage
docker stats WinApps

# VM logs
docker logs WinApps

# Restart launcher
systemctl --user restart winapps-launcher

# List installed Windows apps
ls ~/.local/share/applications/Windows*
```

## Performance Tips

1. **Enable hardware acceleration** - Already enabled via KVM in Docker
2. **Allocate more resources** - Edit `compose.yaml` if you have spare RAM/CPU
3. **Use SSD** - Docker volumes benefit from SSD performance
4. **Pause when idle** - Via system tray to free resources

## Links

- Your Fork: https://github.com/ardhiwiratamaby/winapps
- Official Repo: https://github.com/winapps-org/winapps
- Launcher Repo: https://github.com/winapps-org/winapps-launcher
- VNC Access: http://127.0.0.1:8006

---

**Need Help?** Check `GIT_WORKFLOW.md` for detailed git instructions.
