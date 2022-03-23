-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
vim.cmd [[ au InsertEnter * set norelativenumber ]]
vim.cmd [[ au InsertLeave * set relativenumber ]]
vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
vim.cmd [[autocmd FileType * setlocal formatoptions-=c formatoptions-=o]]
-- But insert comment leader after hitting <CR> and respect 'numbered' lists
vim.cmd [[autocmd FileType * setlocal formatoptions+=r formatoptions+=n]]

-- Highlight yanked text
vim.cmd [[autocmd TextYankPost * silent! lua vim.highlight.on_yank()]]

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
