-- remove the "t" option added by dart-vim-plugin which forces lines to autowrap at text
-- width which is very annoying
vim.opt_local.formatoptions:remove 't'

-- TODO: ask treesitter team what the correct way to do this is
-- disable syntax based highlighting for dart and use only treesitter
-- this still lets the syntax file be loaded for things like the LSP.
vim.opt_local.syntax = ''
