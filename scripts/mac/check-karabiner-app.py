#!/usr/bin/env python3
"""Recognize current Karabiner installs, including installs outside Homebrew."""
import json
from pathlib import Path
import plistlib
import subprocess
import sys

info = json.loads(subprocess.check_output(["brew", "info", "--cask", "--json=v2", "karabiner-elements"], text=True))
latest = info["casks"][0]["version"]
plist = Path('/Applications/Karabiner-Elements.app/Contents/Info.plist')
if not plist.exists():
    sys.exit('Karabiner-Elements is not installed.')
with plist.open('rb') as stream:
    installed = plistlib.load(stream)['CFBundleShortVersionString']
if installed != latest:
    sys.exit(f'Karabiner-Elements update required: {installed} -> {latest}')
print(f'Karabiner-Elements {installed}: current.')
