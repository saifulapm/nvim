local map = require('utils').map

local ls = require 'luasnip'
local types = require 'luasnip.util.types'

ls.config.set_config {
  history = false,
  region_check_events = 'CursorMoved,CursorHold,InsertEnter',
  delete_check_events = 'InsertLeave',
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { '●', 'Operator' } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { '●', 'Type' } },
      },
    },
  },
  enable_autosnippets = true,
}

map('s', '<c-j>', function()
  ls.jump(1)
end)
map('s', '<c-k>', function()
  ls.jump(-1)
end)

-- NOTE: load external snippets last so they are not overruled by ls.snippets
require('luasnip.loaders.from_vscode').load { paths = './snippets' }
-- require 'utils.snippets'
