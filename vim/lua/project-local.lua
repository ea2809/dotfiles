local M = {}

local trust_file = vim.fn.stdpath('state') .. '/trusted-projects.txt'
local loaded = {}

local function ensure_state_dir()
  vim.fn.mkdir(vim.fn.fnamemodify(trust_file, ':h'), 'p')
end

local function cwd()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':p')
end

local function local_config_path(dir)
  return vim.fs.joinpath(dir or cwd(), '.nvim.lua')
end

local function read_trusted()
  local trusted = {}
  if vim.fn.filereadable(trust_file) == 0 then
    return trusted
  end
  for _, line in ipairs(vim.fn.readfile(trust_file)) do
    if line ~= '' then
      trusted[line] = true
    end
  end
  return trusted
end

local function write_trusted(trusted)
  ensure_state_dir()
  local lines = {}
  for dir, ok in pairs(trusted) do
    if ok then
      table.insert(lines, dir)
    end
  end
  table.sort(lines)
  vim.fn.writefile(lines, trust_file)
end

local function is_trusted(dir)
  return read_trusted()[dir or cwd()] == true
end

function M.source_if_trusted(dir)
  local project_dir = dir or cwd()
  local cfg = local_config_path(project_dir)
  if vim.fn.filereadable(cfg) == 0 then
    return false
  end
  if not is_trusted(project_dir) then
    return false
  end
  if loaded[cfg] then
    return true
  end

  local ok, err = pcall(dofile, cfg)
  if ok then
    loaded[cfg] = true
    vim.notify('Loaded project config: ' .. cfg)
    return true
  end

  vim.notify('Failed to load project config: ' .. err, vim.log.levels.ERROR)
  return false
end

function M.trust_current()
  local project_dir = cwd()
  local trusted = read_trusted()
  trusted[project_dir] = true
  write_trusted(trusted)
  vim.notify('Trusted project: ' .. project_dir)
  M.source_if_trusted(project_dir)
end

function M.untrust_current()
  local project_dir = cwd()
  local trusted = read_trusted()
  trusted[project_dir] = nil
  write_trusted(trusted)
  loaded[local_config_path(project_dir)] = nil
  vim.notify('Untrusted project: ' .. project_dir)
end

function M.init_local_config()
  local project_dir = cwd()
  local target = local_config_path(project_dir)
  if vim.fn.filereadable(target) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(target))
    return
  end

  local template = vim.fn.expand('~/dotfiles/vim/.nvim.lua.example')
  if vim.fn.filereadable(template) == 1 then
    vim.fn.writefile(vim.fn.readfile(template), target)
  else
    vim.fn.writefile({ '-- Project-local Neovim config' }, target)
  end

  vim.cmd('edit ' .. vim.fn.fnameescape(target))
  vim.notify('Created project config: ' .. target)
end

function M.edit_local_config()
  vim.cmd('edit ' .. vim.fn.fnameescape(local_config_path(cwd())))
end

function M.status()
  local project_dir = cwd()
  local cfg = local_config_path(project_dir)
  local exists = vim.fn.filereadable(cfg) == 1
  local trusted = is_trusted(project_dir)
  vim.notify(string.format('Project local: exists=%s trusted=%s path=%s', tostring(exists), tostring(trusted), cfg))
end

function M.setup()
  vim.api.nvim_create_user_command('ProjectLocalTrust', function()
    M.trust_current()
  end, {})

  vim.api.nvim_create_user_command('ProjectLocalUntrust', function()
    M.untrust_current()
  end, {})

  vim.api.nvim_create_user_command('ProjectLocalInit', function()
    M.init_local_config()
  end, {})

  vim.api.nvim_create_user_command('ProjectLocalEdit', function()
    M.edit_local_config()
  end, {})

  vim.api.nvim_create_user_command('ProjectLocalStatus', function()
    M.status()
  end, {})

  local group = vim.api.nvim_create_augroup('ProjectLocalLoader', { clear = true })
  vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
    group = group,
    callback = function()
      M.source_if_trusted(cwd())
    end,
  })
end

return M
