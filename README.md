# Dotfiles

Personal macOS shell, editor, terminal, and keyboard configuration.

## Install or update a Mac

Clone at `~/dotfiles`: the editor and tmux configuration use that location.
The default GitHub branch is **master**.

```sh
git clone git@github.com:ea2809/dotfiles.git ~/dotfiles
cd ~/dotfiles
git switch master
git pull --ff-only origin master
bash install.sh
```

For an existing checkout, start at `cd ~/dotfiles`. Review local changes before
switching branches or pulling. The installer uses this checkout's Brewfile and
scripts, regardless of the directory from which it is invoked.

The default run updates Homebrew, installs/upgrades Brewfile dependencies, links
configuration, updates the Neovim Python provider, editor plugins, and shell plugins, applies
keyboard rules, and verifies the result. Existing conflicting files and broken
symlinks receive unique `.backup` files beside the destination. Repeating the
installer reuses correct links and the Python environment. It does not uninstall
unlisted packages, migrate database majors, generate keys, or restart tmux.

Homebrew and the Karabiner package installer can request your administrator
password. Karabiner installs outside Homebrew are recognized when their version
matches the current Homebrew cask. On a new Mac, open Karabiner-Elements, grant
its requested macOS permissions, and create/select the `VIM` profile. Then rerun
`bash install.sh keyboard`. Read [the keyboard guide](karabiner/README.md) for
host overrides and shortcuts. The keyboard stage compiles with the real
`karabiner-configurator` package (in a dedicated virtualenv when missing) and stops before replacing unrepresented live
customizations; reconcile those with the source configuration first.

Run stages independently to resume after a failure:

```sh
bash install.sh packages
bash install.sh config
bash install.sh python
bash install.sh plugins
bash install.sh shell
bash install.sh keyboard
bash install.sh check
```

The plugin stage uses vim-plug and preserves plugin checkouts with tracked local edits,
printing their names. Untracked generated files are retained. Skipped checkouts need manual review before they can be
updated. Headless plugin installation loads the plugin declarations alone so a
missing plugin does not prevent its own installation. The shell stage uses the
Antidote declarations in `zsh/zshrc`, migrates the old forgit cache branch to
`main`, and updates bundles. Invalid compleat/fizsh declarations were corrected;
fizsh is a standalone shell, and the existing highlighting/history plugins
provide those features.

The Brewfile uses the current ICU alias and `yt-dlp`, and explicitly includes fzf
and universal-ctags. PostgreSQL remains on the declared `postgresql@14` major;
changing database majors requires a separate data migration. SSH/GPG credentials
and application sign-ins are per-laptop setup.

After configuration changes, start a new shell. For an existing tmux server,
reload only the macOS configuration:

```sh
tmux source-file ~/dotfiles/tmux/tmux-osx.conf
```

## Verify changes

```sh
bash -n install.sh scripts/global/*.sh
zsh -n zsh/zshrc
python3 -m unittest discover -s tests -v
bash install.sh check
```

Tests use temporary files, a stub clipboard, and a separate tmux server.
Ubuntu has a separate legacy script at `scripts/ubuntu/install.sh`.
