# Neovim Power Config

This is the quick guide for your setup in `vim/vimrc` + Lua modules.

## TL;DR

- Leader key: `<Space>`
- Plugin manager: `vim-plug`
- LSP: native Neovim (`vim.lsp.config` / `vim.lsp.enable`)
- Completion: `nvim-cmp` + `UltiSnips`
- Diagnostics list: `trouble.nvim`
- Debugging: `nvim-dap` + `dap-ui` + Mason adapters
- Java: dedicated `nvim-jdtls` + Java debug/test bundles

## Main Files

- `vim/vimrc`: base options and plugin bootstrap
- `vim/plug.vim`: plugin list
- `vim/lua/keymaps.lua`: global keymaps
- `vim/lua/autocmds.lua`: global autocmds
- `vim/lua/lsp-setup.lua`: LSP + completion + diagnostics
- `vim/lua/mason-tools-setup.lua`: auto-install/maintain Mason tools
- `vim/lua/dap-setup.lua`: DAP setup + debug keymaps
- `vim/lua/project-local.lua`: trusted project-local config loader
- `vim/ftplugin/java.lua`: Java LSP/DAP integration (`jdtls`)
- `vim/after/ftplugin/*.lua`: language-local config (Go/Python/Clojure/etc.)

## Install / Update

1. `:PlugInstall`
2. `:Mason`
3. `:checkhealth vim.lsp`
4. `:checkhealth dap`

Useful maintenance:

- `:PlugUpdate`
- `:PlugClean`
- `:Mason`

## Project Local Config (`.nvim.lua`)

Project-local config is loaded only for trusted directories.

Commands:

- `:ProjectLocalInit` create `.nvim.lua` from template
- `:ProjectLocalEdit` open current project `.nvim.lua`
- `:ProjectLocalTrust` trust current project and load `.nvim.lua`
- `:ProjectLocalUntrust` remove trust
- `:ProjectLocalStatus` show status

Notes:

- Trusted directories are stored in `stdpath('state')/trusted-projects.txt`
- Local config is loaded on `VimEnter` and when cwd changes (`DirChanged`)

Example:

```lua
vim.g.autoformat_enabled = 0
vim.opt_local.colorcolumn = '100'
```

## LSP (Language Server)

### Core LSP keymaps

- `K`: Hover docs
- `<leader>gt`: Go to definition
- `<leader>gd`: Go to definition
- `<leader>gy`: Go to type definition
- `<leader>gi`: Go to implementation
- `<leader>gr`: Find references
- `<leader>rn`: Rename symbol
- `<leader>rr`: Rename symbol (alias)
- `<leader>ca`: Code actions
- `<leader>cf`: Apply code action
- `<leader>qf`: Apply quickfix code action

### Diagnostics

- `<leader>cd`: Open diagnostics panel (`Trouble`)
- `<leader>cj`: Next diagnostic
- `<leader>ck`: Previous diagnostic
- `<leader>cp`: Send diagnostics to quickfix list
- `<leader>co`: Document symbols (`fzf-lua`)
- `<leader>cs`: Workspace symbols (`fzf-lua`)

### Installed/managed language servers

- Go: `gopls`
- Python: `pyright`, `ruff`
- Rust: `rust-analyzer`
- Clojure: `clojure-lsp`
- Java: `jdtls` (via `ftplugin/java.lua`)
- Extra: `lua_ls`, `bashls`, `jsonls`, `yamlls`, `html`, `cssls`, `ts_ls`

## Debugging (DAP)

### Debug keymaps

- `<leader>dc`: Continue/start
- `<leader>dn`: Step over
- `<leader>di`: Step into
- `<leader>du`: Step out
- `<leader>db`: Toggle breakpoint
- `<leader>dB`: Conditional breakpoint
- `<leader>dr`: Open REPL
- `<leader>dl`: Run last
- `<leader>dt`: Terminate
- `<leader>dx`: Toggle DAP UI

### Debug adapters/tooling

Managed by Mason + setup:

- Python: `debugpy`
- Go: `delve`
- Rust/C/C++: `codelldb`
- Java: `java-debug-adapter`, `java-test`

## Language-Specific Notes

### Java

- Auto-attaches `jdtls` per project root (`gradlew`, `mvnw`, `pom.xml`, etc.)
- Uses dedicated workspace under Neovim data dir
- Loads Java debug/test bundles automatically if installed

### Go

- LSP: `gopls` with staticcheck and common analyses
- Existing `vim-go` mappings remain active (build/run/test/etc.)

### Python

- `pyright` for analysis/completion
- `ruff` server for lint/fix workflow
- `debugpy` for debugging

### Rust

- `rust-analyzer` with clippy-on-save and proc macro support
- `codelldb` launch/test debug templates configured

### Clojure

- `clojure-lsp` enabled
- Existing Elin mappings for eval/test/navigation are preserved

## Search / Files / Buffers

- `<C-p>`: Find files (`fzf-lua`)
- `<leader>fg`: Live grep
- `<leader>fb`: Buffers
- `<leader>fh`: Help tags
- `<leader>fr`: Resume last fzf

Buffers:

- `<leader>bn`: Next buffer
- `<leader>bp`: Previous buffer
- `<leader>bt` or `<leader><tab>`: Alternate buffer
- `<leader>bb`: List buffers
- `<leader>bd` or `<leader>dd`: Delete buffer

## Editing / Utility Shortcuts

- `<C-s>`, `<leader>w`, `<leader>ww`, `<leader>fs`: Save
- `jk` (insert mode): Escape
- `<leader>t`: Clear search highlight
- `<space>L`: Format current buffer (`Neoformat`)
- `<leader>fm`: Open `vifm` here
- `<leader>ff`: Open `vifm` current file dir
- `<leader>wt`: Toggle workspace sessions
- `<leader>fv`: Toggle Vista symbols

Git:

- `<leader>gst`: Git status
- `<leader>gb`: Git blame
- `<leader>gp`: Git push
- `<leader>gpf`: Git push force-with-lease

## Troubleshooting

### Check active clients

- `:LspInfo`
- `:checkhealth vim.lsp`

### Check DAP health

- `:checkhealth dap`

### Mason tool state

- `:Mason`

## Design Principles of This Setup

- Keep modules isolated (LSP, tools, DAP, Java)
- Prefer explicit enable/config over magic defaults
- Keep keymaps stable while upgrading internals
- Let Mason maintain tools, but avoid forced auto-upgrades for stability
