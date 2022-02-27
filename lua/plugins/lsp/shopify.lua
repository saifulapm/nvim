local M = {}
M.setup = function(on_attach, capabilities)
  require('lspconfig').theme_check.setup {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
    end,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
