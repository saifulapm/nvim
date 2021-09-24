local present, cmp = pcall(require, "cmp")

if not present then
   return
end

local fn = vim.fn
local api = vim.api
local t = gl.replace_termcodes
local fmt = string.format

local function feed(key, mode)
  api.nvim_feedkeys(t(key), mode or '', true)
end

local function get_luasnip()
  local ok, luasnip = gl.safe_require('luasnip', { silent = true })
  if not ok then
    return nil
  end
  return luasnip
end

local function tab(_)
  local luasnip = get_luasnip()
  if fn.pumvisible() == 1 then
    feed('<C-n>', 'n')
  elseif luasnip and luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    feed '<Plug>(Tabout)'
  end
end

local function shift_tab(_)
  local luasnip = get_luasnip()
  if fn.pumvisible() == 1 then
    feed('<C-p>', 'n')
  elseif luasnip and luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    feed '<Plug>(TaboutBack)'
  end
end

cmp.setup {
  experimental = {
    ghost_text = false,
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(tab, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 's' }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  formatting = {
    deprecated = true,
    format = function(entry, vim_item)
      vim_item.kind = fmt('%s %s', gl.style.lsp.kinds[vim_item.kind], vim_item.kind)
      -- FIXME: automate this using a regex to normalise names
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        emoji = '[Emoji]',
        path = '[Path]',
        calc = '[Calc]',
        neorg = '[Neorg]',
        orgmode = '[Org]',
        luasnip = '[Luasnip]',
        buffer = '[Buffer]',
        spell = '[Spell]',
      })[entry.source.name]
      return vim_item
    end,
  },
  documentation = {
    border = 'rounded',
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'spell' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'neorg' },
    { name = 'orgmode' },
  },
}
