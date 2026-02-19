vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.smartindent = true
vim.opt_local.cinwords = 'if,elif,else,for,while,try,except,finally,def,class,with'
vim.opt_local.commentstring = '# %s'

vim.cmd('setlocal indentkeys-=<:>')
vim.cmd('setlocal indentkeys-=:')

vim.g.neoformat_enabled_python = { 'autopep8', 'yapf' }
vim.g.neoformat_run_all_formatters = 1
