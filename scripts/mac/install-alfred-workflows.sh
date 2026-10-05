#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Skipping Alfred workflows (macOS is required)"
  exit 0
fi

alfred_app="${ALFRED_APP_PATH:-/Applications/Alfred 5.app}"
if [[ ! -d "$alfred_app" ]]; then
  echo "Skipping Alfred workflows (Alfred 5 is not installed)"
  exit 0
fi

dotfiles_dir="${DOTFILES_DIR:-$HOME/dotfiles}"
workflow_source="$dotfiles_dir/alfred/restart-bluetooth"
workflows_dir="${ALFRED_PREFERENCES_DIR:-$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences}/workflows"
workflow_link="$workflows_dir/user.workflow.com.dotfiles.restart-bluetooth"

if [[ ! -d "$workflow_source" ]]; then
  echo "Alfred workflow source does not exist: $workflow_source" >&2
  exit 1
fi

mkdir -p "$workflows_dir"

if [[ -L "$workflow_link" && "$workflow_source" -ef "$workflow_link" ]]; then
  echo "Alfred Bluetooth workflow is already linked"
elif [[ -e "$workflow_link" || -L "$workflow_link" ]]; then
  echo "Alfred Bluetooth workflow already exists and was not changed: $workflow_link" >&2
else
  ln -s "$workflow_source" "$workflow_link"
  echo "Linked Alfred Bluetooth workflow"
fi
