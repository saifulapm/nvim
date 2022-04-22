local present, impatient = pcall(require, 'impatient')

if present then
  impatient.enable_profile()
end

----------------------------------------------------------------------------------------------------
-- Default plugins
----------------------------------------------------------------------------------------------------
vim.g.loaded_netrwPlugin = 1

local core_modules = {
  'core',
  'core.options',
  'core.autocmds',
  'core.statusline',
  '_compiled',
}

for _, module in ipairs(core_modules) do
  pcall(require, module)
end

-- Load keybindings module at the end because the keybindings module cost is high
vim.defer_fn(function()
  require('core.mappings').basic()
end, 20)
