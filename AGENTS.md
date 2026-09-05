# Dotfiles agent guidance

## SpaceFN / Karabiner

- Read `karabiner/README.md` before changing keyboard mappings.
- The generator is the external PyPI package `karabiner-configurator`, not a
  script in this repository. Install with `python3 -m pip install karabiner-configurator`
  only if missing. Apply with `karabiner-configurator ~/dotfiles/karabiner/`.
- Edit `karabiner/config.default.json` and the applicable ignored host override.
  Host lists replace default lists; changing only the default may do nothing locally.
- Compile and compare with the live `VIM` rules before applying: the generator
  replaces that profile's entire rule list. Preserve unrelated live customizations.
- Keep modifier-specific rules before wildcard rules. Use a `complex` group for
  modified `from` mappings: the automatic Hyper generator does not support their
  `mandatory`/`optional` arguments in a top-level `from`.
- Hold Space to use the layer; Space+X opens Codex and Space+Shift+X opens Claude.
  On this Mac, Codex is `/Applications/ChatGPT.app` (`com.openai.codex`), so keep
  the `ChatGPT` launch target unless the installed app changes.
- Do not run the full `install.sh` for a shortcut change.

## tmux clipboard

- macOS copies go through `tmux/copy-if-not-empty.sh`, including mouse copy and
  prefix Ctrl+C. Empty input must not invoke `pbcopy`; preserve nonempty input
  byte-for-byte, including whitespace and trailing newlines.
- Keep macOS `set-clipboard off` while using this helper, so OSC 52 cannot bypass
  the guard. Other platforms retain their existing clipboard configuration.
- Test with a stub clipboard command, never by overwriting the user's clipboard.
  Reload only `tmux/tmux-osx.conf` for these changes; do not restart the user's server.
- Run `python3 -m unittest discover -s tests -v` for regression checks.

## Working tree

Preserve pre-existing untracked and ignored files. Do not commit, push, or run
the full installer unless requested.
