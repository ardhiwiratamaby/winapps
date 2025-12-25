# Git Workflow - WinApps Fork

## Repository Setup ✅

**Remotes:**
- `origin` → https://github.com/ardhiwiratamaby/winapps.git (your fork)
- `upstream` → https://github.com/winapps-org/winapps.git (official repo)

**Branches:**
- `main` → tracks `upstream/main` (for syncing with official repo)
- `personal-setup` → tracks `origin/personal-setup` (your custom changes)

## Daily Workflow

### Working on Your Personal Setup

```bash
# Switch to your branch
git checkout personal-setup

# Make changes...
# Edit files, add new scripts, etc.

# Commit and push
git add .
git commit -m "Your commit message"
git push origin personal-setup
```

### Syncing with Upstream (Official Repo)

When new updates are available from winapps-org/winapps:

```bash
# Switch to main
git checkout main

# Fetch and merge updates from upstream
git pull upstream main

# Optional: Push updated main to your fork
git push origin main

# Merge updates into your personal branch
git checkout personal-setup
git merge main

# If there are conflicts, resolve them, then:
git add .
git commit -m "Merge upstream updates"
git push origin personal-setup
```

### Quick Commands

```bash
# Check current branch and status
git status
git branch -vv

# See what's different between branches
git diff main personal-setup

# View recent commits
git log --oneline -10

# Switch between branches
git checkout main              # For syncing upstream
git checkout personal-setup    # For your work
```

## Current State

**Your Changes (in `personal-setup`):**
- `winapps.conf.example` - WinApps configuration template
- `winapps-monitor.sh` - Resource monitoring script

**Commit:** `9b5e865`  
**GitHub:** https://github.com/ardhiwiratamaby/winapps/tree/personal-setup

## Best Practices

1. **Keep `main` clean** - Never commit directly to `main`, only sync from `upstream/main`
2. **Work in `personal-setup`** - All your custom changes go here
3. **Sync regularly** - Pull from `upstream/main` weekly to stay updated
4. **Merge carefully** - When merging upstream into personal-setup, check for conflicts

## Useful Git Aliases (Optional)

Add to `~/.gitconfig`:

```ini
[alias]
    sync = !git checkout main && git pull upstream main && git push origin main
    st = status -sb
    lg = log --oneline --graph --all --decorate
```

Then use: `git sync` to quickly sync with upstream!
