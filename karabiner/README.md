# SpaceFN

Hold Space, wait for the layer to activate, then press the shortcut key. Release
Space to leave the layer; tapping Space by itself still types a space. The current
`VIM` profile activates after 100 ms (a profile setting, not a generator default).

| While holding Space | Action |
| --- | --- |
| X | Codex |
| Shift+X | Claude |
| I | WezTerm |
| A | Alfred |
| S / C | Safari / Chrome |
| O / P | Obsidian / PyCharm |
| T | Slack by default; Teams on HackedBook |
| H / J / K / L | Left / down / up / right |
| B | Literal space |

Codex is currently installed as `/Applications/ChatGPT.app`, with bundle ID
`com.openai.codex`. The X rule deliberately still launches `ChatGPT`.

## Install and run the generator

The generator is published on PyPI as `karabiner-configurator`. There is no local
`spacefn.py` to run or edit. If the command is not installed:

```sh
python3 -m pip install karabiner-configurator
```

Always pass this repository's configuration directory; omitting it uses the
package's own directory, not these dotfiles.

```sh
# Preview the keyboard layout without touching active Karabiner settings.
karabiner-configurator ~/dotfiles/karabiner/ --html-only

# Apply the mappings and generate karabiner/index.html.
karabiner-configurator ~/dotfiles/karabiner/ -v

# Apply without generating the HTML layout.
karabiner-configurator ~/dotfiles/karabiner/ --no-html -v
```

The `VIM` profile must already exist in Karabiner-Elements and be selected to use
these mappings. The generator backs up `~/.config/karabiner/karabiner.json` as
`karabiner.json_<n>.back.json`, replaces the target profile's rules, and preserves
its other settings and other profiles. Compare generated rules against live rules
before applying so manual changes are not lost. Karabiner reloads the saved file.

## Editing mappings safely

`config.default.json` is version-controlled. Optional `config.<hostname>.json`
files override it and are ignored by Git. HackedBook uses `config.HackedBook.json`.
Objects are merged, but lists such as `spacefn_definitions` are replaced in full:
update both lists when a shortcut should exist in the default and on this Mac.

Place Shift+X before X because X accepts optional modifiers and would otherwise
match first. Define modifier-specific mappings inside a `complex` group, even
with one entry. The installed generator automatically creates Hyper alternatives
for simple definitions, but that conversion does not accept `mandatory` or
`optional` on their top-level `from`; complex groups are excluded from it. This
also preserves Hyper+X for Codex instead of introducing a duplicate for Claude.

```json
{
  "name": "shift x to Claude",
  "complex": [
    {
      "from": {"keycode": "x", "mandatory": ["shift"]},
      "shell": {"program": "Claude"}
    }
  ]
}
```

See Karabiner's [modifier reference](https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/from/modifiers/)
and [first-match rule ordering](https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-evaluation-priority/).
