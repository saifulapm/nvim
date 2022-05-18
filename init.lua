local present, impatient = pcall(require, 'impatient')

if present then
  impatient.enable_profile()
end

local core_modules = {
  'core',
  'core.options',
  'core.autocmds',
  'core.statusline',
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
