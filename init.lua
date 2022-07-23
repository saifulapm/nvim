-- Saiful's Config
vim.g.dotfiles = vim.env.DOTFILES or vim.fn.expand '~/.dotfiles'
vim.g.vim_dir = vim.g.dotfiles .. '/.config/nvim'

-- Stop loading built in plugins
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.logipat = 1
vim.g.loaded_gzip = 1

local present, impatient = pcall(require, 'impatient')

if present then
  impatient.enable_profile()
end

local core_modules = {
  'core',
  'core.options',
  'core.autocmds',
  'core.highlights',
  '_compiled',
}

if vim.g.vscode ~= nil then
  require 'vscode'
else
  for _, module in ipairs(core_modules) do
    pcall(require, module)
  end

  -- Load keybindings module at the end because the keybindings module cost is high
  vim.defer_fn(function()
    require('core.mappings').basic()
  end, 20)
end
