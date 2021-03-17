require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "java", "python", "scala", "bash", "c", "html", "javascript", "json", "lua" },
  highlight = { enable = true, },
}

return M
