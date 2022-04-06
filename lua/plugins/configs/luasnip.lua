local present, luasnip = pcall(require, 'luasnip')

if not present then
  return
end

-- LuaSnip Setup
local types = require 'luasnip.util.types'
local extras = require 'luasnip.extras'
local fmt = require('luasnip.extras.fmt').fmt

luasnip.config.set_config {
  history = false,
  region_check_events = 'CursorMoved,CursorHold,InsertEnter',
  delete_check_events = 'InsertLeave',
  ext_opts = {
    [types.choiceNode] = {
      active = {
        hl_mode = 'combine',
        virt_text = { { '●', 'Operator' } },
      },
    },
    [types.insertNode] = {
      active = {
        hl_mode = 'combine',
        virt_text = { { '●', 'Type' } },
      },
    },
  },
  enable_autosnippets = true,
  snip_env = {
    fmt = fmt,
    m = extras.match,
    t = luasnip.text_node,
    f = luasnip.function_node,
    c = luasnip.choice_node,
    d = luasnip.dynamic_node,
    i = luasnip.insert_node,
    snippet = luasnip.snippet,
  },
}

vim.keymap.set({ 's', 'i' }, '<c-j>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end)

-- <C-K> is easier to hit but swallows the digraph key
vim.keymap.set({ 's', 'i' }, '<c-b>', function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end)

require('luasnip.loaders.from_lua').lazy_load()
require('luasnip.loaders.from_vscode').load { paths = './snippets' }
luasnip.filetype_extend('dart', { 'flutter' })
