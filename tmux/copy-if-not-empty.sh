#!/bin/sh
# Buffer stdin without stripping trailing newlines. Never clear the clipboard
# when a click or an empty tmux buffer supplies no selection.
set -eu

selection_file=$(mktemp "${TMPDIR:-/tmp}/tmux-copy.XXXXXXXX")
trap 'rm -f "$selection_file"' EXIT
trap 'exit 1' HUP INT TERM

cat > "$selection_file"
if [ -s "$selection_file" ]; then
  pbcopy < "$selection_file"
fi
