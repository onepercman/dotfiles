# dotfiles

Personal macOS development environment using **GNU Stow** for dotfiles management.

## Stack

- 🍺 **Homebrew** — package management
- 🐚 **zsh + zinit + Starship** — shell, plugins, prompt
- 🔧 **mise** — polyglot runtime manager (node, bun, pnpm, python, uv, rust, go)
- 📦 **pnpm + bun** — JS package managers
- ✏️ **Neovim (LazyVim)** — primary code editor
- 👻 **Ghostty** — GPU-accelerated terminal emulator, default terminal
- 🖥️ **herdr** — the agent multiplexer that lives in your terminal
- 🪟 **Tili** — i3-like tiling window manager, written in Rust
- 🐙 **GitHub CLI** — GitHub workflows from the terminal
- 🐙 **lazygit** — terminal UI for git, standalone or inside Neovim (`<leader>gg`)
- 📁 **superfile** — terminal file manager (Nord theme)
- 📊 **btop** — resource monitor (CPU, memory, disks, network, processes)

## Quick Start

**Fresh machine** (installs Xcode CLI tools, clones repo, runs sync):
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/itsdezen/dotfiles/main/sync.sh) bootstrap
```

**Existing machine:**
```bash
git clone https://github.com/itsdezen/dotfiles ~/Developer/dotfiles
cd ~/Developer/dotfiles && ./sync.sh
```

`sync.sh` is idempotent — safe to re-run anytime to sync/update.

## Scripts

| Script | Description |
|--------|-------------|
| `./sync.sh` | Sync everything: Homebrew, dotfiles, runtimes, nvim plugins |
| `./sync.sh bootstrap` | Fresh machine setup: Xcode CLI tools → clone → sync |
| `./sync.sh uninstall` | Remove all dotfiles symlinks and zinit |

## Stow Packages

| Package | Symlinks to |
|---------|-------------|
| `zsh` | `~/.zshrc`, `~/.zshenv`, `~/.zprofile` |
| `nvim` | `~/.config/nvim/` |
| `tili` | `~/.config/tili/` |
| `starship` | `~/.config/starship.toml` |
| `ghostty` | `~/.config/ghostty/` |
| `mise` | `~/.config/mise/config.toml` |
| `git` | `~/.gitconfig` |
| `superfile` | `~/.config/superfile/` |
| `btop` | `~/.config/btop/` |
| `lazygit` | `~/.config/lazygit/` |
| `claude` | `~/.claude/settings.json` |
| `herdr` | `~/.config/herdr/config.toml` |
| `opencode` | `~/.config/opencode/opencode.jsonc`, `~/.config/opencode/tui.json` |
| `codex` | `~/.codex/config.toml` |

## Highlights

- **Unified theme** — Nord across nvim, Ghostty, btop, lazygit, starship, superfile, herdr, and opencode for a consistent look everywhere
- **Keyboard-driven window management** — Tili tiling window manager with built-in floating-window centering
- **Terminal stack** — herdr shows Claude session state on agent pane borders
- **Idempotent sync** — one script (`sync.sh`) installs Homebrew packages, symlinks every Stow package, and provisions mise runtimes
- **Auto-update prompt** — new shells periodically check the repo for remote commits and offer to pull + sync (Enter to accept); `dotfiles-update --force` checks on demand
- **Runtimes pinned centrally** — mise versions live in this repo instead of per-project

For exact settings of any given tool, read its config directly under the matching Stow package (e.g. `nvim/.config/nvim/init.lua`) — that file is always the source of truth.

## Troubleshooting

**Stow conflict** — `sync.sh` resolves automatically (dotfiles win, no backups).

```bash
./sync.sh        # re-run to fix
```
