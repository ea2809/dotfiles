local ok, mason_tool_installer = pcall(require, 'mason-tool-installer')
if not ok then
  return
end

mason_tool_installer.setup({
  ensure_installed = {
    -- LSP
    'gopls',
    'pyright',
    'rust-analyzer',
    'clojure-lsp',
    'jdtls',
    'lua-language-server',
    'typescript-language-server',
    'bash-language-server',
    'html-lsp',
    'css-lsp',
    'json-lsp',
    'yaml-language-server',

    -- Formatters / linters
    'ruff',
    'isort',
    'golangci-lint',
    'cljfmt',
    'clj-kondo',

    -- Debugging
    'debugpy',
    'delve',
    'codelldb',
    'java-debug-adapter',
    'java-test',
  },
  auto_update = false,
  run_on_start = true,
  start_delay = 3000,
  debounce_hours = 24,
})
