local present, cmp = pcall(require, 'cmp')

if not present then
  return
end

local u = require 'utils.color'
local kinds = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '', -- '',
  Variable = '', -- '',
  Class = '', -- '',
  Interface = '',
  Module = '',
  Property = 'ﰠ',
  Unit = '塞',
  Value = '',
  Enum = '',
  Keyword = '', -- '',
  Snippet = '', -- '', '',
  Color = '',
  File = '',
  Reference = '', -- '',
  Folder = '',
  EnumMember = '',
  Constant = '', -- '',
  Struct = '', -- 'פּ',
  Event = '',
  Operator = '',
  TypeParameter = '',
}
local cmp_window = {
  border = G.style.border.line,
  winhighlight = table.concat({
    'Normal:NormalFloat',
    'FloatBorder:FloatBorder',
    'CursorLine:Visual',
    'Search:None',
  }, ','),
}

local kind_highlights = G.style.kinds

local kind_hls = vim.tbl_map(function(key)
  return { 'CmpItemKind' .. key, { foreground = u.get_hl(kind_highlights[key], 'fg') } }
end, vim.tbl_keys(kind_highlights))

-- Highligh Overwite
local keyword_fg = u.get_hl('Keyword', 'fg')
u.overwrite {
  { 'CmpBorderedWindow_Normal', { link = 'NormalFloat' } },
  { 'CmpItemAbbr', { foreground = 'fg', background = 'NONE', italic = false, bold = false } },
  { 'CmpItemMenu', { inherit = 'NonText', italic = false, bold = false } },
  { 'CmpItemAbbrMatch', { foreground = keyword_fg } },
  { 'CmpItemAbbrDeprecated', { strikethrough = true, inherit = 'Comment' } },
  { 'CmpItemAbbrMatchFuzzy', { italic = true, foreground = keyword_fg } },
  unpack(kind_hls),
}

-- local t = function(str)
--   return api.nvim_replace_termcodes(str, true, true, true)
-- end

local function tab(fallback)
  local ok, luasnip = pcall(require, 'luasnip')
  if cmp.visible() then
    cmp.select_next_item()
  elseif ok and luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end

local function shift_tab(fallback)
  local ok, luasnip = pcall(require, 'luasnip')
  if cmp.visible() then
    cmp.select_prev_item()
  elseif ok and luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

local function ctl_d(fallback)
  local ls, luasnip = pcall(require, 'luasnip')
  if cmp.visible() and cmp.get_selected_entry() then
    cmp.scroll_docs(-4)
  elseif ls and luasnip.choice_active() then
    require('luasnip').change_choice(-1)
  else
    fallback()
  end
end

local function ctl_f(fallback)
  local ls, luasnip = pcall(require, 'luasnip')
  if cmp.visible() and cmp.get_selected_entry() then
    cmp.scroll_docs(4)
  elseif ls and luasnip.choice_active() then
    require('luasnip').change_choice(1)
  else
    fallback()
  end
end

cmp.setup {
  window = {
    completion = cmp.config.window.bordered(cmp_window),
    documentation = cmp.config.window.bordered(cmp_window),
  },
  completion = {
    keyword_length = 2, -- avoid keyword completion
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    -- ['<c-h>'] = cmp.mapping(function()
    --   vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](t '<Tab>'), 'n', true)
    -- end),
    ['<Tab>'] = cmp.mapping(tab, { 'i', 'c' }),
    ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(ctl_d, { 'i', 's' }),
    ['<C-f>'] = cmp.mapping(ctl_f, { 'i', 's' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
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
  sources = cmp.config.sources {
    { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=] },
  },
})
