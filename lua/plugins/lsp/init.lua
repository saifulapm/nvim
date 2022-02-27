require('utils.lsp').lsp_handlers()

local function on_attach(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  require('core.mappings').lspconfig(client, bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

for _, server in ipairs {
  'intelephense',
  -- 'shopify',
  -- 'eslint',
  -- 'jsonls',
  'null_ls',
  'sumneko',
  -- 'tsserver',
  -- 'dart',
  -- 'bashls',
  -- 'denols',
} do
  require('plugins.lsp.' .. server).setup(on_attach, capabilities)
end
