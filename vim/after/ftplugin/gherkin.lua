vim.opt_local.commentstring = '# %s'
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

vim.keymap.set('x', '<leader>=', ':EasyAlign*<Bar><Enter>', { buffer = true, silent = true, noremap = true })
vim.keymap.set('n', '<leader>=', 'V}k<leader>=', { buffer = true, silent = true, noremap = true })
vim.keymap.set('n', '<leader>gt', ':call behave#goto_step_definition()<CR>', { buffer = true, silent = true, noremap = true })
