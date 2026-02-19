local ok_config, ts_config = pcall(require, 'nvim-treesitter.config')
if not ok_config then
  ok_config, ts_config = pcall(require, 'nvim-treesitter.configs')
end

if ok_config then
  ts_config.setup({
    ensure_installed = 'all',
    sync_install = false,
    auto_install = true,
    ignore_install = { 'org' },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
      disable = { 'python', 'yaml' },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 10000,
    },
  })
end

pcall(function()
  require('treesitter-context').setup({
    enable = true,
    throttle = true,
  })
end)
