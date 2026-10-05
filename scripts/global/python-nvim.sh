#!/usr/bin/env bash
set -euo pipefail
# Reuse the provider environment; never delete an existing virtualenv.
NVIM_VENV="$HOME/venvs/nvim3"
if [[ ! -x "$NVIM_VENV/bin/python" ]]; then
  python3 -m venv "$NVIM_VENV"
fi
"$NVIM_VENV/bin/python" -m pip install --upgrade pynvim
"$NVIM_VENV/bin/python" -c 'import pynvim'
