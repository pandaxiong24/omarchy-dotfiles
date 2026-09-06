# Omarchy dotfiles

User customizations for an [Omarchy](https://omarchy.org/) (Arch + Hyprland) install.

Layout mirrors `$HOME`: `config/` → `~/.config/`, `local/` → `~/.local/`.

| Repo path | Restores to | What it is |
|---|---|---|
| `config/hypr/` | `~/.config/hypr/` | Hyprland config (monitors, bindings, look & feel) |
| `config/omarchy/` | `~/.config/omarchy/` | Omarchy shell layout, plugins, extensions, branding |
| `local/bin/omarchy-monitor-settings` | `~/.local/bin/` | GTK4 monitor settings GUI (position, refresh rate) |
| `local/bin/omarchy-hyprland-window-move-monitor` | `~/.local/bin/` | Windows-style move-window-to-monitor helper |
| `local/share/applications/Monitor Settings.desktop` | `~/.local/share/applications/` | Launcher entry for the settings app |

## Backup (this machine → repo)

```bash
~/.dotfiles/save.sh            # sync + commit, or "save.sh <message>"
```

```bash
git clone https://github.com/<you>/<repo> ~/.dotfiles
~/.dotfiles/install.sh          # add --dry-run to preview
```

Then, if the Omarchy shell was customized: `omarchy restart shell`.

### Auto-backup hook

`post-update.hook` runs `save.sh` (and pushes) after every `omarchy update`.
Reinstall it after a fresh restore:

```bash
omarchy hook install post-update ~/.dotfiles/post-update.hook
```


## GitHub remote setup (once)

```bash
gh auth login
gh repo create <name> --private --source="$HOME/.dotfiles" --push
```
