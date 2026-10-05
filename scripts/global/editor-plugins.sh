#!/usr/bin/env bash
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PLUG_MANAGER="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [[ ! -f "$PLUG_MANAGER" ]]; then
  curl -fLo "$PLUG_MANAGER" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
export DOTFILES_DIR PLUG_MANAGER
# Load declarations alone so missing plugins cannot break their own installation.
# vim-plug remains the updater; locally edited plugin checkouts are left alone.
nvim --headless -u NONE \
  -c 'execute "source " . fnameescape($PLUG_MANAGER)' \
  -c 'execute "source " . fnameescape($DOTFILES_DIR . "/vim/plug.vim")' \
  -c 'lua local clean = {}; for name, plug in pairs(vim.g.plugs) do local edits = ""; if vim.fn.isdirectory(plug.dir .. "/.git") == 1 then edits = vim.fn.system({"git", "-C", plug.dir, "status", "--porcelain", "--untracked-files=no"}); if vim.v.shell_error ~= 0 then error("Cannot inspect " .. name) end end; if edits == "" then table.insert(clean, name) else print("Preserving locally edited plugin: " .. name) end end; if #clean > 0 then vim.cmd("PlugUpdate --sync " .. table.concat(clean, " ")) end' \
  -c 'lua for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do if line:match("^x ") then print(line); vim.cmd("cquit 1") end end' \
  -c 'lua for name, plug in pairs(vim.g.plugs) do if vim.fn.isdirectory(plug.dir) == 0 then print("Missing plugin: " .. name); vim.cmd("cquit 1") end end' \
  -c 'qa!'
