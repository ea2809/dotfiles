local ok_mason, mason = pcall(require, 'mason')
local ok_mason_lsp, mason_lspconfig = pcall(require, 'mason-lspconfig')
local ok_cmp, cmp = pcall(require, 'cmp')
local M = {}
vim.g.autoformat_enabled = vim.g.autoformat_enabled == nil and 1 or vim.g.autoformat_enabled

if not (ok_mason and ok_mason_lsp and ok_cmp) then
  return
end

mason.setup()

mason_lspconfig.setup({
  automatic_enable = false,
  ensure_installed = {
    'gopls',
    'pyright',
    'rust_analyzer',
    'clojure_lsp',
    'lua_ls',
    'bashls',
    'jsonls',
    'yamlls',
    'html',
    'cssls',
    'ts_ls',
  },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
  end

  map('n', 'K', vim.lsp.buf.hover)
  map('n', '<leader>gt', vim.lsp.buf.definition)

  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup('LspDocumentHighlight' .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client:supports_method('textDocument/formatting') then
    local format_group = vim.api.nvim_create_augroup('LspFormatOnSave' .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = format_group,
      buffer = bufnr,
      callback = function()
        if vim.g.autoformat_enabled ~= 1 then
          return
        end
        vim.lsp.buf.format({
          bufnr = bufnr,
          async = false,
          filter = function(c)
            return c.name ~= 'GitHub Copilot'
          end,
        })
      end,
    })
  end
end

local function config_and_enable(name, cfg)
  local conf = vim.tbl_extend('force', {
    capabilities = capabilities,
    on_attach = on_attach,
  }, cfg or {})
  local ok_conf = pcall(vim.lsp.config, name, conf)
  if ok_conf then
    pcall(vim.lsp.enable, name)
  end
end

config_and_enable('gopls', {
  filetypes = { 'go', 'gomod' },
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        shadow = true,
        unusedparams = true,
        useany = true,
      },
      staticcheck = true,
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = true,
    },
  },
})

config_and_enable('pyright', {
  settings = {
    pyright = {
      disableOrganizeImports = false,
    },
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        autoImportCompletions = true,
      },
    },
  },
})

config_and_enable('ruff', {
  init_options = {
    settings = {
      args = {},
    },
  },
})

config_and_enable('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
    },
  },
})

config_and_enable('bashls', {})
config_and_enable('jsonls', {})
config_and_enable('yamlls', {
  filetypes = { 'yaml' },
})
config_and_enable('html', {})
config_and_enable('cssls', {})
config_and_enable('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
})

config_and_enable('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = true,
      procMacro = {
        enable = true,
      },
    },
  },
})

config_and_enable('clojure_lsp', {
  filetypes = { 'clojure', 'clojurescript', 'clojurec' },
  root_markers = { 'deps.edn', 'build.boot', 'project.clj', '.git' },
})

local ok_lspkind, lspkind = pcall(require, 'lspkind')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['UltiSnips#Anon'](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    { name = 'path' },
    { name = 'buffer' },
  }),
  formatting = ok_lspkind and {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
    }),
  } or nil,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

pcall(function()
  require('trouble').setup({})
end)

local function has_method(method, bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr or 0 })
  for _, client in ipairs(clients) do
    if client:supports_method(method) then
      return true
    end
  end
  return false
end

local function warn_missing(method)
  vim.notify(
    string.format('No LSP client in this buffer supports %s (ft=%s)', method, vim.bo.filetype),
    vim.log.levels.WARN
  )
end

function M.definition()
  if has_method('textDocument/definition') then
    return vim.lsp.buf.definition()
  end
  warn_missing('textDocument/definition')
end

function M.type_definition()
  if has_method('textDocument/typeDefinition') then
    return vim.lsp.buf.type_definition()
  end
  warn_missing('textDocument/typeDefinition')
end

function M.implementation()
  if has_method('textDocument/implementation') then
    return vim.lsp.buf.implementation()
  end
  warn_missing('textDocument/implementation')
end

function M.references()
  if has_method('textDocument/references') then
    return vim.lsp.buf.references()
  end
  warn_missing('textDocument/references')
end

function M.toggle_autoformat()
  vim.g.autoformat_enabled = vim.g.autoformat_enabled == 1 and 0 or 1
  vim.notify('Autoformat ' .. (vim.g.autoformat_enabled == 1 and 'enabled' or 'disabled'))
end

return M
