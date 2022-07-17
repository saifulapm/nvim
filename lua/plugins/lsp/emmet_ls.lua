local M = {}

M.setup = function(on_attach, capabilities)
  require('lspconfig').emmet_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
  }
end

return M
