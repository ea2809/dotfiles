#!/usr/bin/env python3
"""Compile with the real generator before allowing its full-profile replacement."""
import json
from pathlib import Path
import sys

from karabiner_configurator.config import load_config
from karabiner_configurator import karabiner

root = Path(__file__).resolve().parents[2]
config = load_config(str(root / "karabiner"))
generated = karabiner.main(config["spacefn_definitions"], config["normal_definitions"])["rules"]
live = json.loads((Path.home() / ".config/karabiner/karabiner.json").read_text())
profile = next((p for p in live["profiles"] if p["name"] == config.get("profile_name", "VIM")), None)
if profile is None:
    sys.exit("Create the VIM profile in Karabiner-Elements, then rerun the keyboard stage.")
rules = profile.get("complex_modifications", {}).get("rules", [])
# Do not erase manual rules, including edited rules sharing a generated description.
unexpected = [r for r in rules if r not in generated]
if unexpected:
    sys.exit("Keyboard apply blocked to preserve live customizations: " + ", ".join(r.get("description", "unnamed") for r in unexpected))
if "--exact" in sys.argv and rules != generated:
    sys.exit("Live keyboard rules differ from generated rules; run the keyboard stage.")
print(f"Karabiner: {len(generated)} generated rules; {len(rules)} live; no unrepresented customizations.")
