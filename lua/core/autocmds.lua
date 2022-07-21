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

-- G.augroup('FormatOptions', {
--   {
--     event = { 'FileType' },
--     pattern = { '*' },
--     command = ':setlocal formatoptions-=c formatoptions-=o formatoptions+=r formatoptions+=n',
--   },
-- })

G.augroup('TextYankHighlight', {
  {
    -- don't execute silently in case of errors
    event = { 'TextYankPost' },
    pattern = { '*' },
    command = function()
      vim.highlight.on_yank {
        timeout = 500,
        on_visual = false,
        higroup = 'Visual',
      }
    end,
  },
})

G.command('TASKS', ':e $SYNC_DIR/neorg/Tasks.norg')

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
