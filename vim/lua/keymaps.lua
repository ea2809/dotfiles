local map = vim.keymap.set

-- Better move in text
map({ 'n', 'v', 'o' }, '<Up>', 'gk')
map({ 'n', 'v', 'o' }, '<Down>', 'gj')
map({ 'n', 'v', 'o' }, 'k', 'gk')
map({ 'n', 'v', 'o' }, 'j', 'gj')

map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  end
  return '<C-g>u<CR>'
end, { expr = true, silent = true })

map('v', '<Down>', ":m '>+1<CR>gv=gv")
map('v', '<Up>', ":m '<-2<CR>gv=gv")

map('n', '<leader>t', ':nohls<CR>')
map('n', '<Leader>fm', ':Vifm . <CR>')
map('n', '<Leader>ff', ':Vifm "expand(\'%:r\')"<CR>')

map('v', '//', 'y/\\V<C-r>=escape(@",\'/\\\')<CR><CR>')
map('v', 'agg', 'y:Agg \"<C-r>\"\"<CR>')
map('v', 'ag', 'y:Ag \"<C-r>\"\"<CR>')
map('v', 'rg', 'y:Rg \"<C-r>\"\"<CR>')
map('v', 'fzf', 'y:FZF \"<C-r>\"\"<CR>')

map('n', '<leader>rf', ':%s/')
map('t', '<space>jk', '<C-\\><C-N>')

map('n', '<C-J>', '<C-W><C-J>')
map('n', '<C-K>', '<C-W><C-K>')
map('n', '<C-L>', '<C-W><C-L>')
map('n', '<C-H>', '<C-W><C-H>')

map('n', '<C-s>', ':w<CR>')
map('n', '<leader>w', ':w<CR>')
map('n', '<leader>ww', ':w<CR>')
map('i', 'jk', '<ESC>')
map('n', '<leader>fs', ':w<CR>')

map('n', '<leader>bn', ':bn<CR>')
map('i', '<leader>bn', '<Esc>:bn<CR>')
map('n', '<leader>bt', ':b#<CR>')
map('i', '<leader>bt', '<Esc>:b#<CR>')
map('n', '<leader><tab>', ':b#<CR>')
map('i', '<leader><tab>', '<Esc>:b#<CR>')
map('n', '<Right>', ':bn<CR>')
map('n', '<Left>', ':bp<CR>')
map('n', '<leader>bb', ':ls<CR>')
map('i', '<leader>bb', '<Esc>:ls<CR>')
map('n', '<leader>bp', ':bp<CR>')
map('i', '<leader>bp', '<Esc>:bp<CR>')
map('n', '<leader>dd', ':bd<CR>')
map('n', '<leader>bd', ':bd<CR>')
map('i', '<leader>bd', '<Esc>:bd<CR>')
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>qq', ':q<CR>')
map('n', '<leader>wq', ':wq<CR>')
map('n', '<leader>Q', ':q!<CR>')

map('n', '<leader>p', ':ProseMode<CR>')

map('n', '<leader>ee', ':cnext<CR>')
map('n', '<leader>ek', ':cprevious<CR>')
map('n', '<leader>ec', ':cclose<CR>')
map('n', '<leader>eo', ':copen<CR>')
map('n', '<leader>cc', ':cc<CR>')

map('n', '<leader>o', ':! open . <CR><CR>')

map('n', '<C-p>', "<cmd>lua require('fzf-lua').files()<cr>")
map('n', '<leader>fg', "<cmd>lua require('fzf-lua').live_grep()<cr>")
map('n', '<leader>fb', "<cmd>lua require('fzf-lua').buffers()<cr>")
map('n', '<leader>fh', "<cmd>lua require('fzf-lua').helptags()<cr>")
map('n', '<leader>fr', "<cmd>lua require('fzf-lua').resume()<cr>")

map('n', '<space>L', ':Neoformat<CR>')
map({ 'x', 'n' }, 'ga', '<Plug>(EasyAlign)', { remap = true })

map('n', '<leader>wt', ':ToggleWorkspace<CR>')

map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { silent = true })
map('n', '<leader>cf', '<cmd>lua vim.lsp.buf.code_action({ apply = true })<CR>', { silent = true })
map('n', '<leader>qf', "<cmd>lua vim.lsp.buf.code_action({ context = { only = { 'quickfix' } }, apply = true })<CR>", { silent = true })
map('n', '<leader>gd', "<cmd>lua require('lsp-setup').definition()<CR>", { silent = true })
map('n', '<leader>gy', "<cmd>lua require('lsp-setup').type_definition()<CR>", { silent = true })
map('n', '<leader>gi', "<cmd>lua require('lsp-setup').implementation()<CR>", { silent = true })
map('n', '<leader>gr', "<cmd>lua require('lsp-setup').references()<CR>", { silent = true })
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { silent = true })
map('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>', { silent = true })
map('n', '<leader>cd', '<cmd>Trouble diagnostics toggle<CR>', { silent = true })
map('n', '<leader>co', "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", { silent = true })
map('n', '<leader>cs', "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>", { silent = true })
map('n', '<leader>cj', '<cmd>lua vim.diagnostic.goto_next()<CR>', { silent = true })
map('n', '<leader>ck', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { silent = true })
map('n', '<leader>cp', '<cmd>lua vim.diagnostic.setqflist()<CR>', { silent = true })
map('n', '<leader>lf', "<cmd>lua require('lsp-setup').toggle_autoformat()<CR>", { silent = true })
map('n', '<leader>sy', ':SynStack<CR>')

if vim.fn.executable('rg') == 1 then
  map('n', '<Leader>ag', ':Rg ')
elseif vim.fn.executable('ag') == 1 then
  map('n', '<Leader>ag', ':Ag ')
end

map('n', '<leader>fv', ':Vista!!<CR>')

map('n', '<Leader>gst', ':G<CR>')
map('n', '<Leader>gco', ':G checkout ')
map('n', '<Leader>gp', ':G push<CR>')
map('n', '<Leader>gpf', ':G push --force-with-lease --force-if-includes<CR>')
map('n', '<Leader>gb', ':Gblame<CR>')
