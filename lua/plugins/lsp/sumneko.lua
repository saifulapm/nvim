local M = {}
local root = vim.fn.getenv 'HOME' .. '/sdk/lua-language-server/'
local binary = root .. 'bin/lua-language-server'

M.setup = function(on_attach, capabilities)
  local luadev = require('lua-dev').setup {
    lspconfig = {
      on_attach = on_attach,
      cmd = { binary, '-E', root .. 'main.lua' },
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              'vim',
              'describe',
              'it',
              'before_each',
              'after_each',
              'pending',
              'teardown',
              'packer_plugins',
            },
          },
          completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
        },
      },
      flags = {
        debounce_text_changes = 150,
      },
      capabilities = capabilities,
    },
  }

  require('lspconfig').sumneko_lua.setup(luadev)
end

return M
