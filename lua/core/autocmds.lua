vim.cmd [[
   augroup vimrc -- Ensure all autocommands are cleared
   autocmd!
   augroup END
]]

G.augroup('VimrcIncSearchHighlight', {
  {
    -- automatically clear search highlight once leaving the commandline
    event = { 'CmdlineEnter' },
    pattern = { '[/\\?]' },
    command = ':set hlsearch  | redrawstatus',
  },
  {
    event = { 'CmdlineLeave' },
    pattern = { '[/\\?]' },
    command = function()
      vim.defer_fn(function()
        vim.cmd ':set nohlsearch | redrawstatus'
      end, 10000)
    end,
  },
})

G.augroup('Numbers', {
  {
    -- Open images in an image viewer (probably Preview)
    event = { 'InsertEnter' },
    pattern = { '*' },
    command = ':set norelativenumber',
  },
  {
    -- Open images in an image viewer (probably Preview)
    event = { 'InsertLeave' },
    pattern = { '*' },
    command = ':set relativenumber',
  },
})

G.augroup('FormatOptions', {
  {
    event = { 'FileType' },
    pattern = { '*' },
    command = ':setlocal formatoptions-=c formatoptions-=o formatoptions+=r formatoptions+=n',
  },
})

G.augroup('TextYankHighlight', {
  {
    -- don't execute silently in case of errors
    event = { 'TextYankPost' },
    pattern = '*',
    command = function()
      vim.highlight.on_yank {
        timeout = 500,
        on_visual = false,
        higroup = 'Visual',
      }
    end,
  },
})

--- automatically clear commandline messages after a few seconds delay
--- source: http://unix.stackexchange.com/a/613645
---@return function
local function clear_commandline()
  local timer
  return function()
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      if vim.fn.mode() == 'n' then
        vim.cmd [[echon '']]
      end
    end, 2000)
  end
end

G.augroup('ClearCommandMessages', {
  {
    event = { 'CmdlineLeave', 'CmdlineChanged' },
    pattern = { ':' },
    command = clear_commandline(),
  },
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
-- vim.cmd [[autocmd FileType * setlocal formatoptions-=c formatoptions-=o]]
-- But insert comment leader after hitting <CR> and respect 'numbered' lists
-- vim.cmd [[autocmd FileType * setlocal formatoptions+=r formatoptions+=n]]

-----------------------------------------------------------------------------//
-- Autoresize
-----------------------------------------------------------------------------//
-- Auto resize Vim splits to active split to 70% -
-- https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window

local auto_resize = function()
  local auto_resize_on = false
  return function(args)
    if not auto_resize_on then
      local factor = args and tonumber(args) or 70
      local fraction = factor / 10
      -- NOTE: mutating &winheight/&winwidth are key to how
      -- this functionality works, the API fn equivalents do
      -- not work the same way
      vim.cmd(string.format('let &winheight=&lines * %d / 10 ', fraction))
      vim.cmd(string.format('let &winwidth=&columns * %d / 10 ', fraction))
      auto_resize_on = true
      vim.notify 'Auto resize ON'
    else
      vim.cmd 'let &winheight=30'
      vim.cmd 'let &winwidth=30'
      vim.cmd 'wincmd ='
      auto_resize_on = false
      vim.notify 'Auto resize OFF'
    end
  end
end
G.command('AutoResize', auto_resize(), { nargs = '?' })
G.command('Todo', [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]], {})

G.command('TASKS', ':e $SYNC_DIR/neorg/Tasks.norg', {})

-- Plugins Mapping
vim.cmd "silent! command PackerClean lua require 'plugins' require('packer').clean()"
vim.cmd "silent! command PackerCompile lua require 'plugins' require('packer').compile()"
vim.cmd "silent! command PackerInstall lua require 'plugins' require('packer').install()"
vim.cmd "silent! command PackerStatus lua require 'plugins' require('packer').status()"
vim.cmd "silent! command PackerSync lua require 'plugins' require('packer').sync()"
vim.cmd "silent! command PackerUpdate lua require 'plugins' require('packer').update()"
vim.cmd [[command! -bang -nargs=+ -complete=customlist,v:lua.require'plugins',v:lua.require'packer'.loader_complete PackerLoad lua require('packer').loader(<f-args>, '<bang>' == '!')]]

-- Nvim Align
vim.cmd "command! -range=% -nargs=1 Align lua require('utils.align').align(<f-args>)"
