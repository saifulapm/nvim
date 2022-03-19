local M = {}
M.setup = function(on_attach, capabilities)
  require('lspconfig').vuels.setup {
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      on_attach(client, bufnr)
    end,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
    init_options = {
      config = {
        vetur = {
          ignoreProjectWarning = true,
        },
      },
    },
  }
end

return M
