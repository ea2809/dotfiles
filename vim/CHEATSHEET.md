# Neovim Cheatsheet

Leader: `<Space>`

## Core

- Save: `<C-s>` / `<leader>w`
- Quit: `<leader>q`
- Save + quit: `<leader>wq`
- Force quit: `<leader>Q`
- Insert -> Normal: `jk`
- Clear search highlight: `<leader>t`

## Files / Search (fzf)

- Find files: `<C-p>`
- Live grep: `<leader>fg`
- Buffers list (fzf): `<leader>fb`
- Help tags: `<leader>fh`
- Resume last fzf: `<leader>fr`

## Buffers

- Next: `<leader>bn`
- Previous: `<leader>bp`
- Alternate buffer: `<leader>bt` or `<leader><tab>`
- List buffers: `<leader>bb`
- Delete buffer: `<leader>bd`

## LSP Navigation

- Hover docs: `K`
- Definition: `<leader>gd` (or `<leader>gt`)
- Type definition: `<leader>gy`
- Implementation: `<leader>gi`
- References: `<leader>gr`
- Rename symbol: `<leader>rn`

## LSP Actions / Diagnostics

- Code action: `<leader>ca`
- Apply code action: `<leader>cf`
- Quickfix action: `<leader>qf`
- Diagnostics panel: `<leader>cd`
- Next diagnostic: `<leader>cj`
- Previous diagnostic: `<leader>ck`
- Diagnostics -> quickfix: `<leader>cp`
- Document symbols: `<leader>co`
- Workspace symbols: `<leader>cs`

## Debugging (DAP)

- Continue/start: `<leader>dc`
- Step over: `<leader>dn`
- Step into: `<leader>di`
- Step out: `<leader>du`
- Toggle breakpoint: `<leader>db`
- Conditional breakpoint: `<leader>dB`
- REPL: `<leader>dr`
- Run last: `<leader>dl`
- Terminate: `<leader>dt`
- Toggle DAP UI: `<leader>dx`

## Git (Fugitive)

- Status: `<leader>gst`
- Blame: `<leader>gb`
- Push: `<leader>gp`
- Push force-with-lease: `<leader>gpf`

## Language Quick Notes

- Java: open a Java file to auto-start `jdtls` + Java debug/test integration
- Go: build/run/test mappings from `vim-go` remain (`<leader>b`, `<leader>r`, `<leader>tt`)
- Clojure: Elin mappings remain for eval/test/navigation

## Health / Maintenance

- LSP info: `:LspInfo`
- LSP health: `:checkhealth vim.lsp`
- DAP health: `:checkhealth dap`
- Mason UI: `:Mason`
- Plugins install/update: `:PlugInstall` / `:PlugUpdate`

## Project Local (`.nvim.lua`)

- Init local config: `:ProjectLocalInit`
- Edit local config: `:ProjectLocalEdit`
- Trust current project: `:ProjectLocalTrust`
- Untrust current project: `:ProjectLocalUntrust`
- Show trust/status: `:ProjectLocalStatus`

## Config Structure

- Base bootstrap: `vim/vimrc`
- Global maps: `vim/lua/keymaps.lua`
- Global autocmds: `vim/lua/autocmds.lua`
- Language local config: `vim/after/ftplugin/*.lua`
