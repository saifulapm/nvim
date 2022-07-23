local opt = vim.opt
local g = vim.g

-- use filetype.lua instead of filetype.vim
g.did_load_filetypes = 0
g.do_filetype_lua = 1

opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.title = true
opt.clipboard = 'unnamedplus'
opt.cul = true -- cursor line

-- Indenting
opt.expandtab = true
opt.shiftwidth = 3
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.mouse = 'a'
opt.ruler = false

-- disable nvim intro
opt.shortmess:append 'sI'

opt.signcolumn = 'yes'
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 8
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append '<>[]hl'

g.mapleader = ' '
g.maplocalleader = ','

-----------------------------------------------------------------------------//
-- Window splitting and buffers {{{1
-----------------------------------------------------------------------------//
opt.eadirection = 'hor'
vim.o.switchbuf = 'useopen,uselast'
opt.fillchars = {
  fold = ' ',
  eob = ' ', -- suppress ~ at EndOfBuffer
  diff = '╱', -- alternatives = ⣿ ░ ─
  msgsep = '‾',
  foldopen = '▾',
  foldsep = '│',
  foldclose = '▸',
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┨',
  vertright = '┣',
  verthoriz = '╋',
}
-- }}}

-----------------------------------------------------------------------------//
-- Title {{{1
-----------------------------------------------------------------------------//
function G.modified_icon()
  return vim.bo.modified and G.style.icons.misc.circle or ''
end
opt.titlestring = '%{fnamemodify(getcwd(), ":t")} %{v:lua.G.modified_icon()}'
opt.titleold = vim.fn.fnamemodify(vim.loop.os_getenv 'SHELL', ':t')
opt.title = true
opt.titlelen = 70
--}}}

-----------------------------------------------------------------------------//
-- Utilities {{{1
-----------------------------------------------------------------------------//
opt.sessionoptions = {
  'globals',
  'buffers',
  'curdir',
  'winpos',
  'tabpages',
}
opt.viewoptions = { 'cursor', 'folds' } -- save/restore just these (with `:{mk,load}view`)
opt.virtualedit = 'block' -- allow cursor to move where there is no text in visual block mode
--}}}

-----------------------------------------------------------------------------//
-- Spelling {{{1
-----------------------------------------------------------------------------//
opt.spell = true
opt.spellsuggest:prepend { 12 }
opt.spelloptions = 'camel'
opt.spellcapcheck = '' -- don't check for capital letters at start of sentence
opt.fileformats = { 'unix', 'mac', 'dos' }
--}}}

local default_providers = {
  'node',
  'perl',
  'python3',
  'ruby',
}

for _, provider in ipairs(default_providers) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end
