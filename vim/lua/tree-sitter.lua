-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = { "go", "java", "python", "scala", "bash", "c", "html", "javascript", "json", "lua" },
--   highlight = { enable = true, },
-- }

-- require("plugins.nvim-ts-rainbow")
require'nvim-treesitter.config'.setup {
  ensure_installed = { "go", "java", "python", "scala", "bash", "c", "html", "javascript", "json", "lua", "vim", "toml", "yaml", "dockerfile","clojure", "rust" },
  highlight = { enable = true, },
  indent = { enable = true},
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = 10000, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}

require'treesitter-context'.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    throttle = true, -- Throttles plugin updates (may improve performance)
}

return M
