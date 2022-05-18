local u = require 'utils.lsp'

if not packer_plugins['nvim-lsp-installer'].loaded then
  vim.cmd [[PackerLoad nvim-lsp-installer]]
  vim.cmd [[PackerLoad lua-dev.nvim]]
  vim.cmd [[PackerLoad cmp-nvim-lsp]]
  vim.cmd [[PackerLoad null-ls.nvim]]
  vim.cmd [[PackerLoad typescript.nvim]]
  vim.cmd [[PackerLoad vim-illuminate]]
  vim.cmd [[PackerLoad lsp-format.nvim]]
end

require('nvim-lsp-installer').setup {
  automatic_installation = true,
}
require('lsp-format').setup {}

u.lsp_handlers()

local function on_attach(client, bufnr)
  G.augroup('LspAutoCommands', {
    {
      event = { 'CursorHold' },
      buffer = bufnr,
      command = function()
        u.diagnostic_popup()
      end,
    },
  })
  require('lsp-format').on_attach(client)
  require('core.mappings').lspconfig(client, bufnr)
  require('illuminate').on_attach(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

for _, server in
  ipairs {
    'intelephense',
    'shopify',
    'eslint',
    -- 'jsonls',
    'null_ls',
    'sumneko',
    'vuels',
    -- 'tsserver',
    'typescript',
    -- 'dart',
    -- 'bashls',
    -- 'denols',
  }
do
  require('plugins.lsp.' .. server).setup(on_attach, capabilities)
end
