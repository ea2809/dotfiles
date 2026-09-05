# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository for macOS system configuration, including shell (Zsh), terminal (WezTerm), text editor (Neovim), terminal multiplexer (tmux), and various development tools.

## Installation & Setup

**Initial setup:**
```bash
./install.sh
```

The install script:
- Installs Homebrew and packages from Brewfile
- Creates symlinks for all configuration files to their expected locations in $HOME
- Configures vim-plug for Neovim
- Sets up ZSH with Antidote plugin manager
- Configures tmux, vifm, bat, and git
- Generates Karabiner configuration for vim-style keybindings

**Updating Neovim plugins:**
```bash
nupdate
# Alias for: nvim +PlugClean +PlugInstall +PlugUpdate +CocUpdate +TSUpdate +qal
```

## Repository Structure

### Core Configuration Areas

**ZSH (`zsh/`):**
- `zshrc` - Main ZSH configuration, uses Antidote (replacement for Antigen)
- `alias.zsh` - Shell aliases
- `functions.zsh` - Custom shell functions
- `p10k.zsh` - Powerlevel10k prompt configuration
- `bgnotify.zsh`, `z_bell.zsh` - Notification utilities

**Neovim (`vim/`):**
- `vimrc` - Main vim configuration (sourced by init.vim)
- `init.vim` - Neovim entrypoint (delegates to vimrc)
- `plug.vim` - Plugin definitions using vim-plug
- `coc-settings.json` - CoC (Conquer of Completion) LSP settings
- Python3 virtualenv expected at `~/venvs/nvim3/`

**Tmux (`tmux/`):**
- `tmux.conf` - Main tmux configuration
- `tmux-osx.conf` - macOS-specific tmux settings

**Other Tools:**
- `bat/config` - Bat (cat replacement) configuration
- `vifm/vifmrc` - Vifm file manager configuration
- `karabiner/` - Keyboard remapping (SpaceFN layout via Python script)
- `zsh/wezterm.lua` - WezTerm terminal emulator config (symlinked to ~/.wezterm.lua)

### Scripts

**Global scripts (`scripts/global/`):**
- `git.sh` - Configures git with diff-so-fancy pager and color settings

**Platform-specific scripts:**
- `scripts/mac/` - macOS-specific utilities
- `scripts/ubuntu/` - Ubuntu-specific utilities

## Key Configuration Details

**Shell Environment:**
- Uses Antidote for ZSH plugin management (migrated from Antigen)
- Vi-mode enabled in ZSH with 'jk' mapping to escape insert mode
- FZF configured with fd for file finding, bat for previews
- Custom keybindings: Ctrl+R (history search), Ctrl+X+a (expand alias)

**Editor Setup:**
- Neovim uses vim-plug for plugins and CoC for LSP
- Leader key is space
- Python3 host program path: `~/venvs/nvim3/bin/python`
- Configuration sources from `~/dotfiles/vim/` directory

**Path Management:**
- Go binaries: `$HOME/go/bin`
- Custom scripts: `~/dotfiles/bin`
- Homebrew: `/opt/homebrew/bin` and `/opt/homebrew/sbin`

**Tool Aliases:**
- `ls` → `lsd` (modern ls)
- `cat` → `bat` (syntax highlighting)
- `ctags` → brew-installed ctags (not system version)
- `nupdate` - Update all Neovim plugins
- Poetry shortcuts: `pr`, `prb`, `prr`, `prp`

## Modifying Configuration Files

Configuration files live in `~/dotfiles/` and are symlinked to their standard locations:

- Edit dotfiles in place: `~/dotfiles/vim/vimrc`, `~/dotfiles/zsh/zshrc`, etc.
- Use aliases for quick access: `dvimrc`, `dzshrc`, `dtmux`, `daliases`
- After editing, changes take effect immediately (or source ~/.zshrc for shell changes)

**Adding new symlinks:**
Use the `checklink` function pattern from `install.sh`:
```bash
checklink ~/dotfiles/path/to/source ~/.target/location
```

## Development Tools Stack

**Languages & Runtimes:**
- Python: pyenv, poetry
- Node.js: nvm, yarn
- Go: GOPATH at `~/go`
- Java: maven, sbt
- R: installed via brew

**Terminal Tools:**
- fzf, fd, ripgrep (ag), bat, lsd
- tmux with reattach-to-user-namespace
- diff-so-fancy for git diffs
- lazygit for git TUI
- vifm for file management

**Editor/IDE:**
- Neovim with CoC LSP
- IdeaVim (configuration at `vim/ideavimrc`)

## Special Considerations

**Karabiner:**
- Configuration is JSON-based and stored separately from code
- Default config: `karabiner/config.default.json` (version controlled)
- Host-specific configs: `karabiner/config.<hostname>.json` (gitignored)
- External PyPI package: `karabiner-configurator` (no local `spacefn.py`)
- Install if missing: `python3 -m pip install karabiner-configurator`
- Run to apply changes: `karabiner-configurator ~/dotfiles/karabiner/`
- Read `AGENTS.md` and `karabiner/README.md` for host overrides and safe application
- Creates automatic backups before modifying Karabiner config
- Auto-generates `index.html` with visual keyboard layout showing all mappings
- Supports variable substitution (`$variable_name`) for reusable config blocks
- Command-line options: `--html-only` (visualization only), `--no-html` (skip HTML)
- See `karabiner/README.md` for detailed usage and library documentation

**GPG & SSH:**
- GPG configured with pinentry-mac
- SSH and GPG keys must be manually configured (not in repo)

**Platform Detection:**
Uses `uname` to detect macOS vs Linux and adjust accordingly (see zshrc, alias.zsh for examples).
