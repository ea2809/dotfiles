local M = {}

function M.setup()
  local opts = { buffer = true, silent = true, noremap = true }

  vim.keymap.set('n', '<leader>r', ':ElinEvalCurrentTopList<CR>', opts)
  vim.keymap.set('n', '<leader>b', ':ElinEvalCurrentBuffer<CR>', opts)

  vim.keymap.set('n', '<leader>tt', ':ElinTestUnderCursor<CR>', opts)
  vim.keymap.set('n', '<leader>tf', ':ElinTestFocusedCurrentTesting<CR>', opts)

  vim.keymap.set('n', '<leader>gt', ':ElinJumpToDefinition<CR>', opts)
  vim.keymap.set('n', '<leader>gk', '<C-t>', opts)
  vim.keymap.set('n', '<leader>gs', ':tags<CR>', opts)
  vim.keymap.set('n', '<leader>gc', ':clearjumps<CR>', opts)

  vim.keymap.set('n', '<leader>de', ':ElinReferences<CR>', opts)
  vim.keymap.set('n', '<leader>do', ':ElinLookup<CR>', opts)
  vim.keymap.set('n', '<leader>i', ':ElinShowSource<CR>', opts)
end

return M
