local lspconfig = require 'lspconfig'

local M = {}

M.setup = function(on_attach, capabilities)
  lspconfig.denols.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern 'deno.json',
    init_options = {
      lint = true,
    },
  }
end

return M
