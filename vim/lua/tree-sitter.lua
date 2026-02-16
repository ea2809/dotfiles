local ok_config, ts_config = pcall(require, 'nvim-treesitter.config')
if not ok_config then
  ok_config, ts_config = pcall(require, 'nvim-treesitter.configs')
end

if ok_config then
  ts_config.setup({
    ensure_installed = { 'go', 'java', 'python', 'scala', 'bash', 'c', 'html', 'javascript', 'json', 'lua', 'vim', 'toml', 'yaml', 'dockerfile', 'clojure', 'rust' },
    highlight = { enable = true },
    indent = { enable = true },
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
