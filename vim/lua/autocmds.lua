local aug = vim.api.nvim_create_augroup
local auc = vim.api.nvim_create_autocmd

auc('QuickFixCmdPost', {
  group = aug('QuickfixAutoOpen', { clear = true }),
  pattern = { 'grep', 'vimgrep' },
  command = 'cwindow',
})

auc('FocusGained', {
  group = aug('ChecktimeOnFocus', { clear = true }),
  pattern = '*',
  command = 'silent! checktime',
})

auc({ 'BufRead', 'BufNewFile' }, {
  group = aug('ExtraFiletypes', { clear = true }),
  pattern = '*.sbt',
  callback = function()
    vim.bo.filetype = 'scala'
  end,
})

auc({ 'BufRead', 'BufNewFile' }, {
  group = aug('FeatureFiletype', { clear = true }),
  pattern = '*.feature',
  callback = function()
    vim.bo.filetype = 'gherkin'
  end,
})

auc({ 'BufRead', 'BufNewFile' }, {
  group = aug('YamlFiletype', { clear = true }),
  pattern = { '*.yaml', '*.yml' },
  callback = function()
    vim.bo.filetype = 'yaml'
    vim.opt_local.foldmethod = 'indent'
  end,
})

auc({ 'BufRead', 'BufNewFile' }, {
  group = aug('JsonFiletype', { clear = true }),
  pattern = '*.json',
  callback = function()
    vim.bo.filetype = 'json'
  end,
})

auc({ 'BufRead', 'BufNewFile' }, {
  group = aug('DotEnvFiletype', { clear = true }),
  pattern = '.env',
  callback = function()
    vim.bo.filetype = 'sh'
  end,
})

auc('FileType', {
  group = aug('CfgFiletypeOpts', { clear = true }),
  pattern = 'cfg',
  callback = function()
    vim.opt_local.commentstring = '# %s'
  end,
})

auc('FileType', {
  group = aug('CucumberSyntax', { clear = true }),
  pattern = 'gherkin',
  command = 'silent! source ~/dotfiles/vim/cucumber.vim',
})

auc('TermOpen', {
  group = aug('TerminalStuff', { clear = true }),
  pattern = '*',
  callback = function()
    vim.opt.sidescrolloff = 0
  end,
})

auc('TermClose', {
  group = aug('TerminalStuff', { clear = false }),
  pattern = '*',
  callback = function()
    vim.opt.sidescrolloff = 15
  end,
})

local large_file_bytes = 1024 * 1024 * 10
auc('BufReadPre', {
  group = aug('LargeFile', { clear = true }),
  pattern = '*',
  callback = function(args)
    local fsize = vim.fn.getfsize(args.file)
    if fsize > large_file_bytes or fsize == -2 then
      vim.opt.eventignore:append('FileType')
      vim.bo.bufhidden = 'unload'
      vim.bo.buftype = 'nowrite'
      vim.bo.undolevels = -1
      vim.schedule(function()
        vim.notify('Large file mode enabled (>10MB): ' .. args.file, vim.log.levels.INFO)
      end)
    end
  end,
})

auc('FileType', {
  group = aug('PythonSemshiHighlights', { clear = true }),
  pattern = 'python',
  callback = function()
    vim.cmd([[
      hi semshiLocal           ctermfg=209 guifg=#d65d0e
      hi semshiGlobal          ctermfg=214 guifg=#8ec07c
      hi semshiImported        ctermfg=214 guifg=#8ec07c cterm=bold gui=bold
      hi semshiParameter       ctermfg=75  guifg=#83a598
      hi semshiParameterUnused ctermfg=117 guifg=#458588 cterm=underline gui=underline
      hi semshiFree            ctermfg=218 guifg=#d3869b
      hi semshiBuiltin         ctermfg=207 guifg=#b16286
      hi semshiAttribute       ctermfg=49  guifg=#fe8019
      hi semshiSelf            ctermfg=249 guifg=#fb4934
      hi semshiUnresolved      ctermfg=226 guifg=#fabd2f cterm=underline gui=underline
      hi semshiSelected        ctermfg=231 guifg=#ebdbb2 ctermbg=161 guibg=#b57614

      hi semshiErrorSign       ctermfg=231 guifg=#ebdbb2 ctermbg=160 guibg=#fb4934
      hi semshiErrorChar       ctermfg=231 guifg=#ebdbb2 ctermbg=160 guibg=#fb4934
      sign define semshiError text=E> texthl=semshiErrorSign
    ]])
  end,
})
