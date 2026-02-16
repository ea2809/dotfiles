local ok_dap, dap = pcall(require, 'dap')
local ok_dapui, dapui = pcall(require, 'dapui')
local ok_mason_dap, mason_dap = pcall(require, 'mason-nvim-dap')
if not (ok_dap and ok_dapui and ok_mason_dap) then
  return
end

mason_dap.setup({
  ensure_installed = {
    'python',
    'delve',
    'codelldb',
  },
  automatic_installation = true,
  handlers = {},
})

pcall(function()
  require('nvim-dap-virtual-text').setup({})
end)

dapui.setup({
  expand_lines = true,
})

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end

dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticSignInfo', linehl = 'Visual', numhl = '' })

pcall(function()
  local dap_python = require('dap-python')
  local debugpy_python = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python'
  if vim.fn.executable(debugpy_python) == 1 then
    dap_python.setup(debugpy_python)
  elseif vim.fn.executable('python3') == 1 then
    dap_python.setup('python3')
  else
    dap_python.setup('python')
  end
end)

pcall(function()
  require('dap-go').setup({
    delve = {
      detached = vim.fn.has('win32') == 0,
    },
  })
end)

local codelldb = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb'
if vim.fn.has('linux') == 1 then
elseif vim.fn.has('win32') == 1 then
  codelldb = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb.exe'
end

if vim.fn.executable(codelldb) == 1 then
  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = codelldb,
      args = { '--port', '${port}' },
    },
  }

  dap.configurations.rust = {
    {
      name = 'Launch file',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      sourceLanguages = { 'rust' },
    },
    {
      name = 'Debug tests (cargo test)',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to test binary: ', vim.fn.getcwd() .. '/target/debug/deps/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      sourceLanguages = { 'rust' },
    },
  }

  dap.configurations.cpp = dap.configurations.rust
  dap.configurations.c = dap.configurations.rust
end

local map = vim.keymap.set
map('n', '<leader>dc', dap.continue, { desc = 'DAP Continue' })
map('n', '<leader>dn', dap.step_over, { desc = 'DAP Step Over' })
map('n', '<leader>di', dap.step_into, { desc = 'DAP Step Into' })
map('n', '<leader>du', dap.step_out, { desc = 'DAP Step Out' })
map('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP Toggle Breakpoint' })
map('n', '<leader>dB', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'DAP Conditional Breakpoint' })
map('n', '<leader>dr', dap.repl.open, { desc = 'DAP REPL' })
map('n', '<leader>dl', dap.run_last, { desc = 'DAP Run Last' })
map('n', '<leader>dt', dap.terminate, { desc = 'DAP Terminate' })
map('n', '<leader>dx', dapui.toggle, { desc = 'DAP UI Toggle' })
