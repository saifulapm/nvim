local cmp = require 'cmp'
local h = require 'core.highlights'

local api = vim.api
local fmt = string.format
local border = G.style.border.line
local lsp_hls = G.style.lsp.highlights
local ellipsis = G.style.icons.misc.ellipsis

-- Make the source information less prominent
local faded = h.alter_color(h.get('Pmenu', 'bg'), 30)

local kind_hls = G.fold(
  function(accum, value, key)
    accum['CmpItemKind' .. key] = { foreground = { from = value } }
    return accum
  end,
  lsp_hls,
  {
    CmpItemAbbr = { foreground = 'fg', background = 'NONE', italic = false, bold = false },
    CmpItemMenu = { foreground = faded, italic = true, bold = false },
    CmpItemAbbrMatch = { foreground = { from = 'Keyword' } },
    CmpItemAbbrDeprecated = { strikethrough = true, inherit = 'Comment' },
    CmpItemAbbrMatchFuzzy = { italic = true, foreground = { from = 'Keyword' } },
  }
)

h.plugin('Cmp', kind_hls)

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

local cmp_window = {
  border = border,
  winhighlight = table.concat({
    'Normal:NormalFloat',
    'FloatBorder:FloatBorder',
    'CursorLine:Visual',
    'Search:None',
  }, ','),
}

cmp.setup {
  experimental = { ghost_text = true },
  preselect = cmp.PreselectMode.None,
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
    ['<Tab>'] = cmp.mapping(tab, { 'i', 'c' }),
    ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(ctl_d, { 'i', 's' }),
    ['<C-f>'] = cmp.mapping(ctl_f, { 'i', 's' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ['<C-space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm { select = false },
  },
  formatting = {
    deprecated = true,
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      local MAX = math.floor(vim.o.columns * 0.5)
      vim_item.abbr = #vim_item.abbr >= MAX and string.sub(vim_item.abbr, 1, MAX) .. ellipsis
        or vim_item.abbr
      vim_item.kind = fmt('%s %s', G.style.icons.kinds.codicons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        nvim_lua = '[Lua]',
        emoji = '[E]',
        path = '[Path]',
        neorg = '[N]',
        luasnip = '[SN]',
        dictionary = '[D]',
        buffer = '[B]',
        spell = '[SP]',
        cmdline = '[Cmd]',
        cmdline_history = '[Hist]',
        orgmode = '[Org]',
        norg = '[Norg]',
        rg = '[Rg]',
        git = '[Git]',
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  }, {
    {
      name = 'buffer',
      options = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(api.nvim_list_wins()) do
            bufs[api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    { name = 'spell' },
  }),
}

local search_sources = {
  completion = {
    keyword_length = 2, -- avoid keyword completion
  },
  sources = cmp.config.sources {
    { name = 'buffer' },
  },
}

-- Use buffer source for `/`.
cmp.setup.cmdline('/', search_sources)

cmp.setup.cmdline('?', search_sources)

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  sources = cmp.config.sources {
    { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=] },
    { name = 'path' },
    { name = 'cmdline_history', priority = 10, max_item_count = 5 },
  },
})
