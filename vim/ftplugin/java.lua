local ok_jdtls, jdtls = pcall(require, 'jdtls')
if not ok_jdtls then
  return
end

local ok_jdtls_setup, jdtls_setup = pcall(require, 'jdtls.setup')
if not ok_jdtls_setup then
  return
end

local root_markers = { 'gradlew', 'mvnw', 'pom.xml', 'build.gradle', 'settings.gradle', '.git' }
local root_dir = jdtls_setup.find_root(root_markers)
if root_dir == '' then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
local mason_path = vim.fn.stdpath('data') .. '/mason/packages'
local jdtls_install = mason_path .. '/jdtls'

local bundles = {}
for _, jar in ipairs(vim.split(vim.fn.glob(mason_path .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true), '\n')) do
  if jar ~= '' then
    table.insert(bundles, jar)
  end
end
for _, jar in ipairs(vim.split(vim.fn.glob(mason_path .. '/java-test/extension/server/*.jar', true), '\n')) do
  if jar ~= ''
      and not jar:match('com%.microsoft%.java%.test%.runner%-jar%-with%-dependencies%.jar$')
      and not jar:match('jacocoagent%.jar$') then
    table.insert(bundles, jar)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local cmd = { 'jdtls', '-data', workspace_dir }
local lombok_path = jdtls_install .. '/lombok.jar'
if vim.fn.filereadable(lombok_path) == 1 then
  table.insert(cmd, 2, '--jvm-arg=-javaagent:' .. lombok_path)
end

local config = {
  cmd = cmd,
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.junit.Assert.*',
          'org.junit.jupiter.api.Assertions.*',
          'org.mockito.Mockito.*',
        },
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
      },
      project = {
        resourceFilters = {
          '.git',
          '.idea',
          '.bloop',
          '.metals',
          'target',
          'build',
          '*.zip',
        },
      },
      format = {
        enabled = true,
      },
    },
  },
  init_options = {
    bundles = bundles,
  },
}

jdtls.start_or_attach(config)
if type(jdtls.setup_dap) == 'function' then
  pcall(jdtls.setup_dap, { hotcodereplace = 'auto' })
end
if jdtls.dap and type(jdtls.dap.setup_dap_main_class_configs) == 'function' then
  pcall(jdtls.dap.setup_dap_main_class_configs)
end

vim.keymap.set('n', '<leader>gt', vim.lsp.buf.definition, { buffer = true, silent = true })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true, silent = true })
