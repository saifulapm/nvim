local present, cmp = pcall(require, 'cmp')

if not present then
  return
end

local api = vim.api
local u = require 'utils.color'
local kinds = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = '',
  Interface = '',
  Module = '',
  Property = 'ﰠ',
  Unit = '塞',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = 'פּ',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

local kind_highlights = G.style.kinds

local kind_hls = vim.tbl_map(function(key)
  return { 'CmpItemKind' .. key, { foreground = u.get_hl(kind_highlights[key], 'fg') } }
end, vim.tbl_keys(kind_highlights))

-- Highligh Overwite
local keyword_fg = u.get_hl('Keyword', 'fg')
u.overwrite {
  { 'CmpItemAbbr', { foreground = 'fg', background = 'NONE', italic = false, bold = false } },
  { 'CmpItemMenu', { inherit = 'NonText', italic = false, bold = false } },
  { 'CmpItemAbbrMatch', { foreground = keyword_fg } },
  { 'CmpItemAbbrDeprecated', { strikethrough = true, inherit = 'Comment' } },
  { 'CmpItemAbbrMatchFuzzy', { italic = true, foreground = keyword_fg } },
  unpack(kind_hls),
}

local t = function(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

local function feed(key, mode)
  api.nvim_feedkeys(t(key), mode or '', true)
end

local function get_luasnip()
  local ok, luasnip = pcall(require, 'luasnip')
  if not ok then
    return nil
  end
  return luasnip
end

local function cntlh(fallback)
  local luasnip = get_luasnip()
  if luasnip and luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end

local function tab(fallback)
  local luasnip = get_luasnip()
  local copilot_keys = vim.fn['copilot#Accept']()
  if cmp.visible() then
    cmp.select_next_item()
  elseif copilot_keys ~= '' then -- prioritise copilot over snippets
    -- Copilot keys do not need to be wrapped in termcodes
    feed(copilot_keys, 'i')
  elseif luasnip and luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end

local function shift_tab(fallback)
  local luasnip = get_luasnip()
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip and luasnip.jumpable(-1) then
    luasnip.jump(-1)
  elseif api.nvim_get_mode().mode == 'c' then
    fallback()
  else
    local copilot_keys = vim.fn['copilot#Accept']()
    if copilot_keys ~= '' then
      feed(copilot_keys, 'i')
    else
      fallback()
    end
  end
end

cmp.setup {
  window = {
    completion = {
      -- TODO: consider 'shadow', and tweak the winhighlight
      border = 'rounded',
    },
    documentation = {
      border = 'rounded',
    },
  },
  completion = {
    keyword_length = 2, -- avoid keyword completion
  },
  experimental = {
    ghost_text = false, -- disable whilst using copilot
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<c-h>'] = cmp.mapping(function()
      vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](t '<Tab>'), 'n', true)
    end),
    ['<c-j>'] = cmp.mapping(cntlh, { 'i' }),
    ['<Tab>'] = cmp.mapping(tab, { 'i', 'c' }),
    ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.config.disable,
    ['<C-space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  formatting = {
    deprecated = true,
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      vim_item.kind = kinds[vim_item.kind]
      local name = entry.source.name
      -- FIXME: automate this using a regex to normalise names
      local menu = ({
        nvim_lsp = '[LSP]',
        nvim_lua = '[Lua]',
        emoji = '[Emoji]',
        path = '[Path]',
        calc = '[Calc]',
        neorg = '[Neorg]',
        orgmode = '[Org]',
        cmp_tabnine = '[TN]',
        luasnip = '[Luasnip]',
        buffer = '[Buffer]',
        fuzzy_buffer = '[Fuzzy Buffer]',
        fuzzy_path = '[Fuzzy Path]',
        spell = '[Spell]',
        cmdline = '[Command]',
      })[name]

      vim_item.menu = menu
      return vim_item
    end,
  },
  documentation = {
    border = 'rounded',
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'spell' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
}

local search_sources = {
  completion = {
    keyword_length = 2, -- avoid keyword completion
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' },
  }, {
    { name = 'buffer' },
  }),
}

-- Use buffer source for `/`.
cmp.setup.cmdline('/', search_sources)

cmp.setup.cmdline('?', search_sources)

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  completion = {
    keyword_length = 2, -- avoid keyword completion
  },
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
