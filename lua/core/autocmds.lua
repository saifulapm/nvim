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
vim.cmd [[command! -nargs=* PackerCompile lua require 'plugins' require('packer').compile(<q-args>)]]
vim.cmd "silent! command PackerInstall lua require 'plugins' require('packer').install()"
vim.cmd "silent! command PackerStatus lua require 'plugins' require('packer').status()"
vim.cmd [[command! -nargs=* -complete=customlist,v:lua.require'plugins' PackerUpdate lua require('packer').update(<f-args>)]]
vim.cmd [[command! -nargs=* -complete=customlist,v:lua.require'plugins' PackerSync lua require('packer').sync(<f-args>)]]
vim.cmd [[command! -bang -nargs=+ -complete=customlist,v:lua.require'plugins' PackerLoad lua require('packer').loader(<f-args>, '<bang>' == '!')]]

-- Nvim Align
vim.cmd "command! -range=% -nargs=1 Align lua require('utils.align').align(<f-args>)"
