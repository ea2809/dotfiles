vim.g.go_fmt_command = 'goimports'
vim.g.go_list_type = 'quickfix'
vim.g.go_auto_type_info = 1
vim.g.go_auto_sameids = 1

local opts = { buffer = true, silent = true, remap = true }
vim.keymap.set('n', '<leader>b', '<Plug>(go-build)', opts)
vim.keymap.set('n', '<leader>r', '<Plug>(go-run)', opts)
vim.keymap.set('n', '<leader>tt', '<Plug>(go-test)', opts)
vim.keymap.set('n', '<leader>tf', '<Plug>(go-test-func)', opts)
vim.keymap.set('n', '<leader>gt', '<Plug>(go-def)', opts)
vim.keymap.set('n', '<leader>gk', '<Plug>(go-def-pop)', opts)
vim.keymap.set('n', '<leader>gs', '<Plug>(go-def-stack)', opts)
vim.keymap.set('n', '<leader>gc', '<Plug>(go-def-stack-clear)', opts)
vim.keymap.set('n', '<leader>de', ':GoDecls<CR>', opts)
vim.keymap.set('n', '<leader>do', ':GoDoc<CR>', opts)
vim.keymap.set('n', '<leader>i', '<Plug>(go-info)', opts)
